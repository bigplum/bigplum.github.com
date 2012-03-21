--- 
wordpress_id: 932
layout: post
title: !binary |
  bmdpbnjmjIlpcOaJk+WNsOiwg+ivleS/oeaBrw==

date: 2010-12-07 09:26:26 +08:00
wordpress_url: http://pipa.tk/?p=932
---
这个功能很实用，服务器上线后访问量大，无法打开debug，就可以用这个功能，根据异常的ip地址来进行打印debug信息。

It is also possible to enable the debugging log only for some addresses:

error_log  /path/to/log;

events {
    debug_connection   192.168.1.1;
    debug_connection   192.168.10.0/24;
}
