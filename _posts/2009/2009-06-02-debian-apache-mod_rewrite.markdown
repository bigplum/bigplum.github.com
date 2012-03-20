--- 
wordpress_id: 31
layout: post
title: "debian\xE5\xAE\x89\xE8\xA3\x85apache\xE7\x9A\x84mod_rewrite"
excerpt: !binary |
  MS4g5r+A5rS7bW9kX3Jld3JpdGUNCmEyZW5tb2QgcmV3cml0ZQ0K5Y+v5Lul
  55yL5YiwL2V0Yy9hcGFjaGUyL21vZHMtZW5hYmxlZOS4i+WkmuS6huS4gOS4
  qnJld3JpdGUubG9hZOmTvuaOpeaWh+S7tuOAgg0KDQoyLiDph43lkK9hcGFj
  aGUNCi9ldGMvaW5pdC5kL2FwYWNoZTIgZm9yY2UtcmVsb2Fk

date: 2009-06-02 10:09:22 +08:00
wordpress_url: http://www.xenhome.co.cc/blog/?p=31
---
1. 激活mod_rewrite
a2enmod rewrite
可以看到/etc/apache2/mods-enabled下多了一个rewrite.load链接文件。

2. 重启apache
/etc/init.d/apache2 force-reload

