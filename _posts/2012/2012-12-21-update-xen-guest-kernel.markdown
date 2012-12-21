--- 
layout: post
title: 升级xen guest内核到3.5
date: 2012-12-21 18:26:24 +08:00
category:
- dev
tags:
- xen 
---

升级步骤可以参考: [http://wiki.xen.org/wiki/Mainline_Linux_Kernel_Configs]

需要注意的是xen版本必须为4.0以上，所以suse 10是不支持的，必须将物理机升级到suse11。

在domU下面编译的内核，直接将原来的.config文件拷贝到linux目录，make oldconfig，保留原内核的编译选项，就不要对xen相关的选项做配置了。

make install之后，修改启动内核新版本：

    cd /boot
    rm initrd-xen vmlinuz-xen
    ln -s initrd-3.5.0-0.7-xen+ initrd-xen
    ln -s vmlinuz-3.5.0-0.7-xen+ vmlinuz-xen

新版本内核不再使用xvc0作为tty设备，所以修改tty为新设备：

    vi /etc/inittab
    #x0:12345:respawn:/sbin/agetty -L 9600 xvc0 xterm
    x0:12345:respawn:/sbin/agetty -L 9600 hvc0 xterm

否则，在启动虚拟机时会碰到如下错误，并且xen console上不显示登录命令：

    INIT: Id "x0" respawning too fast: disabled for 5 minutes

修改虚拟机启动配置，增加console选项：

    bootloader="/usr/lib/xen/boot/domUloader.py"
    bootargs="--entry=xvda2:/boot/vmlinuz-xen,/boot/initrd-xen"
    extra = "console=hvc0"

上述的extra选项能够让xen console显示guest OS的终端输出。

最后将hvc0添加到/etc/securetty，支持root登录：

    #vi /etc/securetty
    hvc0

参考资料：

[http://www.xen.org/files/xensummit_4/xensummit_linux_console_slides.pdf]

