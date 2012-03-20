--- 
wordpress_id: 13
layout: post
title: !binary |
  5L+u5pS5eGVuIGRvbVXnmoTns7vnu5/ml7bpl7Q=

excerpt: !binary |
  eGVu5aaC5p6c5L2/55So5Y2K6Jma5ouf6K+d5bu656uLZ3Vlc3QgZG9tYWlu
  5bCx5pS55LiN5LqGZG9tVeeahOaXtumXtOOAguWPr+S7pemAmui/h+S4i+md
  oueahOWPguaVsOi/m+ihjOS/ruaUueOAgg0KDQo8Y29kZT4jZWNobyAieGVu
  LmluZGVwZW5kZW50X3dhbGxjbG9jayA9IDEiID4+IC9ldGMvc3lzY3RsLmNv
  bmYNCiNzeXNjdGwgLXANCjwvY29kZT4=

date: 2009-06-01 19:57:34 +08:00
wordpress_url: http://www.xenhome.co.cc/blog/?p=13
---
xen如果使用半虚拟化建立guest domain就改不了domU的时间。可以通过下面的参数进行修改。

<code>#echo "xen.independent_wallclock = 1" >> /etc/sysctl.conf
#sysctl -p
</code>

然后就可以修改domU的时间了。

