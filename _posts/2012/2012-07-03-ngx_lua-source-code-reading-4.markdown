--- 
layout: post
title: ngx-lua源码阅读笔记(4)
date: 2012-07-03 15:26:24 +08:00
category:
- dev
tags:
- nginx
- lua
---

`r->write_event_handler`是request这个结构的写事件处理函数，这个函数处理的是客户端与nginx之间的connection，而ngx-lua和google服务器之间的连接并不归他处理；所以，只有在进入content phase之后，才会注册`r->write_event_handler`，才会发送数据到客户端。

`ngx_http_lua_socket_tcp_connect()`函数在这里进行连接操作：

    if (u->resolved->sockaddr) {
        rc = ngx_http_lua_socket_resolve_retval_handler(r, u, L);
        if (rc == NGX_AGAIN) {
            return lua_yield(L, 0);
        }

        return rc;
    }

再来看`ngx_http_lua_socket_resolve_retval_handler()`

    rc = ngx_event_connect_peer(pc); //这个函数进行connect

后面会判断rc是否`NGX_OK`, 如果没连接成功，会注册`ngx_http_lua_socket_connected_handler()`，如果连接成功，则注册`ngx_http_lua_socket_dummy_handler()`，这是一个空函数。

    /* rc == NGX_OK || rc == NGX_AGAIN */

    c = pc->connection; //connection对象，事件循环的主要处理对象

    //将connection对象的data设置为这个upstream，这样当有事件触发时，
    //能通过data获取到upstream，从而获取到对应的处理函数。
    c->data = u;

    //读写时间触发的处理函数
    c->write->handler = ngx_http_lua_socket_tcp_handler; 
    c->read->handler = ngx_http_lua_socket_tcp_handler;

    //不同操作注册不同的处理函数，这里是connected handler，如果是socket.send
    //则为ngx_http_lua_socket_send_handler()
    u->write_event_handler = ngx_http_lua_socket_connected_handler; 
    u->read_event_handler = ngx_http_lua_socket_connected_handler;

    //设置sendfile标志位
    c->sendfile &= r->connection->sendfile;
    u->output.sendfile = c->sendfile;

    c->pool = r->pool;
    c->log = r->connection->log;
    c->read->log = c->log;
    c->write->log = c->log;

    /* init or reinit the ngx_output_chain() and ngx_chain_writer() contexts */
    //设置ngx_chain_writer_ctx_t，这个writer用于tcp_send时设置filter_ctx
    //后续调用ngx_output_chain，以及output_filter时，能正确的输出内容给connection对象，而不会走入发送给客户端。
    u->writer.out = NULL;
    u->writer.last = &u->writer.out;
    u->writer.connection = c;
    u->writer.limit = 0;
    u->request_sent = 0;

    ctx = ngx_http_get_module_ctx(r, ngx_http_lua_module);

    ctx->data = u; //这个地方貌似没啥用

上面的处理过程中ngx-lua使用了桥接模式，通过`ngx_http_lua_socket_tcp_handler()`抽象接口封装了connect/send/receive等不同操作，统一提供给事件模块调用。nginx的核心代码中大量使用了这种模式进行封装，在一个框架上同时支持网络IO，IPC，文件IO等操作，并且支持unix/linux/MAC/win32等多种操作系统。

`ngx_event_connect_peer()`中已经将connection对象添加到事件处理队列。注册完处理函数之后。如果连接建立成功，则调用`ngx_handle_write_event()`和`ngx_handle_read_event()`，如果未成功，则需要设置超时时间，并返回`NGX_AGAIN`，`lua_yield()`。

    if (u->resolved->sockaddr) {
        rc = ngx_http_lua_socket_resolve_retval_handler(r, u, L);
        if (rc == NGX_AGAIN) {
            return lua_yield(L, 0);
        }

        return rc;
    }

连接建立之后`socket:send()`就简单了，从lua userdata中取出upstream对象：

    lua_rawgeti(L, 1, SOCKET_CTX_INDEX);
    u = lua_touserdata(L, -1);
    lua_pop(L, 1);

将要发送的数据组装到cl：

    cl = ngx_http_lua_chains_get_free_buf(r->connection->log, r->pool,
                                          &ctx->free_bufs, len,
                                          (ngx_buf_tag_t)
                                          &ngx_http_lua_module);

    if (cl == NULL) {
        return luaL_error(L, "out of memory");
    }

    b = cl->buf;

    switch (type) {
        case LUA_TNUMBER:
        case LUA_TSTRING:
            p = (u_char *) lua_tolstring(L, -1, &len);
            b->last = ngx_copy(b->last, (u_char *) p, len);
            break;

        case LUA_TTABLE:
            b->last = ngx_http_lua_copy_str_in_table(L, b->last);
            break;

        default:
            return luaL_error(L, "impossible to reach here");
    }

调用发送：

    rc = ngx_http_lua_socket_send(r, u);

`ngx_http_lua_socket_send()`调用`ngx_output_chain()`完成实际发送动作，这个函数最后会调用到`output_filter`函数链，而这时实际调用的是`ngx_chain_writer()`。这是下面的代码在调用`ngx_http_lua_socket_send()`之前设置的。

    if (u->output.pool == NULL) {
        clcf = ngx_http_get_module_loc_conf(r, ngx_http_core_module);

        u->output.alignment = clcf->directio_alignment;
        u->output.pool = r->pool;
        u->output.bufs.num = 1;
        u->output.bufs.size = clcf->client_body_buffer_size;
        u->output.output_filter = ngx_chain_writer;
        u->output.filter_ctx = &u->writer;
        u->output.tag = (ngx_buf_tag_t) &ngx_http_lua_module;

        u->writer.pool = r->pool;
    }

如果发送成功，则直接返回

    if (rc == NGX_OK) {
        lua_pushinteger(L, len);
        return 1;
    }

否则需要yield，直到send事件处理完成。

cosocket的处理流程基本看完，再来看[连接池](http://wiki.nginx.org/HttpLuaModule#tcpsock:setkeepalive)特性。通过setkeepalive可以将后端连接设为可复用，这样不用每次都重新连接后端服务器，可节省连接时间。

连接池由下面这个结构维护，其中cache为当前正在使用的连接队列，free为空闲的连接队列。

    typedef struct {
        ngx_http_lua_main_conf_t          *conf;
        ngx_uint_t                         active_connections;

        /* queues of ngx_http_lua_socket_pool_item_t: */
        ngx_queue_t                        cache;
        ngx_queue_t                        free;

        u_char                             key[1];

    } ngx_http_lua_socket_pool_t;
