--- 
layout: post
title: nginx源码解析(1)-模块化设计
category:
- dev
tags:
- nginx
date: 2010-11-16 17:06:27 +08:00
---
nginx所有功能都实现模块化，包括核心功能和基础设施，例如core模块和errorlog模块，一般软件都会设计成一个核心代码和共用库，而在nginx中却是一个模块。模块的加载、卸载目前不支持运行时动态调整，需要在编译阶段通过configure自动进行，用户扩展的模块代码放到addon目录下会被自动搜索、配置。

configure生成`ngx_modules.c`文件，该文件定义了`ngx_modules`全局变量，包括了所有加载的模块定义。

    ngx_module_t *ngx_modules[] = {
        &ngx_core_module,
        &ngx_errlog_module,
        &ngx_conf_module,
    ...
    }

目前定义了5种模块类型，如果要扩充支持FTP协议，就可能需要增加模块类型了。`NGX_CORE_MODULE`类型为一级模块，在配置文件中，一级模块的配置指令为第一层次，例如http/event等指令。`ngx_http_module`是一级模块，在其下还有一系列类型为`NGX_HTTP_MODULE`的二级模块，如：`ngx_http_core_module`等，一般开发http模块的类型都是这种。

    #define NGX_CORE_MODULE      0x45524F43  /* "CORE" */
    #define NGX_CONF_MODULE      0x464E4F43  /* "CONF" */
    #define NGX_EVENT_MODULE      0x544E5645  /* "EVNT" */
    #define NGX_HTTP_MODULE           0x50545448   /* "HTTP" */
    #define NGX_MAIL_MODULE         0x4C49414D     /* "MAIL" */

再来看`ngx_module_t`的结构定义，以core模块为例，`NGX_MODULE_V1`和`NGX_MODULE_V1_PADDING`是一堆预留字段，`ngx_core_module_ctx`、`ngx_core_commands`与配置相关。不同类型模块的ctx和commands定义不同，例如http模块的ctx定义了server、loc等配置函数，event的ctx定义了io处理函数。下面的一堆钩子定义了模块的初始化和退出函数，用的比较少。

    ngx_module_t  ngx_core_module = {
        NGX_MODULE_V1,
        &ngx_core_module_ctx,                  /* module context */
        ngx_core_commands,                     /* module directives */
        NGX_CORE_MODULE,                       /* module type */
        NULL,                                  /* init master */
        NULL,                                  /* init module */
        NULL,                                  /* init process */
        NULL,                                  /* init thread */
        NULL,                                  /* exit thread */
        NULL,                                  /* exit process */
        NULL,                                  /* exit master */
        NGX_MODULE_V1_PADDING
    };

epoll等通讯模块的`module_ctx`定义了，事件处理函数，其中的`ngx_epoll_process_events`是worker进程主处理循环的入口。

    ngx_event_module_t  ngx_epoll_module_ctx = {
        &epoll_name,
        ngx_epoll_create_conf,               /* create configuration */
        ngx_epoll_init_conf,                 /* init configuration */

        {
            ngx_epoll_add_event,             /* add an event */
            ngx_epoll_del_event,             /* delete an event */
            ngx_epoll_add_event,             /* enable an event */
            ngx_epoll_del_event,             /* disable an event */
            ngx_epoll_add_connection,        /* add an connection */
            ngx_epoll_del_connection,        /* delete an connection */
            NULL,                            /* process the changes */
            ngx_epoll_process_events,        /* process the events */
            ngx_epoll_init,                  /* init the events */
            ngx_epoll_done,                  /* done the events */
        }
    };


核心模块初始化在函数`ngx_init_cycle(ngx_cycle_t *old_cycle)`中完成，这个函数还做了很多其他初始化工作。其中最主要的工作就是解析配置文件，根据配置指令，完成各个模块的初始化，例如监听端口等。

