--- 
layout: post
title: !binary |
  eGVu5ZCv5Yqo5pe2bG9vcCBkZXZpY2XkuI3otrPnmoTpl67popg=

excerpt: !binary |
  5ZCv5YqoeGVuIGRvbVXml7bvvIzlpoLmnpzlh7rnjrDov5nkuKrplJnor6/v
  vJoNCkVycm9yOiBEZXZpY2UgNTE3MTIgKHZiZCkgY291bGQgbm90IGJlIGNv
  bm5lY3RlZC4gRmFpbGVkIHRvIGZpbmQgYW4gdW51c2VkIGxvb3AgZGV2aWNl
  DQrmiJbogIXov5nkuKrvvJoNCkVycm9yOiBEZXZpY2UgNTE3MTIgKHZiZCkg
  Y291bGQgbm90IGJlIGNvbm5lY3RlZC4gbG9zZXR1cCAvZGV2L2xvb3A4IC92
  bS9zdXNlXzEwMC5pbWcgZmFpbGVkDQoNCuWPr+iDveWwseaYr2xvb3Dorr7l
  pIfkuI3otrPvvIzmiJbogIVsb29w6K6+5aSH5LiN5Y+v55So77yM5LiL6Z2i
  5YiX5Ye65p2l55qEbG9vcDB+bG9vcDfmmK/ns7vnu5/pu5jorqTnmoQ45Liq
  bG9vcCBkZXZpY2XvvIxsb29wOOaYr+aIkeeUqG1rbm9k5omL5bel5re75Yqg
  55qE77ya

date: 2009-11-16 17:13:32 +08:00
---
启动xen domU时，如果出现这个错误：
Error: Device 51712 (vbd) could not be connected. Failed to find an unused loop device
或者这个：
Error: Device 51712 (vbd) could not be connected. losetup /dev/loop8 /vm/suse_100.img failed

可能就是loop设备不足，或者loop设备不可用，下面列出来的loop0~loop7是系统默认的8个loop device，loop8是我用mknod手工添加的：
linux-uoiv:/vm # ll /dev/loop*
brw-r----- 1 root disk 7, 0 Nov 13 13:53 /dev/loop0
brw-r----- 1 root disk 7, 1 Nov 13 13:53 /dev/loop1
brw-r----- 1 root disk 7, 2 Nov 13 13:53 /dev/loop2
brw-r----- 1 root disk 7, 3 Nov 13 13:53 /dev/loop3
brw-r----- 1 root disk 7, 4 Nov 13 13:53 /dev/loop4
brw-r----- 1 root disk 7, 5 Nov 13 13:53 /dev/loop5
brw-r----- 1 root disk 7, 6 Nov 13 13:53 /dev/loop6
brw-r----- 1 root disk 7, 7 Nov 13 13:53 /dev/loop7
brw-rw---- 1 root root 7, 8 Nov 13 14:00 /dev/loop8

一般系统中loop device都有64个，可以修改modprobe.conf，配置默认的loop device个数：
vi /etc/modprobe.conf
options loop max_loop=64

我这个系统的内核是重新编译过的，将这个选项CONFIG_BLK_DEV_LOOP=y编译进了内核，所以无法通过modprobe.conf修改，将这个改成module，重新编译后就可以了。

网上还有一种方法是将xen domU配置文件的file改成tap:aio，我试了一下，虚拟机可以引导，但是读取磁盘失败，系统无法启动：
'tap:aio:/vm/sles11.img,xvda,w'

