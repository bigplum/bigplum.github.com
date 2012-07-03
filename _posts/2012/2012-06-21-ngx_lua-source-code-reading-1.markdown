--- 
layout: post
title: ngx-lua源码阅读笔记(1)
date: 2012-06-21 15:26:24 +08:00
category:
- dev
tags:
- nginx
- lua
---
`ngx_lua`模块的背景可以参考这篇文章《<a href="http://os.51cto.com/art/201112/307610.htm">51CTO专访淘宝清无：漫谈Nginx服务器与Lua语言</a>》和这个ppt《<a href="https://docs.google.com/present/view?id=dddqrph4_23gmctkmcg&pli=1">ngx_drizzle/lua前世今生</a>》。

基本原理：

1. 每Nginx工作进程使用一个Lua VM，工作进程内所有协程共享VM
2. 将Nginx I/O原语封装后注入Lua VM，允许Lua代码直接访问
3. 每个外部请求都由一个Lua协程处理，协程之间数据隔离
4. Lua代码调用I/O操作接口时，若该操作无法立刻完成，则打断相关协程的运行并保护上下文数据
5. I/O操作完成时还原相关协程上下文数据并继续运行

本文代码基于`ngx_lua v0.5.2`, 先来看看LUA是如何初始化的。

lua模块在rewrite, access, content三个phase注册了handler函数，以及header filter；设想了一下使用场景：

1. 对url进行rewrite处理；
2. 在接收到请求头的时候，对请求进行鉴权处理（访问控制）；
3. 请求各种后端服务器，对返回内容进行处理之后再输出；
4. 作为反向代理使用，既可以直接透传后端的返回，也可以做处理之后再返回；

`ngx_http_lua_module.c`文件定义了lua模块所需的数据结构和init函数，在init函数中挂载rewrite和access phase的handler。以rewrite为例，来看看lua代码如何嵌入nginx处理流程。

`ngx_http_lua_init()`

    if (lmcf->requires_rewrite) {
        //ngx_http_lua_requires_rewrite 在 ngx_http_lua_rewrite_by_lua() 中赋值，即只有使用了
        //rewrite_by_lua等directive，才会挂载 ngx_http_lua_rewrite_handler
        
        h = ngx_array_push(&cmcf->phases[NGX_HTTP_REWRITE_PHASE].handlers);
        if (h == NULL) {
            return NGX_ERROR;
        }

        *h = ngx_http_lua_rewrite_handler;
    }
    
`ngx_http_lua_rewrite_handler()`并不加载LUA代码，只是做一些辅助工作，最后才调用`llcf->rewrite_handler(r)`。这个`llcf->rewrite_handler(r)`完成加载LUA的部分，实际函数为`ngx_http_lua_rewrite_handler_inline()`或`ngx_http_lua_rewrite_handler_file()`完成。再回头来看`static ngx_command_t ngx_http_lua_cmds[]`的定义：

    { ngx_string("rewrite_by_lua_file"),
      NGX_HTTP_MAIN_CONF|NGX_HTTP_SRV_CONF|NGX_HTTP_LOC_CONF|NGX_HTTP_LIF_CONF
                        |NGX_CONF_TAKE1,
      ngx_http_lua_rewrite_by_lua,  //这个函数指针定义了 rewrite_by_lua_file 这个配置项的处理函数，
                //如果在nginx.conf中配置 rewrite_by_lua_file, 则会调用该函数。
      NGX_HTTP_LOC_CONF_OFFSET,
      0,
      ngx_http_lua_rewrite_handler_file },  //这个函数指针在 ngx_http_lua_rewrite_by_lua() 中被挂接到 llcf->rewrite_handler

所以主要来看`ngx_http_lua_rewrite_handler_file()`的实现。可以看到是函数`ngx_http_lua_cache_loadfile()`完成的加载动作。

    lmcf = ngx_http_get_module_main_conf(r, ngx_http_lua_module);
    L = lmcf->lua;

    /*  load Lua script file (w/ cache)        sp = 1 */
    rc = ngx_http_lua_cache_loadfile(L, script_path, llcf->rewrite_src_key,
            &err, llcf->enable_code_cache ? 1 : 0);

这里的L是在配置文件初始化时调用`ngx_http_lua_new_state()`生成的，这个函数主要完成：

1. 生成新vm，`lua_State`
2. 设置默认的package路径，路径由编译脚本生成
3. `ngx_http_lua_init_registry()`初始化lua registry table。registry中保存了多个lua运行期需要保持的变量，例如：cache的lua代码，协程的引用地址等，这些变量如果放在lua堆栈中会被GC机制自动回收，所以需要另外保存。
4. `ngx_http_lua_init_globals()`初始化global全局变量。ngx的各种api和内置变量就是在这里由`ngx_http_lua_inject_ngx_api()`进行注入，提供给lua脚本调用。

再来看`ngx_http_lua_cache_loadfile()`，lua代码有配置项`lua_code_cache`指示是否缓存，默认启用缓存。`ngx_http_lua_clfactory_loadfile()`负责读取lua代码，并在代码前后加上`return function() ... end`变为closure。如果需要缓存，则调用`ngx_http_lua_cache_store_code()`，将closure放入前面说过的registry中。

`ngx_http_lua_clfactory_loadfile()`在读取lua代码的时候做了添加closure代码的处理，需要对文本文件和二进制文件区分处理。

    if (c == LUA_SIGNATURE[0] && filename) {  /* binary file? */
        lf.f = freopen(filename, "rb", lf.f);  /* reopen in binary mode */

若是luac编译过的lua二进制文件，其前4个字节内容为`LUA_SIGNATURE[0]`的内容，可以看到在lua.h中的定义。

`Lua.h`
    #define LUA_SIGNATURE   "\033Lua"

这里先不赘述二进制代码添加closure的处理过程，有兴趣可以看`ngx_http_lua_clfactory.c`文件开头的描述，说明了lua和luajit二进制代码的协议。对于lua文本代码，`clfactory_getF()`是`lua_load()`的reader函数，负责读取代码并在代码前后添加closure处理。`lua_load()`之后，closure便位于堆栈的顶层，随后是一些异常处理。整个初始化过程就完成了。

    lf.sent_begin = lf.sent_end = 0;
    status = lua_load(L, clfactory_getF, &lf, lua_tostring(L, -1));

    readstatus = ferror(lf.f);

    if (filename) {
        fclose(lf.f);  /* close file (even in case of errors) */
    }

    if (readstatus) {
        lua_settop(L, fname_index);  /* ignore results from `lua_load' */
        return clfactory_errfile(L, "read", fname_index);
    }

    lua_remove(L, fname_index);

    return status;

最后附一个图。
![function img](/assets/uploads/2012/06/ngx-lua.load.png)

