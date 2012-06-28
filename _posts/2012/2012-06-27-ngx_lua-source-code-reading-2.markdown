--- 
layout: post
title: nginx-lua模块代码阅读笔记(2)
date: 2012-06-27 15:26:24 +08:00
category:
- dev
tags:
- nginx
- lua
---
续上一篇，加载完LUA代码之后，再来看看怎么执行LUA。

先来看一个简单的例子, nginx.conf配置一个location：

    location /say { 
        content_by_lua '
            ngx.say("hello world")
        ';  
    }   

用curl访问这个url，得到输出：

    # curl -v localhost/say

    < HTTP/1.1 200 OK
    < Server: ngx_openresty/1.0.11.19
    < Date: Wed, 27 Jun 2012 03:52:47 GMT
    < Content-Type: application/octet-stream
    < Transfer-Encoding: chunked
    < Connection: keep-alive
    < 
    hello world

上面的response header是nginx默认输出的内容，可以通过ngx.header.xxxx内置变量进行修改。来分析一下代码，看这个“hello world”是如何输出的。

由于是`content_by_lua`指令，所以对应的处理函数是`ngx_http_lua_content_handler_file()`和`ngx_http_lua_content_handler_inline()`。

    /*  load Lua script file (w/ cache)        sp = 1 */
    rc = ngx_http_lua_cache_loadfile(L, script_path, llcf->content_src_key,
            &err, llcf->enable_code_cache ? 1 : 0);

    if (rc != NGX_OK) {
        if (err == NULL) {
            err = "unknown error";
        }

        ngx_log_error(NGX_LOG_ERR, r->connection->log, 0,
                      "failed to load Lua inlined code: %s", err);

        return NGX_HTTP_INTERNAL_SERVER_ERROR;
    }

    /*  make sure we have a valid code chunk */
    assert(lua_isfunction(L, -1)); //load之后，lua代码实际是一个闭包函数，这里判断是否函数

    rc = ngx_http_lua_content_by_chunk(L, r); //进入执行

`ngx_http_lua_content_by_chunk()`里调用`ngx_http_lua_new_thread()`生成一个协程(coroutine)，再调用`ngx_http_lua_run_thread()`执行这个coroutine；代码注释都比较清晰，不再赘述。这里还把request变量push进协程的全局表中，索引为`ngx_http_lua_request_key`。

`ngx_http_lua_new_thread()`生成一个新协程并返回。处理流程如下：

    top = lua_gettop(L);

    lua_pushlightuserdata(L, &ngx_http_lua_coroutines_key);
    lua_rawget(L, LUA_REGISTRYINDEX); //相当于将registry_table[ngx_http_lua_coroutines_key]这个table放到栈顶

    cr = lua_newthread(L); //这时栈顶为cr，registry table变为-2

    if (cr) {
        /*  {{{ inherit coroutine's globals to main thread's globals table
         *  for print() function will try to find tostring() in current
         *  globals table.
         */
        /*  new globals table for coroutine */
        ngx_http_lua_create_new_global_table(cr, 0, 0);

        lua_createtable(cr, 0, 1);
        lua_pushvalue(cr, LUA_GLOBALSINDEX);
        lua_setfield(cr, -2, "__index");
        lua_setmetatable(cr, -2);

        lua_replace(cr, LUA_GLOBALSINDEX);
        /*  }}} */

        *ref = luaL_ref(L, -2); //将cr放入-2位置的registry table并返回引用

        if (*ref == LUA_NOREF) {
            lua_settop(L, top);  /* restore main thread stack */
            return NULL;
        }
    }

    /*  pop coroutine reference on main thread's stack after anchoring it
     *  in registry */
    lua_pop(L, 1); //这里pop之后，gc会回收栈顶的cr，所以需要将cr引用保存起来。也就是上面的luaL_ref()所做的事情。

接下来`ngx_http_lua_run_thread()`执行协程代码，即执行`ngx.say("hello world")`。对于lua来讲，ngx.say是一个全局表中注册的c API，所以又会调用之前在加载代码阶段注册的函数`ngx_http_lua_ngx_say()`。最后调用的是`ngx_http_lua_ngx_echo()`，主要工作就是从`LUA_GLOBALSINDEX`中获取nginx request变量，然后将需要输出的内容写入`ctx->out`，然后发送响应头和body。

`ngx.say`发送完数据之后请求就结束，所以过程很简单；更复杂一点就是类似访问数据库这样的处理，发送完数据之后需要等待返回，这时候就需要从协程之中yield，将控制权交回给nginx主循环，nginx主循环处理IO事件和其他请求，直到这个数据库的响应返回之后才又再次进入这个请求的lua代码。这个也就是proactor模式，下一篇我们来看`ngx_lua`的`cosocket`是如何工作的。

