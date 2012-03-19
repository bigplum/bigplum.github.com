--- 
wordpress_id: 222
layout: post
title: "lighttpd\xE7\x9A\x84server.max-write-idle\xE9\x97\xAE\xE9\xA2\x98"
excerpt: !binary |
  6Ieq5LuO5oqKbGlnaHR0cGTljYfnuqfliLAxLjXkuYvlkI7mlK/mjIHmlq3n
  grnnu63kvKDkuYvlkI7vvIxhY2Nlc3Nsb2fml6Xlv5fkuK3lsLHlpJrkuobl
  vojlpJrkuIvpnaLnmoTmiqXplJnvvJoNCjIwMDktMDctMDEgMTc6Mzg6MDkg
  KHNlcnZlci5jOjc0NCkgTk9URTogYSByZXF1ZXN0IGZvciAvbm9zaG93LnBo
  cCB0aW1lZCBvdXQgYWZ0ZXIgd3JpdGluZyA5MDAyNCBieXRlcy4gV2Ugd2Fp
  dGVkIDM2MCBzZWNvbmRzLiBJZiB0aGlzIGEgcHJvYmxlbSBpbmNyZWFzZSBz
  ZXJ2ZXIubWF4LXdyaXRlLWlkbGUNCg0K5YWz5LqO6L+Z5Liq6Zeu6aKY55qE
  6Kej6YeK77yM5Y+v5Lul5Y+C6ICD6L+Z5Liq5biW5a2Q77yaPGEgaHJlZj0i
  aHR0cDovL2Jicy5jaGluYXVuaXgubmV0L3ZpZXd0aHJlYWQucGhwP3RpZD05
  MDExMjMiPmh0dHA6Ly9iYnMuY2hpbmF1bml4Lm5ldC92aWV3dGhyZWFkLnBo
  cD90aWQ9OTAxMTIzPC9hPu+8jOino+mHiueahOavlOi+g+WIsOS9jeS6huOA
  guS9huaYr+ayoee7meWHuuino+WGs+aWueahiO+8jOaQnOS4gOS6m+iLseaW
  h+eahOiuuuWdm+S5n+ayoeacieaUtuiOt++8jOWPquWlveiHquW3seeglOep
  tuS6huS4gOS4i++8jOWPkeeOsOaYr0NMT1NFX1dBSVTnirbmgIHmg7nlvpfn
  pbjvvIzljp/lm6DlupTor6XlsLHmmK/lrqLmiLfnq6/lvILluLjlhbPpl63j
  gII=

date: 2009-07-01 19:10:32 +08:00
wordpress_url: http://blog.59trip.com/?p=222
---
自从把lighttpd升级到1.5之后支持断点续传之后，accesslog日志中就多了很多下面的报错：
2009-07-01 17:38:09 (server.c:744) NOTE: a request for /noshow.php timed out after writing 90024 bytes. We waited 360 seconds. If this a problem increase server.max-write-idle

关于这个问题的解释，可以参考这个帖子：<a href="http://bbs.chinaunix.net/viewthread.php?tid=901123">http://bbs.chinaunix.net/viewthread.php?tid=901123</a>，解释的比较到位了。但是没给出解决方案，搜一些英文的论坛也没有收获，只好自己研究了一下，发现是CLOSE_WAIT状态惹得祸，原因应该就是客户端异常关闭。
<!--more-->
这个问题有可能会导致accesslog记录的访问时间不准确，或者导致恶意攻击，或者日志撑满硬盘down机；虽然不是什么大问题，但总觉得lighttpd处理的机制有问题，于是提了一个问题到论坛上，等待答复。

目前想到的规避方法是1. 注释写日志的代码，2. 把server.max-write-idle配置为30。
