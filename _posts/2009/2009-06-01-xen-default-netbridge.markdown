--- 
wordpress_id: 6
layout: post
title: !binary |
  eGVu5ZCv5Yqo6buY6K6k572R5qGl55qE6Zeu6aKY

excerpt: !binary |
  UTogZG9tMOS4iuWtmOWcqOWkmuS4que9keWNoe+8jOWmguS9leiuqXhlbuS9
  v+eUqOaMh+WumueahOe9keWNoeW7uueri+e9keahpe+8jOiuqWRvbVXkvb/n
  lKjor6XnvZHmoaXmjqXlhaXnvZHnu5zvvJ8NCg0KQe+8mm5ldHdvci1icmlk
  Z2Ug5qC55o2u6buY6K6k6Lev55Sx5ZCv5Yqo6buY6K6k572R5qGlDQpuZXRk
  ZXY9JHtuZXRkZXY6LSQoaXAgcm91dGUgbGlzdCAwLjAuMC4wLzAgfCANCnNl
  ZCAncy8uKmRldiAoW2Etel0rWzAtOV0rKS4qJC8xLycpfQ==

date: 2009-06-01 19:42:39 +08:00
wordpress_url: http://www.xenhome.co.cc/blog/?p=6
---
<strong>Q: </strong>dom0上存在多个网卡，如何让xen使用指定的网卡建立网桥，让domU使用该网桥接入网络？

<strong>A：</strong>networ-bridge 根据默认路由启动默认网桥
<code>netdev=${netdev:-$(ip route list 0.0.0.0/0 |
sed 's/.*dev ([a-z]+[0-9]+).*$/1/')}</code>
所以只要配对了默认路由，xen domU就可以使用该网卡接入网络。<!--more-->
存在多网卡并且bond的情况下，由于pbond0启动后，路由可能会丢失，所以需要增加文件ifroute-...为bond添加默认路由
<code>linux-uoiv:/etc/sysconfig/network # cat ifroute-pbond0
default 192.168.194.1 - -
linux-uoiv:/etc/sysconfig/network # cat ifroute-bond0
default 192.168.194.1 - -</code>

这个问题花了我3天时间，网上搜不到解决方案，看代码加调试脚本才搞定。。。还是应该静下心来读代码，留个脚印。
