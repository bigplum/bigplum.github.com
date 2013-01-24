--- 
layout: post
title: nginx源码解析(3)-从事件处理到业务处理
tags:
- nginx
date: 2010-11-24 09:25:45 +08:00
---
了解了nginx的模块化结构和进程关系之后，可以知道在worker进程的主循环里面，nginx实际上在循环处理一个个IO事件，那么具体的业务处理模块是怎么挂接进这个框架呢？

以http为例，在模块初始化时，`ngx_http_commands`中定义了函数`ngx_http_block()`，该函数负责读取http模块的配置指令，根据指令监听端口，初始化各个数据结构。

    static ngx_command_t  ngx_http_commands[] = {

        { ngx_string("http"),
          NGX_MAIN_CONF|NGX_CONF_BLOCK|NGX_CONF_NOARGS,
          ngx_http_block,
          0,
          0,
          NULL },

          ngx_null_command
    };

同时，`ngx_http_block`将`ngx_http_init_connection()`函数挂接进`ngx_listening_s`的handler。 这个handler在event模块执行accept之后被调用。

    struct ngx_listening_s {
        ngx_socket_t        fd;

        struct sockaddr    *sockaddr;
        socklen_t           socklen;    /* size of sockaddr */
        size_t              addr_text_max_len;
        ngx_str_t           addr_text;

        int                 type;

        int                 backlog;
        int                 rcvbuf;
        int                 sndbuf;

        /* handler of accepted connection */
        ngx_connection_handler_pt   handler;  

整个流程见下图：
![http process](/assets/uploads/2010/11/nginx_http_init.jpg)
