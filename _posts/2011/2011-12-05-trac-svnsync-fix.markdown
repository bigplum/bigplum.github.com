--- 
wordpress_id: 1061
layout: post
title: !binary |
  dHJhY+S9v+eUqHN2bnN5bmPml7bnmoTpl67popg=

date: 2011-12-05 22:27:15 +08:00
wordpress_url: http://pipa.tk/?p=1061
---
配置好svnsyncplugin之后，手工同步svnsync数据库成功，但是在trac里浏览老是报错：

    TypeError: 'NoneType' object is unsubscriptable

找了半天，找到这个patch，试了一下能解决问题：<a href="http://trac-hacks.org/ticket/7110">http://trac-hacks.org/ticket/7110</a>

这个patch在svnsync init时默认使用svnsync用户去远程svn同步，所以如果svn需要auth，那么最好先手工svnsync init一下，再点击trac就会开始svnsync sync，这时候是不需要用户名密码的（使用svn config的配置）。
