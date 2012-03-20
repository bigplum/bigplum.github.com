--- 
wordpress_id: 308
layout: post
title: !binary |
  eGVu6Jma5ouf5py6ZG9tVeWQr+WKqOaXtuWNoeS9j+mXrumimA==

excerpt: !binary |
  ZG9tVeWQr+WKqOaXtuWNoeS9j+acieW+iOWkmuenjeaDheWGteWvvOiHtO+8
  jOWFtuS4reS4gOenjeWwseaYr2ltZ+aWh+S7tuS4reWumuS5ieeahOaWh+S7
  tuezu+e7n+aJvuS4jeWIsO+8jOmCo+S5iOezu+e7n+WcqOWQr+WKqOaXtuWw
  seS8muWNoeWcqOS4i+mdoueahOWcsOaWue+8mg0KDQpVU0IgVW5pdmVyc2Fs
  IEhvc3QgQ29udHJvbGxlciBJbnRlcmZhY2UgZHJpdmVyIHYyLjMNCnVzYmNv
  cmU6IHJlZ2lzdGVyZWQgbmV3IGRyaXZlciBoaWRkZXYNCnVzYmNvcmU6IHJl
  Z2lzdGVyZWQgbmV3IGRyaXZlciB1c2JoaWQNCmRyaXZlcnMvdXNiL2lucHV0
  L2hpZC1jb3JlLmM6IHYyLjY6VVNCIEhJRCBjb3JlIGRyaXZlcg0KDQrmiorm
  mKDlg4/mlofku7Ztb3VudOS4iuS5i+WQju+8jG1vdW505pa55rOV6K+35Y+C
  6ICD77yaPDxhIGhyZWY9Imh0dHA6Ly9ibG9nLjU5dHJpcC5jb20vYXJjaGl2
  ZXMvMjA5Ij7lpoLkvZVtb3VudOWPr+WQr+WKqOeahOehrOebmOaYoOWDj+aW
  h+S7tjwvYT4+77yMIOe8lui+kS9ldGMvZnN0YWLmlofku7bvvIzmiorlhbbk
  uK3lpJrkvZnnmoTliIbljLrliKDpmaTljbPlj6/jgII=

date: 2009-07-14 11:44:37 +08:00
wordpress_url: http://blog.59trip.com/?p=308
---
domU启动时卡住有很多种情况导致，其中一种就是img文件中需使用的文件系统找不到，那么系统在启动时就会卡在下面的地方：

USB Universal Host Controller Interface driver v2.3
usbcore: registered new driver hiddev
usbcore: registered new driver usbhid
drivers/usb/input/hid-core.c: v2.6:USB HID core driver

把映像文件mount上之后，mount方法请参考：<<a href="http://blog.59trip.com/archives/209">如何mount可启动的硬盘映像文件</a>>， 编辑/etc/fstab文件，把其中多余的分区删除即可。

一般这种情况发生在将一个可用的domU系统映像拷贝出来，生成另一个系统时。
