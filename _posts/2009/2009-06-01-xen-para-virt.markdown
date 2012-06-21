--- 
layout: post
title: !binary |
  WGVu5Y2K6Jma5ouf5YyW5oqA5pyv

excerpt: !binary |
  5Y2K6Jma5ouf5YyW55qE5oCn6IO95q+U5YWo6Jma5ouf5YyW6auY5Ye65LiN
  5bCR77yM5L2G5piv5Y2K6Jma5ouf5YyW5a6J6KOF5q+U6L6D6bq754Om77yM
  5LiN5pSv5oyBY2Ryb23lronoo4XvvIznm67liY3lj6rmkbjntKLlh7rmnaXk
  vb/nlKh2aXJ0LW1hbmFnZXLlronoo4VzdXNlMTDnmoTljYromZrmi5/ljJbn
  s7vnu5/jgILogIzlhajomZrmi5/ljJblj6/ku6XliKnnlKhzeHDmlofku7bm
  jILovb1pc2/mlofku7blronoo4Xku7vmhI/nmoRsaW51eOWPkeihjOeJiOac
  rOOAgg0KPT09PT09DQoNCuWNiuiZmuaLn+WMlueahOaEj+aAneaYr+mcgOim
  geS/ruaUueiiq+iZmuaLn+ezu+e7n+eahOWGheaguO+8jOS7peWunueOsOez
  u+e7n+iDveiiq+WujOe+jueahOiZmuaLn+WcqFhlbuS4iumdouOAguWujOWF
  qOiZmuaLn+WMluWImeaYr+S4jemcgOimgeS/ruaUueezu+e7n+WGheaguOWI
  meWPr+S7peebtOaOpei/kOihjOWcqFhlbuS4iumdouOAglZNV0FSRSBXb3Jr
  c3RhdGlvbuaYr+WFqOiZmuaLn+WMlu+8jOaJgOS7peWPr+S7peiZmuaLn3dp
  bmRvd3M=

date: 2009-06-01 19:36:37 +08:00
---
半虚拟化的性能比全虚拟化高出不少，但是半虚拟化安装比较麻烦，不支持iso安装，目前只摸索出来使用virt-manager安装suse10的半虚拟化系统，安装源需要用物理光驱。而全虚拟化可以利用sxp文件挂载iso文件安装任意的linux发行版本。

更新：suse11的半虚拟化已经可以支持用iso安装。

======参考资料的分割线=======<!--more-->

半虚拟化的意思是需要修改被虚拟系统的内核，以实现系统能被完美的虚拟在Xen上面。完全虚拟化则是不需要修改系统内核则可以直接运行在Xen上面。VMWARE Workstation是全虚拟化，所以可以虚拟windows

XEN是一个半虚拟化解决方案，目前暂不支持虚拟windows，（在硬件的支持下可以做到，当CPU支持VT技术，新一代的intel和amd x86处理器已经支持了VT技术）XEN需要修改被虚拟得操作系统，修改内核，

Xen采用了VT技术来实现计算机底层虚拟化功能，它很充分的发挥了硬件辅助虚拟化技术的优点，不再将虚拟机模型建立在真实机操作系统之上，而是在硬件平台上构建一套类似于中间件（并不是真正意义上的中间件）的软件逻辑层，所有操作系统都建立在这个“中间件”之上。

XEN的使用文档   <a href="http://www.linuxsir.org/main/?q=node/188">http://www.linuxsir.org/main/?q=node/188</a>

一、Xen是一款虚拟化软件，支持半虚拟化和完全虚拟化。它在不支持VT技术的cpu上也能使用，但是只能以半虚拟化模式运行。
二、半虚拟化的意思是需要修改被虚拟系统的内核，以实现系统能被完美的虚拟在Xen上面。完全虚拟化则是不需要修改系统内核则可以直接运行在Xen上面。
三、VMware是一款完全虚拟化软件。完全虚拟的弱点是效率不如半虚拟化的高。半虚拟化系统性能可以接近在裸机上的性能。
四、 Xen是由一个后台守护进程维护的，叫做xend，要运行虚拟系统，必须先将它开启。它的配置文件在/etc/xen/xend-config.sxp，内容包括宿主系统的类型，网络的连接结构、宿主操作系统的资源使用设定，以及vnc连接的一些内容。（如果你想增加一个虚拟网络设备的话，是需要在这里设定的）
五、/etc/xen/auto 的含义是如果你想让被虚拟系统随着宿主系统一同启动的话，就把虚拟系统的配置文件放到这个目录下面来。
六、/etc/xen/scripts 是些脚本文件，用于初始化各种虚拟设备，比如虚拟网桥等。（如果要增加一个虚拟网络设备，同样需要在此处调节）
七、在/etc/xen下面会有些配置文件，这就是虚拟系统引导时所必须的些文件，里面记录了引导和硬件信息。
八、Xen的配置工具有许多，我使用的是virt-manager（GUI）、virt-install和xm。第一个用于管理和安装系统，第二个只用于安装系统，第三个用于启动系统。
九、安装半虚拟Linux有两种方法，一种是利用Linux的网络安装方式安装，http、ftp、nfs方式都是可以的（特别注意：半虚拟环境下安装 Linux是不支持本地光驱或者iso镜像安装的！），并且RHEL5会自动生成配置文件。第二种是先建立镜像文件，并格式化，然后挂载到本地文件系统上来，将虚拟系统需要用到的文件拷贝进去并修改，然后手工创建配置文件并启动。
十、虚拟网络设备有三种模式：bridge桥模式、router路由模式和nat模式。其中桥模式是默认模式，在这种模式下，虚拟系统和宿主系统被认为是并列的关系，虚拟系统被配置IP或者dhcp后即可联通网络。
十一、原来的iptables无法对桥模式下的数据包做处理，RHEL5的iptables中增加了一个physdev的模块，可用iptables -m physdev -h查看帮助。
