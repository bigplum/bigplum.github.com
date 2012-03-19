--- 
wordpress_id: 144
layout: post
title: !binary |
  eGVu572R57uc6Zeu6aKY55qE5a6a5L2N5oCd6Lev77yI572R5qGl5qih5byP
  77yJ

excerpt: !binary |
  6KOF5aW9eGVu6Jma5ouf5py65LmL5ZCO77yM5aaC5p6c572R57uc5LiN6YCa
  5Lya5b6I5oG854Gr5LiN55+l5aaC5L2V5LiL5omL77yM5LuL57uN5LiA5LiL
  5oiR5LiA6Iis56Kw5Yiw6L+Z5Lqb6Zeu6aKY55qE5a6a5L2N5q2l6aqk44CC
  5Lul5LiL5Z+65LqOc3VzZSAxMO+8jHhlbueJiOacrOW6lOivpeaYrzMuMeOA
  gg==

date: 2009-06-20 16:40:17 +08:00
wordpress_url: http://blog.59trip.com/?p=144
---
装好xen虚拟机之后，如果网络不通会很恼火不知如何下手，介绍一下我一般碰到这些问题的定位步骤。以下基于suse 10，xen版本应该是3.1。

1. 检查domU的网卡是否正常，用ifconfig查看mac地址是否和xen配置文件的vif配置相同；ping网卡的ip是否可达。
<pre class=php name=code>linux-cjfq:~ # ifconfig
eth0      Link encap:Ethernet  HWaddr 00:16:3E:21:C4:F7

# cat suse_99.sxp
vif=[ 'mac=00:16:3e:21:c4:f7', ]</pre>
<!--more-->
2. 保证dom0是和网络连通的；dom0和domU可以不在一个网段，例如dom0使用10.1.2.0网段，掩码为255.255.255.0，domU使用10.1.3.0网段，掩码为255.255.255.0，dom0和domU之间互相不能ping通，但能和各自网段内的机器通信。

3. 检查dom0上的虚拟网卡设备是否正常，vif设备的编号和xm list看到的id是对应的；
若domU为半虚拟化，则dom0的ifconfig能看到一个vif的设备：
<pre class=php name=code>vif1.0    Link encap:Ethernet  HWaddr FE:FF:FF:FF:FF:FF
          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
          RX packets:79119 errors:0 dropped:0 overruns:0 frame:0
          TX packets:325938 errors:0 dropped:113 overruns:0 carrier:0
          collisions:0 txqueuelen:32
          RX bytes:25527092 (24.3 Mb)  TX bytes:136111227 (129.8 Mb)
//若domU为半虚拟化，则dom0的ifconfig能看到tap和vif两个设备：
tap0      Link encap:Ethernet  HWaddr DA:2A:EA:33:2E:B7
          inet6 addr: fe80::d82a:eaff:fe33:2eb7/64 Scope:Link
          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
          RX packets:521847 errors:0 dropped:0 overruns:0 frame:0
          TX packets:3413468 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:500
          RX bytes:288369497 (275.0 Mb)  TX bytes:468761976 (447.0 Mb)
vif11.0   Link encap:Ethernet  HWaddr FE:FF:FF:FF:FF:FF
          inet6 addr: fe80::fcff:ffff:feff:ffff/64 Scope:Link
          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
          RX packets:0 errors:0 dropped:0 overruns:0 frame:0
          TX packets:0 errors:0 dropped:8611878 overruns:0 carrier:0
          collisions:0 txqueuelen:32
          RX bytes:0 (0.0 b)  TX bytes:0 (0.0 b)</pre>
4. 检查dom0上的网桥设置是否正常，通常使用下面几个命令；
<pre class=php name=code>linux-uoiv:/vm # brctl show
bridge name     bridge id               STP enabled     interfaces
bond0           8000.0018822e2450       no              pbond0
                                                                          vif1.0
//domU的vif网卡是通过pbond0网卡接入网络的，xen虚拟了一个网桥设备bond0，pbond0和vif1.0都接到这个网桥上。
linux-uoiv:~ # /etc/xen/scripts/network-bridge status
============================================================
8: bond0: <BROADCAST,MULTICAST,UP,10000> mtu 1500 qdisc noqueue
    link/ether 00:18:82:2e:24:50 brd ff:ff:ff:ff:ff:ff
    inet 192.168.194.133/23 brd 192.168.195.255 scope global bond0
8: bond0: <BROADCAST,MULTICAST,UP,10000> mtu 1500 qdisc noqueue
    link/ether 00:18:82:2e:24:50 brd ff:ff:ff:ff:ff:ff
    inet 192.168.194.133/23 brd 192.168.195.255 scope global bond0

bridge name     bridge id               STP enabled     interfaces
bond0           8000.0018822e2450       no              pbond0
                                                        vif1.0

10.1.1.0/24 dev eth3  proto kernel  scope link  src 10.1.1.72
192.168.194.0/23 dev bond0  proto kernel  scope link  src 192.168.194.133
169.254.0.0/16 dev eth3  scope link
127.0.0.0/8 dev lo  scope link
default via 192.168.194.1 dev bond0

Kernel IP routing table
Destination     Gateway         Genmask         Flags Metric Ref    Use Iface
10.1.1.0        0.0.0.0         255.255.255.0   U     0      0        0 eth3
192.168.194.0   0.0.0.0         255.255.254.0   U     0      0        0 bond0
169.254.0.0     0.0.0.0         255.255.0.0     U     0      0        0 eth3
127.0.0.0       0.0.0.0         255.0.0.0       U     0      0        0 lo
0.0.0.0         192.168.194.1   0.0.0.0         UG    0      0        0 bond0</pre>
如果有多个网卡，并且不使用eth0作为网桥出口的话，请参考<a href="http://blog.59trip.com/archives/6">xen启动默认网桥的问题</a>进行配置。
