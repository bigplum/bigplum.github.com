--- 
layout: post
title: !binary |
  bmdpbnjmupDnoIHop6PmnpAoMSkt5qih5Z2X5YyW6K6+6K6h

date: 2010-11-16 17:06:27 +08:00
---
nginx所有功能都已经模块化，模块的加载、卸载通过configure自动进行，用户扩展的模块放到addon目录下会被自动搜索、配置。

configure生成ngx_modules.c文件，该文件定义了ngx_modules全局变量，包括了所有加载的模块定义。
ngx_modules.c:
{% highlight c %}
ngx_module_t *ngx_modules[] = {
    &ngx_core_module,
    &ngx_errlog_module,
    &ngx_conf_module,
...
}
{% endhighlight %}

目前定义了5种模块类型，如果要扩充支持FTP协议，就可能需要增加模块类型了。
{% highlight c %}
#define NGX_CORE_MODULE      0x45524F43  /* "CORE" */
#define NGX_CONF_MODULE      0x464E4F43  /* "CONF" */
#define NGX_EVENT_MODULE      0x544E5645  /* "EVNT" */
#define NGX_HTTP_MODULE           0x50545448   /* "HTTP" */
#define NGX_MAIL_MODULE         0x4C49414D     /* "MAIL" */
{% endhighlight %}

再来看ngx_module_t的结构定义，以core模块为例，NGX_MODULE_V1和NGX_MODULE_V1_PADDING是一堆预留字段，ngx_core_module_ctx、ngx_core_commands与配置相关。不同类型模块的ctx和commands定义不同，例如http模块的ctx定义了server、loc等配置函数，event的ctx定义了io处理函数。下面的一堆钩子定义了模块的初始化和退出函数，用的比较少。
{% highlight c %}
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
{% endhighlight %}
epoll等通讯模块的module_ctx定义了，事件处理函数，其中的ngx_epoll_process_events是worker进程主处理循环的入口。
{% highlight c %}
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


{% endhighlight %}

核心模块初始化在函数ngx_init_cycle(ngx_cycle_t *old_cycle)中完成，这个函数还做了很多其他初始化工作。
{% highlight c %}
    for (i = 0; ngx_modules[i]; i++) {
        if (ngx_modules[i]->type != NGX_CORE_MODULE) {
            continue;
        }

        module = ngx_modules[i]->ctx;

        if (module->create_conf) {
            rv = module->create_conf(cycle);
            if (rv == NULL) {
                ngx_destroy_pool(pool);
                return NULL;
            }
            cycle->conf_ctx[ngx_modules[i]->index] = rv;
        }
    }
{% endhighlight %}
