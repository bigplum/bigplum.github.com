--- 
layout: post
title: !binary |
  eGVu5ZCv5Yqo6buY6K6k572R5qGl55qE6Zeu6aKY

date: 2009-06-01 19:42:39 +08:00
tags:
    - xen
---
<strong>Q: </strong>dom0上存在多个网卡，如何让xen使用指定的网卡建立网桥，让domU使用该网桥接入网络？

<strong>A：</strong>networ-bridge 根据默认路由启动默认网桥

    netdev=${netdev:-$(ip route list 0.0.0.0/0 |
    sed 's/.*dev ([a-z]+[0-9]+).*$/1/')}

所以只要配对了默认路由，xen domU就可以使用该网卡接入网络。

存在多网卡并且bond的情况下，由于pbond0启动后，路由可能会丢失，所以需要增加文件ifroute-...为bond添加默认路由

    linux-uoiv:/etc/sysconfig/network # cat ifroute-pbond0
    default 192.168.194.1 - -
    linux-uoiv:/etc/sysconfig/network # cat ifroute-bond0
    default 192.168.194.1 - -

这个问题花了我3天时间，网上搜不到解决方案，看代码加调试脚本才搞定。。。还是应该静下心来读代码，留个脚印。
