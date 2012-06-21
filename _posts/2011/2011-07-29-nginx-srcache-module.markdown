--- 
layout: post
title: !binary |
  bmdpbnjnmoRzcmNhY2hl5qih5Z2X

date: 2011-07-29 15:18:43 +08:00
---
<https://github.com/agentzh/srcache-nginx-module> -- 这个模块很好用，但是中文资料不多，这里简单介绍一下。

使用memcached降低持久化存储的压力的场景很普遍，如果访问没有命中，那么需要客户端再访问一次后端数据库获取到数据之后缓存到memcached，这个流程的缺点显而易见。

nginx的srcache模块为缓存提供了一个整合后端存储的能力，配合memc模块使用。如果memc访问没命中，则发起一个后端请求，获取到数据之后自动存入memc。这个后端请求支持mysql，fastcgi或者rest server。

nginx.conf 配置示例：

    location /src {
        #charset utf-8; # or some other encoding
        default_type text/plain; # or some other MIME type

        set $key $arg_key;
        srcache_fetch GET /get $key;
        srcache_store PUT /set $key;

        # proxy_pass/fastcgi_pass/drizzle_pass/echo/etc...
        # or even static files on the disk
        proxy_pass backrest; 
    }
    location /get {
        set $memc_cmd get;
        set $memc_key $query_string;
        memc_pass backmem;
    }
    location /set {
        set $memc_cmd set;
        set $memc_key $query_string;
        memc_pass backmem;
    }


用curl可以简单测试一下：
{% highlight bash %}
curl localhost/src?key=1234 -v
{% endhighlight %}
