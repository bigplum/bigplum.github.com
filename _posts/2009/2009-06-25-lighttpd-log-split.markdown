--- 
wordpress_id: 165
layout: post
title: !binary |
  bGlnaHR0cGTml6Xlv5fliIblibI=

date: 2009-06-25 08:17:45 +08:00
wordpress_url: http://blog.59trip.com/?p=165
---
lighttpd本身不支持apache的rotatelogs类似的功能，但可以通过<a href="http://cronolog.org/">cronolog</a>来完成。

1. 下载、安装cronolog，步骤都比较简单。

2. 修改lighttpd的配置，并重启lighttpd就可以生效。
#accesslog.filename          = "/usr/local/var/log/lighttpd-access.log"
accesslog.filename = "|/usr/local/sbin/cronolog /usr/local/var/log/%Y/%m/%d.log"
<!--more-->
3. 目前svn库中的lighttpd1.5版本不支持cronolog分割errorlog，不过这里给出了补丁：
<a href="http://redmine.lighttpd.net/issues/show/296">http://redmine.lighttpd.net/issues/show/296</a>

1.4.23版本已经把这个补丁合入。
