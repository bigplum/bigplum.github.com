--- 
wordpress_id: 63
layout: post
title: !binary |
  bGlnaHR0cGTmlK/mjIHmlq3ngrnnu63kvKDjgIHlpJrnur/nqIvkuIvovb3j
  gIHkuIvovb3pmZDpgJ/jgIHpmZDliLZJUOW5tuWPkeaVsOeahOWHoOS4quWK
  n+iDvQ==

excerpt: !binary |
  MS4g5pat54K557ut5Lyg44CB5aSa57q/56iL5LiL6L29DQrov5nkuKTkuKrl
  rp7pmYXkuIrmmK/kuIDkuKrlip/og73vvIzlj6ropoHmnI3liqHlmajnq6/m
  lK/mjIFyYW5nZeWPguaVsO+8jOWwseiDveaUr+aMgeOAguS9hmxpZ2h0dHBk
  MS405aaC5p6c5L2/55Soc2VuZGZpbGXmlrnlvI/vvIhwaHDnmoRyZWFkZmls
  ZeS5n+aYr+S4jeihjOeahO+8ieaYr+S4jeaUr+aMgeivpeWPguaVsOeahO+8
  jOacieS6uuWBmuS6huS4gOS4quihpeS4gei/m+ihjOaUr+aMge+8jOWmguae
  nOS4jeaDs+WNh+e6p2xpZ2h077yM5Y+v5Lul6K+V6K+V55yL44CCDQrmiJbo
  gIXkuZ/lj6/ku6XpgJrov4fmnI3liqHlmajnq6/nqIvluo/ov5vooYzmlK/m
  jIHvvIzkvovlpoLnlKhwaHDmnaXop6PmnpBoZWFkZXLnmoRyYW5nZeWPguaV
  sO+8jOS8muavlOi+g+m6u+eDpuS4gOeCueOAgg0KDQrljYfnuqfliLBsaWdo
  dHRwZDEuNeWPr+S7peW+iOWlveeahOS9v+eUqOivpeWKn+iDveOAgg0K

date: 2009-06-08 17:45:07 +08:00
wordpress_url: http://blog.59trip.com/?p=63
---
1. 断点续传、多线程下载
这两个实际上是一个功能，只要服务器端支持range参数，就能支持。但lighttpd1.4如果使用sendfile方式（php的readfile也是不行的）是不支持该参数的，<a href="http://forum.lighttpd.net/topic/154">有人做了一个补丁进行支持</a>，如果不想升级light，可以试试看。
或者也可以通过服务器端程序进行支持，例如用php来解析header的range参数，会比较麻烦一点。

升级到lighttpd1.5可以很好的使用该功能。

2. 对每个连接进行单独下载限速
下载限速有两种情况：<!--more-->
1. 对url、服务器目录进行配置，设置限速大小(1.3.8以后支持)
2. 对每个单独连接进行限速，对于区别服务，这个功能很重要(1.5以后支持)：
参考<a href="http://redmine.lighttpd.net/projects/lighttpd/wiki/Docs:TrafficShaping">http://redmine.lighttpd.net/projects/lighttpd/wiki/Docs:TrafficShaping</a>
下载文中所述的<a href="http://redmine.lighttpd.net/attachments/download/697/mod_speed.c">mod_speed.c</a> ，编译、安装，并修改lighttpd.conf，启用mod_speed模块。

就可以在服务器端对每个连接进行单独限速了。
<pre name="code" class="php"> &lt;?php
 header("X-LIGHTTPD-KBytes-per-second: 50");
 header("X-Sendfile: /path/to/file");
 ?&gt;</pre>

3. 限制IP并发数
启用插件mod_evasive (1.5以后支持)
配置evasive.max-conns-per-ip
注：这里配置的evasive.max-conns-per-ip的值要比实际的连接数小1，如果配置为0则不限制连接。所以每个IP最少2个连接。
