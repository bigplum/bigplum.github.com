--- 
wordpress_id: 123
layout: post
title: !binary |
  bGlnaHR0cGQxLjXniYjmnKzlj43lkJHku6PnkIbnmoTphY3nva4=

excerpt: !binary |
  bGlnaHR0cGQxLjXvvIxzdm7niYjmnKzkuK3lj5bmtojkuoYxLjTkuK3nmoRt
  b2RfcHJveHnvvIzmlLnkuLptb2RfcHJveHlfY29yZe+8jOebuOW6lOeahOWP
  jeWQkeS7o+eQhumFjee9ruS5n+acieaJgOS4jeWQjOOAguWPr+S7peWPguiA
  g+i/meS4quaWh+aho++8mjxhIGhyZWY9Imh0dHA6Ly9yZWRtaW5lLmxpZ2h0
  dHBkLm5ldC9wcm9qZWN0cy9saWdodHRwZC93aWtpL0RvY3M6TW9kUHJveHlD
  b3JlIj5odHRwOi8vcmVkbWluZS5saWdodHRwZC5uZXQvcHJvamVjdHMvbGln
  aHR0cGQvd2lraS9Eb2NzOk1vZFByb3h5Q29yZTwvYT4=

date: 2009-06-18 21:40:40 +08:00
wordpress_url: http://blog.59trip.com/?p=123
---
lighttpd1.5，svn版本中取消了1.4中的mod_proxy，改为mod_proxy_core，相应的反向代理配置也有所不同。可以参考这个文档：<a href="http://redmine.lighttpd.net/projects/lighttpd/wiki/Docs:ModProxyCore">http://redmine.lighttpd.net/projects/lighttpd/wiki/Docs:ModProxyCore</a>

这里的配置示例是我摸索出来的一种方式，如下：
1. 增加mod<!--more-->
server.modules += ( "mod_proxy_core", "mod_proxy_backend_http" )

2. 定义host
<pre class=php name=code>$HTTP["host"] == "virtual.host.com" {
        proxy-core.balancer = "round-robin"
        proxy-core.protocol = "http"
        proxy-core.backends = ( "192.168.191.111:80" )
        proxy-core.allow-x-sendfile = "enable"
}</pre>

如上配置可以把对host（virtual.host.com）的所有访问都定向到192.168.191.111:80，但是如果配置文件中还存在 $HTTP["url"] =~ "\.php$"  之类的配置，则需要把$HTTP["host"]再写一次到$HTTP["url"]之内，否则对php文件的访问将不会被定向。

<pre class=php name=code>$HTTP["url"] =~ "\.php$" {
    proxy-core.balancer = "round-robin"
    proxy-core.allow-x-sendfile = "enable"
    #proxy-core.check-local = "1"
    proxy-core.protocol = "fastcgi"
    proxy-core.backends = ( "unix:/usr/local/lighttpd/var/tmp/php-fastcgi.socket" )
    proxy-core.max-pool-size = 16
    $HTTP["host"] == "virtual.host.com" {
        proxy-core.balancer = "round-robin"
        proxy-core.protocol = "http"
        proxy-core.backends = ( "192.168.191.111:80" )
        proxy-core.allow-x-sendfile = "enable"
    }
}</pre>

通过mod_proxy_core还可以把静态页面和动态页面彻底分离，在后端实现fast-cgi的负载均衡。还有很多新的backend特性可以使用，这个mod大概是lighttpd1.5最大的特性更新了。
