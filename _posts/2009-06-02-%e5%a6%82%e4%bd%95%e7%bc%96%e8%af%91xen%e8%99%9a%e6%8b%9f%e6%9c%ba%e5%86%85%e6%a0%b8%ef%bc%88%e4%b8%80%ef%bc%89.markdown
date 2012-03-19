--- 
wordpress_id: 36
layout: post
title: !binary |
  5aaC5L2V57yW6K+RWEVO6Jma5ouf5py65YaF5qC477yI5LiA77yJ

date: 2009-06-02 20:06:28 +08:00
wordpress_url: http://www.xenhome.co.cc/blog/?p=36
---
1. 下载xen源码包 <a href="http://www.xen.org/products/xen_source.html">http://www.xen.org/products/xen_source.html</a>

2. 编译内核需要用hg下载内核源码，hg从这里<a href="http://mercurial.selenic.com/downloads/">下载</a>。（注，hg是一个分布式版本管理软件，目前较流行）

3. 解压hg，在suse下编译hg，需要修改一下代码：
linux-myhm:~/mercurial-1.2 # vi ./hgext/inotify/linux/_inotify.c
将#include &lt;sys/inotify.h&gt;
改为: #include &lt;linux/inotify.h&gt;<!--more-->
2010-10注：新版本的hg可以直接编译，不需要修改。

4. 编译hg，还需要python-devl包，从suse光盘安装，如果是其他发行版可以从网上下载安装。
5. make install编译hg，编译完成后可以看到：
linux-myhm:~/mercurial-1.2 # whereis hg
hg: /usr/local/bin/hg

5.1 (xen-4.0版本需要)安装git，下载最新版本<a href="http://www.kernel.org/pub/software/scm/git/">http://www.kernel.org/pub/software/scm/git/</a>
编译：./configure
安装：make install

6. 检查编译内核所需的包是否齐全：
* GCC v3.4 or later
* GNU Make
* GNU Binutils
* Development install of zlib (e.g., zlib-dev)
* Development install of Python v2.3 or later (e.g., python-dev)
* Development install of curses (e.g., libncurses-dev)
* Development install of openssl (e.g., openssl-dev)
* Development install of x11 (e.g. xorg-x11-dev)
* bridge-utils package (/sbin/brctl)
* iproute package (/sbin/ip)
* hotplug or udev
上述软件如果不存在，编译过程会报错，都需要安装。

7. 如果是第一次编译，可以执行下面命令：
linux-uoiv:~ # cd xen-3.3.1/
linux-uoiv:~/xen-3.3.1 # make world   //会全部重新编译，第一次使用
这个过程会用git从kernel.org下载linux内核源码，耗时很长。
linux-uoiv:~/xen-3.3.1 #make install  //安装内核文件到boot目录

8. 生成initrd文件
mkinitrd -i /boot/initrd-2.6.18-xen -k /boot/vmlinuz-2.6.18.8-xen

9. 编辑/boot/grub/menu.lst文件，依样画葫芦把新编译成功的内核文件加入到启动菜单。
title XENNew
root (hd0,0)
kernel /xen.gz
module /vmlinuz-2.6.18.8-xen root=/dev/system/root  ide=nodma resume=/dev/system
/swap splash=silent showopts
module /initrd-2.6.18-xen

并且修改default为相应的序号（从0开始，每个title为一个启动项），默认使用新的内核。

10. 这时可以重启系统，重启后用uname -a可以看到 2.6.16.60-0.21-xen 的字样，即内核启动成功。

。。。待续
