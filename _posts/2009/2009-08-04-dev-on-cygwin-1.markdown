--- 
layout: post
title: !binary |
  5L2/55SoY3lnd2lu5byA5Y+RbGludXggY+eoi+W6j++8iOS4gO+8iS1jeWd3
  aW7kuI5nY2M=

excerpt: !binary |
  5bqUaWJhYnnopoHmsYLvvIzlhpnkuIDkuptsaW51eOS4i+W8gOWPkeeahOWF
  pemXqOaVmeeoi+OAgg0KDQrlgZpsaW51eOW8gOWPke+8jOacgOWlveacieS4
  gOS4qmxpbnV455qE5py65Zmo77yM5Zyod2luZG93c+S4i+WuieijheS4quiZ
  muaLn+acuui9r+S7tuaYr+S4quS4jemUmeeahOmAieaLqe+8jOS+i+WmgueU
  qFZNd2FyZeaIluiAhXZpcnR1YWxib3jvvIzlj6rpnIDopoHliJLlh7rpg6jl
  iIblhoXlrZjlkoznoaznm5jnqbrpl7TvvIzlsLHog73ojrflvpfkuIDlj7Dn
  i6znq4vnmoRsaW51eOacuuWZqOOAguS9huaYr+iZmuaLn+acuui/mOaYr+Wt
  mOWcqOS4gOWumueahOW3peS9nOmHj++8jOW5tuS4lHZtd2FyZeaYr+WVhuS4
  mui9r+S7tu+8jOmcgOimgeS7mOi0ue+8m+mZpOS6hueUqOiZmuaLn+acuuS5
  i+Wklu+8jOS9v+eUqDxhIGhyZWY9Imh0dHA6Ly93d3cuY3lnd2luLmNvbS8i
  PmN5Z3dpbjwvYT7vvIg8YSBocmVmPSJodHRwOi8vd3d3LmN5Z3dpbi5jbi8i
  PuS4reaWh+ermeeCuTwvYT7vvInvvIzlj6/ku6Xmm7TliqDmlrnkvr/nmoTo
  mZrmi5/lh7rkuIDkuKpsaW51eOi/kOihjOeOr+Wig++8jOW5tuS4lOaYr+WS
  jFdpbmRvd3Pml6DnvJ3pm4bmiJDnmoTjgIINCg0K5ZKM6Jma5ouf5py65LiN
  5ZCM77yMY3lnd2lu55qE5p625p6E5b6I54G15ben77yM6YCa6L+H5Zyod2lu
  ZG93c+S4iuWunueOsExpbnV455qE5Z+65pysYXBp5bqT77yM5p6E6YCg5Ye6
  6IO95YW85a65TGludXjnmoTnvJbor5HjgIHov5DooYznjq/looPvvIzov5nm
  oLflsLHog73lvojmlrnkvr/nmoTlsIZMaW51eOeoi+W6j+enu+akjeWIsFdp
  bmRvd3PlubPlj7DjgII=

date: 2009-08-04 00:22:17 +08:00
---
应ibaby要求，写一些linux下开发的入门教程。

做linux开发，最好有一个linux的机器，在windows下安装个虚拟机软件是个不错的选择，例如用VMware或者virtualbox，只需要划出部分内存和硬盘空间，就能获得一台独立的linux机器。但是虚拟机还是存在一定的工作量，并且vmware是商业软件，需要付费；除了用虚拟机之外，使用<a href="http://www.cygwin.com/">cygwin</a>（<a href="http://www.cygwin.cn/">中文站点</a>），可以更加方便的虚拟出一个linux运行环境，并且是和Windows无缝集成的。

和虚拟机不同，cygwin的架构很灵巧，通过在windows上实现Linux的基本api库，构造出能兼容Linux的编译、运行环境，这样就能很方便的将Linux程序移植到Windows平台。
<!--more-->
下面介绍一下cygwin的使用方法。
1. 下载安装
<a href="http://www.cygwin.cn/setup.exe">点击此处下载setup.exe</a>
运行之后，一路回车，在选择安装源时可以输入:http://www.cygwin.cn/pub/，然后点击add添加国内的镜像。
<a href="/assets/uploads/2009/08/source2.png"><img src="/assets/uploads/2009/08/source2-300x231.png" alt="安装源" title="source2" width="300" height="231" class="size-medium wp-image-471" /></a>

要做开发，需要安装编译器gcc和调试器gdb，在接下来的Select package窗口里选择这两个包；（cygwin的安装程序可以随时运行，安装需要的软件包）
打开devel类别的安装包列表：
<a href="/assets/uploads/2009/08/cygwin_devel.jpg"><img src="/assets/uploads/2009/08/cygwin_devel-300x120.jpg" alt="cygwin_devel" title="cygwin_devel" width="300" height="120" class="alignnone size-medium wp-image-472" /></a>
选择点击gcc-core包名前的skip(未安装显示为skip，点击后会显示将安装的版本号)，同时安装程序会自动选择其所依赖的软件包：
<a href="/assets/uploads/2009/08/cygwin_gcc.JPG"><img src="/assets/uploads/2009/08/cygwin_gcc-300x91.jpg" alt="cygwin_gcc" title="cygwin_gcc" width="300" height="91" class="alignnone size-medium wp-image-479" /></a>
同样再选上gdb

2. 运行，并使用gcc
安装完成后，桌面会有cygwin的快捷方式，执行之后出现一个类似dos的命令行窗口，在窗口内就可以执行类linux的命令了。
cygwin的默认安装目录在c:\cygwin，用户home目录为c:\cygwin\username，我们用记事本在该目录下建立一个hello.c的文件，内容为：
<pre class=c name=code>#include <stdio.h>

main() 
{
    printf("hello world!");
    exit(0);
}</pre>
然后在cygwin中，就能看到，并且编译该文件：
<a href="/assets/uploads/2009/08/cygwin_run..jpg"><img src="/assets/uploads/2009/08/cygwin_run.-300x193.jpg" alt="cygwin_run." title="cygwin_run." width="300" height="193" class="alignnone size-medium wp-image-476" /></a>
注：linux下gcc默认生成a.out的可执行文件，windows平台下该文件为a.exe，可通过gcc -o选项制定输出文件的文件名。

3. 使用gdb
gdb是款很优秀的调试工具，linux下开发基本就靠它了。使用gdb，需要在gcc编译时增加编译选项-g。
<a href="/assets/uploads/2009/08/cygwin_gdb.jpg"><img src="/assets/uploads/2009/08/cygwin_gdb-233x300.jpg" alt="cygwin_gdb" title="cygwin_gdb" width="233" height="300" class="alignnone size-medium wp-image-481" /></a>
命令解释：
gdb a.exe 打开一个目标文件
l  列出当前的代码段
b 5   在第5行设置断点
r   运行程序
p i   打印变量i的值
n     执行下一条语句
回车   重复上条命令
