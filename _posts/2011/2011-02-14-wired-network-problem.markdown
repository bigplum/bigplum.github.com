--- 
layout: post
title: !binary |
  5LiA5Liq5aWH5oCq55qE572R57uc6Zeu6aKY

date: 2011-02-14 15:20:15 +08:00
---
这个问题困扰了很久，主要现象就是一个机房的某个服务器访问另一个机房的特定两个ip经常出现连接失败的情况。通过抓包可以发现服务端收到TCP SYN报文，但是没有返回ACK。

客户端是通过网关做NAT出去的，如果在网关上单独对客户端ip配置一条NAT规则，问题消失。由于环境中还使用了xen、lvs等软件，所以一直定位不出到底是什么问题。

后来无意中发现，将net.ipv4.tcp_timestamps设为0，就解决问题了。

参考：
http://blog.163.com/digoal@126/blog/static/1638770402010816101031624/
http://blog.hiadm.com/archives/tag/net-ipv4-tcp_timestamps
http://www.spinics.net/lists/linux-net/msg17195.html
http://www.faqs.org/rfcs/rfc1323.html

<strong>2011-2-16更新</strong>

这个问题和tcp_tw_recycle/NAT相关，tcp_tw_recycle对NAT不兼容，所以服务器上开启tcp_tw_recycle需要权衡一下。
http://zhangle.is-a-geek.org/2010/11/tcp_tw_recycle%E5%92%8Cnat/
http://lkml.org/lkml/2010/11/14/24
