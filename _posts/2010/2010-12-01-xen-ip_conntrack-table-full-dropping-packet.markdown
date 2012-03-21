--- 
wordpress_id: 917
layout: post
title: "XEN\xE7\x9A\x84\xE2\x80\x9Dip_conntrack: table full, dropping packet.\xE2\x80\x9C\xE9\x97\xAE\xE9\xA2\x98"
excerpt: !binary |
  5LiA5byA5aeL5Zyo572R5LiK5om+5LqG5LiA5LiL77yM6K6+572u5LqG5Lik
  5Liq5YaF5qC45Y+C5pWw77yaDQpuZXQuaXB2NC5pcF9jb25udHJhY2tfbWF4
  ID0gNjU1MzYwDQpuZXQuaXB2NC5uZXRmaWx0ZXIuaXBfY29ubnRyYWNrX3Rj
  cF90aW1lb3V0X2VzdGFibGlzaGVkID0gMTgwDQoNCuWQjuadpeWPkeeOsCBu
  ZXQuaXB2NC5pcF9jb25udHJhY2tfbWF4ID0gNjU1MzYwIOS8vOS5juS4jei1
  t+S9nOeUqO+8jCAvcHJvYy9zeXMvbmV0L2lwdjQvbmV0ZmlsdGVyL2lwX2Nv
  bm50cmFja19jb3VudCDovr7liLA2NSoqKuS4qu+8jOWwseWPiOWHuueOsOS4
  ouWMheeOsOixoeOAguS6juaYr+WKoOS4iiB4ZW4g5YWz6ZSu5a2X5YaN5om+
  5LqG5LiA5LiL77yM5Y+R546w6L+Y5pyJ5Y+m5aSW5LiA5Liq5Y+C5pWw77ya
  IGJyaWRnZS1uZi1jYWxsLWlwdGFibGVzIOmcgOimgeWFs+mXreOAgg0KDQpl
  Y2hvIDAgPiAvcHJvYy9zeXMvbmV0L2JyaWRnZS9icmlkZ2UtbmYtY2FsbC1p
  cHRhYmxlcyAgICAgLy/lnKggYnJpZGdlIOS4iuWFs+mXrSBuZXRmaWx0ZXIg
  5Yqf6IO9DQoNCuaJp+ihjOS5i+WQjiAvcHJvYy9zeXMvbmV0L2lwdjQvbmV0
  ZmlsdGVyL2lwX2Nvbm50cmFja19jb3VudCDlvIDlp4vmmI7mmL7lh4/lsJHj
  gII=

date: 2010-12-01 20:24:16 +08:00
wordpress_url: http://pipa.tk/?p=917
---
一开始在网上找了一下，设置了两个内核参数：
net.ipv4.ip_conntrack_max = 655360
net.ipv4.netfilter.ip_conntrack_tcp_timeout_established = 180

后来发现 net.ipv4.ip_conntrack_max = 655360 似乎不起作用， /proc/sys/net/ipv4/netfilter/ip_conntrack_count 达到65***个，就又出现丢包现象。于是加上 xen 关键字再找了一下，发现还有另外一个参数： bridge-nf-call-iptables 需要关闭。

echo 0 > /proc/sys/net/bridge/bridge-nf-call-iptables     //在 bridge 上关闭 netfilter 功能

执行之后 /proc/sys/net/ipv4/netfilter/ip_conntrack_count 开始明显减少。

更多关于网桥的设置，可以参考： <a href="http://wiki.libvirt.org/page/Networking">http://wiki.libvirt.org/page/Networking</a>
