--- 
wordpress_id: 417
layout: post
title: !binary |
  bGludXggTFZN55qE5b+r54Wn5LiN6IO95bCP5LqO5rqQ6YC76L6R5Y2355qE
  5aSn5bCP

excerpt: !binary |
  TFZNMuWPr+S7peW+iOaWueS+v+eahOWIm+W7uumAu+i+keWNt+eahOW/q+eF
  p++8jOW5tuS4lOWPr+S7peaMh+WumuW/q+eFp+Wkp+Wwj++8jOS9huaYr+W/
  hemhu+azqOaEj++8jOWmguaenOW/q+eFp+epuumXtOWGmea7oe+8jExWTeS8
  muiHquWKqOWBnOatouivpeW/q+eFp++8jOWvvOiHtOaVsOaNruS4ouWkse+8
  jOezu+e7n+WQiuatu+OAguaJgOS7peWIm+W7uuW/q+eFp+aXtu+8jOimgeS/
  neivgeW/q+eFp+Wkp+Wwj+avlOa6kOmAu+i+keWNt+Wkp+OAguW+iOaDqOeX
  m+eahOS4gOS4quaVmeiureOAgg0K

date: 2009-07-25 14:02:24 +08:00
wordpress_url: http://blog.59trip.com/?p=417
---
LVM2可以很方便的创建逻辑卷的快照，并且可以指定快照大小，但是必须注意，如果快照空间写满，LVM会自动停止该快照，导致数据丢失，系统吊死。所以创建快照时，要保证快照大小比源逻辑卷大。很惨痛的一个教训。
<pre>
  LV Name                /dev/system/lv02
  VG Name                system
  LV UUID                QpUjVk-C3B1-bllJ-hp1Q-4us2-VBAg-atwJoy
  LV Write Access        read/write
  LV snapshot status     INACTIVE destination for /dev/system/mvm01
  LV Status              available
  # open                 0
  LV Size                4.00 GB
  Current LE             1024
  COW-table size         10.00 GB
  COW-table LE           2560
  Snapshot chunk size    8.00 KB
  Segments               2
  Allocation             inherit
  Read ahead sectors     0
  Block device           253:5</pre>
<!--more-->
上面lv的snapshot status变成INACTIVE destination，并且无法恢复，只能删除掉了。

用lvs可以查看当前快照空间的使用率：
<pre>02:~ # lvs
  LV              VG      Attr   LSize   Origin Snap%  Move Log Copy%
  lv02            system  Swi-I-  1.00G lv01  100.00</pre>

参考资料：
<a href="http://www.tldp.org/HOWTO/LVM-HOWTO/snapshotintro.html">http://www.tldp.org/HOWTO/LVM-HOWTO/snapshotintro.html</a>
<a href="http://tech.e800.com.cn/articles/2009/610/1244611296650_1.html">http://tech.e800.com.cn/articles/2009/610/1244611296650_1.html</a>
<a href="http://markmail.org/message/bjed5bcfm4k4fejs">http://markmail.org/message/bjed5bcfm4k4fejs</a>
