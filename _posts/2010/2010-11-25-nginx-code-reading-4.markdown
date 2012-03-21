--- 
wordpress_id: 905
layout: post
title: !binary |
  bmdpbnjmupDnoIHop6PmnpAoNCkt5rex5YWlaHR0cOaooeWdlw==

excerpt: !binary |
  5LuObmd4X2h0dHBfaW5pdF9yZXF1ZXN0KCkg5YWl5omL77yM5Y+v5Lul5b6I
  5a655piT5YiG5p6QaHR0cOaooeWdl+eahOWkhOeQhua1geeoi+OAguS7jmh0
  dHDor7fmsYLlpLTlvIDlp4vop6PmnpDvvIzmoLnmja5odHRw54mI5pys6LWw
  5LiN5ZCM5rWB56iL77yM5aSE55CG6K+35rGC5aS05ZCE5Liq5a2X5q6177yM
  55u05Yiwbmd4X2h0dHBfY29yZV9ydW5fcGhhc2VzKCnjgIIg

date: 2010-11-25 08:46:31 +08:00
wordpress_url: http://pipa.tk/?p=905
---
从ngx_http_init_request() 入手，可以很容易分析http模块的处理流程。从http请求头开始解析，根据http版本走不同流程，处理请求头各个字段，直到ngx_http_core_run_phases()。 
<a href="/assets/uploads/2010/11/nginx_http.jpg"><img src="/assets/uploads/2010/11/nginx_http.jpg" alt="nginx_http" title="nginx_http" width="570" height="521" class="alignnone size-full wp-image-907" /></a>

<strong>1. http输入</strong>
ngx_http_core_run_phases()函数开始执行http各个phase的函数指针，http其他模块的处理函数全都挂到ph数组中，在这里挨个调用之。
{% highlight c %}
    while (ph[r->phase_handler].checker) {

        rc = ph[r->phase_handler].checker(r, &ph[r->phase_handler]);

        if (rc == NGX_OK) {
            return;
        }
    }
{% endhighlight %}

nginx把http处理流程分为以下几个阶段，定义了这些宏：
{% highlight c %}
typedef enum {
    NGX_HTTP_POST_READ_PHASE = 0, 

    NGX_HTTP_SERVER_REWRITE_PHASE,

    NGX_HTTP_FIND_CONFIG_PHASE,
    NGX_HTTP_REWRITE_PHASE,
    NGX_HTTP_POST_REWRITE_PHASE,

    NGX_HTTP_PREACCESS_PHASE,

    NGX_HTTP_ACCESS_PHASE,
    NGX_HTTP_POST_ACCESS_PHASE,

    NGX_HTTP_TRY_FILES_PHASE,
    NGX_HTTP_CONTENT_PHASE,

    NGX_HTTP_LOG_PHASE
} ngx_http_phases;
{% endhighlight %}

虽然只有这几个阶段，但如果自己开发模块，能插入的定制点更多。可以参考<a href="http://dl.dbank.com/c0qupaiibo">Emiller的Nginx模块开发心得.pdf</a>

<strong>2. http输出</strong>
http header输出是由ngx_http_send_header()执行，由各个功能模块调用。body的输出由ngx_http_writer()调用ngx_http_output_filter()产生。

header和body都有一个filter队列需要执行，分别是ngx_http_top_header_filter和ngx_http_top_body_filter，在http的功能模块中把处理函数插入到这两个队列。

实际上除了ngx_http_write_filter之外，其它filter中也只是组装输出缓冲区，并不实际输出。例如：ngx_http_chunked_body_filter()中，在计算好chunk的size之后，申请一个buffer b，将b插入到输出缓冲区的头部out.buf，完成对一个chunk的封装。
{% highlight c %}
    if (size) {
        b = ngx_calloc_buf(r->pool);
        if (b == NULL) {
            return NGX_ERROR;
        }

        /* the "0000000000000000" is 64-bit hexadimal string */

        chunk = ngx_palloc(r->pool, sizeof("0000000000000000" CRLF) - 1);
        if (chunk == NULL) {
            return NGX_ERROR;
        }

        b->temporary = 1;
        b->pos = chunk;
        b->last = ngx_sprintf(chunk, "%xO" CRLF, size);

        out.buf = b;
    }
{% endhighlight %}

真正的输出动作由ngx_http_write_filter()产生。所以filter队列的顺序很重要，ngx_http_write_filter应该处于队列最后。
{% highlight c %}
    ngx_log_debug1(NGX_LOG_DEBUG_HTTP, c->log, 0,
                   "http write filter limit %O", limit);

    chain = c->send_chain(c, r->out, limit);

    ngx_log_debug1(NGX_LOG_DEBUG_HTTP, c->log, 0,
                   "http write filter %p", chain);
{% endhighlight %}
