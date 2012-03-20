--- 
wordpress_id: 1006
layout: post
title: !binary |
  5a+5bmdpbnjnmoTmlq3ngrnkuIrkvKDmqKHlnZfnmoTkuIDngrnmlLnov5s=

date: 2011-04-29 15:11:10 +08:00
wordpress_url: http://pipa.tk/?p=1006
---
前一篇文章介绍了一下<a href="http://pipa.tk/archives/986">nginx的断点上传模块</a>。

这个模块支持断点上传，但是需要客户端预先对文件分段，然后挨个上传分段。如果某个分段上传一半中断了，那么必须重新上传整个分段。所以就带来两个问题：

1. 分段重传，做了一部分无用功。
2. 每上传一个分段，重新建立tcp连接的开销。

于是对这个模块做了一些改动，在分段上传发生异常中断时，将已经写入磁盘的部分记录到state文件中。这样只要客户端发起一次少量的数据上传，就能查询到当前文件已经上传了那些分段，然后可以从中断的地方继续上传。这样一次POST可以上传尽可能多的数据。
当然，如果使用多线程上传，那还是需要预先分段。

代码地址：<a href="https://github.com/bigplum/nginx-upload-module/tree/2.2">https://github.com/bigplum/nginx-upload-module/tree/2.2</a>

主要增加了一个cleanup函数，判断如果文件的offset不等于content range end，那么就做一次merge range操作。
[c]
static void
ngx_http_upload_cleanup_part(void *data)
{
    ngx_http_request_t *r = data;
    ngx_http_upload_ctx_t     *u;
    ngx_int_t                 rc;
    ngx_http_upload_range_t     content_range_n;

    u = ngx_http_get_module_ctx(r, ngx_http_upload_module);
    if(!u){
        return;
    }
    
    ngx_log_debug1(NGX_LOG_DEBUG_HTTP, r-&gt;connection-&gt;log, 0,
                   &quot;cleanup http upload request, out offset: %d&quot;, u-&gt;output_file.offset);
    
    if(!u-&gt;raw_input || !u-&gt;output_file.offset || 
        u-&gt;output_file.offset == u-&gt;content_range_n.end + 1)
    {
        return;
    }

    content_range_n.start = u-&gt;content_range_n.start;
    content_range_n.end = u-&gt;output_file.offset - 1;
    content_range_n.total = u-&gt;content_range_n.total;

    rc = ngx_http_upload_merge_ranges(u, &amp;content_range_n);

    if(rc == NGX_ERROR) {
        ngx_log_error(NGX_LOG_ERR, r-&gt;connection-&gt;log, 0
            , &quot;upload cleanup: error merging ranges&quot;
            );

        return;
    }
}
[/c]
