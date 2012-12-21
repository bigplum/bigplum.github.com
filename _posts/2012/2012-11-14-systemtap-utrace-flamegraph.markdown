--- 
layout: post
title: 使用systemtap和utrace做代码性能分析
date: 2012-11-14 18:26:24 +08:00
category:
- dev
tags:
- nginx
---

据说dtrace是这十年来操作系统领域里最大的技术进步，可惜是solaris独有的，mac os x的移植也不是很完全。当初用unix的时候，比较排斥solaris的性能，一般都是在hpux或者aix下面调试，所以对dtrace一无所知。最近接触到linux的systemtap，才了解到dtrace，但是现在也没sun工作站用了。

systemtap+utrace基本可以完成dtrace的功能。systemtap比较容易安装，utrace就费点事，如果是fedora，内核已经带了utrace，可以不用另外编译。或者使用3.5以上的内核。

ubuntu默认的systemtap有时会coredump，所以最好下载最新源码编译。

    git clone git://sourceware.org/git/systemtap.git

在ubuntu安装systemtap参考：http://www.dcshi.com/?p=124

一般装完之后就能使用内核相关的功能了，但是如果想监控用户态程序，就需要utrace支持，否则会报如下错误：

    user-space facilities not available without kernel CONFIG_UTRACE or CONFIG_TRACEPOINTS/CONFIG_ARCH_SUPPORTS_UPROBES/CONFIG_UPROBES
    Pass 4: compilation failed.  Try again with another '--vp 0001' option.

utrace未被合入内核主干，所以需要另外编译内核。有两种方式：

1. 获取utrace的补丁，合入到ubuntu当前版本的内核代码，然后编译内核
2. 获取支持utrace的内核代码，然后编译内核，注意要选上鼠标和网卡的驱动。

方式1可以参考：[这里](http://chaoslawful.iteye.com/blog/1463564)，如果2.6的内核，可以从[这里下载补丁](http://web.elastic.org/~fche/frob-utrace/)
方式2可以参考：[这里]((http://hi.baidu.com/actionplay/item/5bce1bd861834e10d80e4472)

由于编译内核耗时很久，上述步骤需要编译两次内核，所以比较合理的方式是：先获取utrace补丁，合入到ubuntu的内核代码，然后编译内核和dbgsym。

好吧，我的ubuntu是12.04版本的，找不到对应的utrace补丁，只好下个内核源码重新编译，但是网卡驱动不起来，只好放弃。

最后，我把ubuntu升级到12.10，内核版本为3.5.0，支持UPROBE特性，重新编译内核调试信息，安装stap。

总结：想用utrace的话，又不想折腾编译内核，用fedora 6以后的版本，或者用ubuntu 12.10。

接下来画nginx的flamegraph，先准备a.tap脚本:

    global s;
    global quit = 0;

    probe timer.profile {
        if (pid() == target()) {
            if (quit) {
                foreach (i in s-) {
                    print_ustack(i);
                    printf("\t%d\n", @count(s[i]));
                }
                exit()
            } else {
                s[ubacktrace()] <<< 1;
            }
        }
    }

    probe timer.s(20) {
        quit = 1
    }

下载nginx的源码,编译运行:

    nobody   28320 28088 15 15:47 ?        00:08:15 nginx: worker process

使用ab做性能测试:

    ab -c 1000 -n 10000 -k 10.6.2.96:8080/
 
执行stap脚本，有一堆warning，没有error就行: 

    stap --ldd -d /path/to/nginx/sbin/nginx \
            -d /usr/lib64/libc-2.15.so \
            --all-modules -D MAXMAPENTRIES=10240 \
            -D MAXACTION=20000 \
            -D MAXTRACE=100 \
            -D MAXSTRINGLEN=4096 \
            -D MAXBACKTRACE=100 -x 28320 a.stp > a.out

    WARNING: missing unwind/symbol data for module 'uprobes'
    WARNING: Missing unwind data for module, rerun with 'stap -d stap_348b6243853d3b3a99c30655c24235c_29272'
    WARNING: Number of errors: 0, skipped probes: 67
    WARNING: There were 186 transport failures.

生成火焰图：

    [root@localhost ~]# FlameGraph/stackcollapse-stap.pl a.out > a.fold
    [root@localhost ~]# FlameGraph/flamegraph.pl a.fold > a.svg

![flamegraph](/assets/uploads/2012/11/flame.png)

下载用浏览器打开：

[svg文件下载](/assets/uploads/2012/11/a.svg)

参考资料：
[玩转 utrace Linux 新的调试接口 utrace 简介](http://www.ibm.com/developerworks/cn/linux/l-cn-utrace/index.html)

[A guide on how to install Systemtap on an Ubuntu system](http://www.sourceware.org/systemtap/wiki/SystemtapOnUbuntu)

[FlameGraph](https://github.com/brendangregg/FlameGraph)

[Linux Kernel Performance: Flame Graphs](http://dtrace.org/blogs/brendan/2012/03/17/linux-kernel-performance-flame-graphs/)

[nginx systemtap使用](https://groups.google.com/forum/?fromgroups=#!topic/openresty/u-puKWWONMk)


