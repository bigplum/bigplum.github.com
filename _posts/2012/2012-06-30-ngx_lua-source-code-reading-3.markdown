--- 
layout: post
title: nginx-lua模块代码阅读笔记(3)
date: 2012-06-30 15:26:24 +08:00
category:
- dev
tags:
- nginx
- lua
---
ngx-lua在增加了cosocket特性之后，才真正具有了作为一个应用开发平台的能力。与nodejs相比，在web应用开发能力上已经没多大差别，欠缺的是第三方库和开发者的活跃度。但对于高性能服务器开发来说，基本的mysql/memcache/redis/mongodb等客户端API都已经具备，使用ngx-lua并不会觉得捉襟见肘，反而能在代码书写/性能上带来巨大收益。

本质上ngx-lua和nodejs是一样的，都是基于事件驱动核心之上的脚本编程，提高web开发效率的同时，又能避免网络IO阻塞导致CPU空等，并且避免进程/线程上下文切换浪费CPU资源。得益于非阻塞的特性，相对于php，python，ruby等其他脚本语言，ngx-lua和nodejs在性能上的表现都强很多。特别适合后台需要密集数据库操作，网络IO的应用场景。

但是这二者的设计模式不同，nodejs是[reactor](http://en.wikipedia.org/wiki/Reactor_pattern)模式，ngx-lua是[proactor](http://en.wikipedia.org/wiki/Proactor_pattern)模式，也就导致了二者在使用上的巨大区别。值得一提的是lua社区的[luvit](https://github.com/luvit/luvit)项目模仿nodejs架构，利用libev+lua搭建的，同样基于reactor模式，用法和nodejs很像。同样的，ACE/Twisted等项目也是reactor模式，会发现这些框架很依赖于回调函数的使用，学习曲线比较陡峭，当然nodejs还是相对简单的。

ngx-lua则是面向过程的编码，避免了多重嵌套回调函数，代码可读性更强更易于调试。

来看一个示例，服务器端对google发起一个post请求，nodejs的实现：

    var options = {
      host: 'www.google.com',
      port: 80,
      path: '/upload',
      method: 'POST'
    };
    
    var req = http.request(options, function(res) {
      console.log('STATUS: ' + res.statusCode);
      console.log('HEADERS: ' + JSON.stringify(res.headers));
      res.setEncoding('utf8');
      res.on('data', function (chunk) {
        console.log('BODY: ' + chunk);
      });
    });
    
    req.on('error', function(e) {
      console.log('problem with request: ' + e.message);
    });
    
    // write data to request body
    req.write('data\n');
    req.write('data\n');
    req.end();

ngx-lua的实现（由于是直接操作socket，所以需要自己填写http header，如果使用lua-resty-http库，则简单很多）：

        content_by_lua '
            local sock = ngx.socket.tcp()
            local ok, err = sock:connect("www.google.com", 80)
            if not ok then
                ngx.say("failed to connect to google: ", err)
                return
            end

            request = "POST www.google.com\r\n"

            sock:settimeout(1000)  -- one second timeout
            local bytes, err = sock:send(request)
            local line, err, partial = sock:receive()
            if not line then
                ngx.say("failed to read a line: ", err)
                return
            end

            ngx.say("reponse: ", line)
            sock:close()
        ';

对比两段代码，可以明显看到ngx-lua是串行处理，nodejs的接受和发送是颠倒的。cosocket很巧妙的把协程和异步IO相结合，需要同步等待的地方就将协程的控制权交出，等待事件完成才恢复协程运行。即connect/send/receive之后并不等待服务器响应，而是yield出这个协程，这时的控制权交回nginx的主循环，nginx会继续处理其他请求或者就绪的IO事件。

connect的c代码为`ngx_http_lua_socket_tcp_connect()`，结构体`ngx_http_lua_socket_upstream_t`是存储socket信息的主要数据结构，这个结构是可重用的，reused保存了重用的次数，也就是说cosocket支持连接池管理。connect阶段需要先做域名解析，这里重用了nginx的域名解析模块`ngx_resolve_name()`，最后设置事件处理函数`ngx_http_lua_socket_resolve_retval_handler()`和`ngx_http_lua_content_wev_handler()`，yield退出。

send的c代码为`ngx_http_lua_socket_tcp_send()`，receive的c代码为`ngx_http_lua_socket_tcp_receive()`，流程都和connect类似，不再赘述。这里有个疑点，为何`write_event_handler`只在`content_phase`之后设置呢？

    if (ctx->entered_content_phase) {
        r->write_event_handler = ngx_http_lua_content_wev_handler;
    }

下回分解。
