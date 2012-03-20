--- 
wordpress_id: 991
layout: post
title: !binary |
  56ef5Liq6Jma5ouf5Li75py65p2l5YGa5Y+N5ZCR5Luj55CG77yf

date: 2011-04-12 12:58:59 +08:00
wordpress_url: http://pipa.tk/?p=991
---
用过 <a href="http://appengine.google.com/">GAE</a> 都知道google的ghs ip经常被封，yobin在GAE被封之前做了一个挺大规模的人人网应用，备受困扰。上个月终于受不了花20美刀租了个linode的VPS，后来我发现他这个VPS所在的机房跟我这个100块钱的虚拟主机在一个地方，速度差不了多少，但是价钱便宜了十几倍。于是我想为什么不能用虚拟主机来做个反向代理呢？

研究了一下，方法很简单，只要空间支持.htaccess文件(支持URL Rewrite)就可以。
1. 如果你的GAE应用绑定的域名为 a.b.com，准备一个 a1.b.com域名指向 ght.google.com，将a.b.com指向你的虚拟主机。
2. 在虚拟主机上完成b.com的配置，在a.b.com子域名的根目录下放下面这样的.htaccess文件；
[bash]
&lt;IfModule mod_rewrite.c&gt;
RewriteEngine On
RewriteBase /
RewriteRule ^(.*)$ http://a1.b.com/$1 [P]
&lt;/IfModule&gt;
[/bash]
3. 等dns生效之后，访问a.b.com，apache就会往a1.b.com去请求你的数据了。

但是！！！虚拟主机的条款有写：
<strong>不得架设TWITTER API以及任何形式的代理服务程序。</strong>
但是，这个条款有漏洞，有木有！！！有木有！！！
我们只是用了apache的代理功能，而没有架设代理服务程序，有木有！！！

而且对于空间商来讲，apache代理比跑php划算啊，php还要耗cpu；而apache反向代理只需要开两个端口，来回倒数据就可以了。有木有！！！

后记：
给yobin跑了两天之后，突然发现页面出现503错误。查看apache的错误日志，显示连接ghs ip失败：
[Tue Apr 12 10:10:15 2011] [error] (110)Connection timed out: proxy: HTTP: attempt to connect to 74.125.53.121:80 (*) failed

由于无法登录服务器，不知道是什么问题。这个问题可以在dns上面修改a1.b.com指向的ghs ip来解决。

总之，虚拟主机做一些简单的反向代理是没问题的，但如果要稳定点的，还是租个VPS吧，EC2现在免费一年也可以考虑。
