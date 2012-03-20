--- 
wordpress_id: 688
layout: post
title: !binary |
  U1VTRSBTTEVTMTEgYm9uZOe9keWNoeeahFhFTue9keahpemXrumimA==

excerpt: !binary |
  Tm92ZWxsIFNVU0Xku4rlubQz5pyI5Lu95o6o5Ye65LqGU0xFUzEx77yM5Y+v
  5Lul5LuO5YW2572R56uZ5LiK5LiL6L295Yiw5a6J6KOF5YyF44CCU0xFUzEx
  5bCG5YaF5qC45Y2H57qn5YiwMi42LjI3LCBweXRob27ljYfnuqfliLAyLjbv
  vIx4ZW7ljYfnuqfliLAzLjPvvIzomb3nhLbmr5TkuLvmtYHniYjmnKzpg73o
  v5jlt67ngrnvvIzkvYbmr5RTTEVTIDEw5aW95b6I5aSa5LqG44CCDQoNClNM
  RVMgMTDnmoRYRU7nvZHmoaXmmK/kvb/nlKhuZXR3b3JrLWJyaWRnZeiEmuac
  rOWQr+WKqOeahO+8jOWQr+WKqOivpeiEmuacrOS5i+WQju+8jOWwseS4jeiD
  veeUqHlhc3TmnaXnrqHnkIbnvZHnu5zkuobvvIxTTEVTIDEx77yI5Lmf5Y+v
  6IO95piveGVuMy4z77yJ5pS56L+b5LqG6L+Z5Liq6Zeu6aKY77yM5bCG572R
  5qGl5pS55oiQ55SxaWZjb25maWfnrqHnkIbvvIzov5nmoLd4ZW7lj6rpnIDo
  poHlsIZ2aWbpmYTliqDliLDnvZHmoaXkuIrljbPlj6/jgIINCg0K5YW35L2T
  5q2l6aqk77ya5L2/55SoeWFzdOmFjee9ruWlvee9keWNoeS5i+WQju+8jOaJ
  p+ihjHlhc3QgeGVu77yMSW5zdGFsbCBIeXBlcnZpc29yIGFuZCBUb29sc++8
  jHlhc3TkvJrlrozmiJDnvZHmoaXnmoTphY3nva7jgIINCg0K5L2G6ZyA6KaB
  5rOo5oSP77yM5aaC5p6c5pivYm9uZOe9keWNoe+8jHlhc3TphY3nva7lh7rm
  naXnmoTnvZHmoaXlubbkuI3lj6/nlKjvvIzpnIDopoHlgZrlpoLkuIvkv67m
  lLnvvJo=

date: 2009-11-12 14:07:20 +08:00
wordpress_url: http://blog.59trip.com/?p=688
---
Novell SUSE今年3月份推出了SLES11，可以从其网站上下载到安装包。SLES11将内核升级到2.6.27, python升级到2.6，xen升级到3.3，虽然比主流版本都还差点，但比SLES 10好很多了。

SLES 10的XEN网桥是使用network-bridge脚本启动的，启动该脚本之后，就不能用yast来管理网络了，SLES 11（也可能是xen3.3）改进了这个问题，将网桥改成由ifconfig管理，这样xen只需要将vif附加到网桥上即可。

具体步骤：使用yast配置好网卡之后，执行yast xen，Install Hypervisor and Tools，yast会完成网桥的配置。

但需要注意，如果是bond网卡，yast配置出来的网桥并不可用，需要做如下修改：
1.) Rename ifcfg-br2 to ifcfg-bond0
2.) Delete ifcfg-br1
3.) Edit ifcfg-br0 and replace "BRIDGE_PORTS='eth1'" with BRIDGE_PORTS='bond0'"
4.) 将ifcfg-bond0的IPADDR删除，将IP配置到ifcfg-br0中, 修改BOOTPROTO='static'
5.) Restart networking (service network restart) 或者重启机器，如果不行就用yast重新配置一下br0的IP

network配置文件：
cat ifcfg-bond0
BONDING_MASTER='yes'
BONDING_MODULE_OPTS='mode=active-backup miimon=100'
BONDING_SLAVE0='eth0'
BONDING_SLAVE1='eth1'
BOOTPROTO='static'
BRIDGE='yes'
BRIDGE_FORWARDDELAY='0'
BRIDGE_PORTS='bond0'
BRIDGE_STP='off'
BROADCAST=''
ETHTOOL_OPTIONS=''
#IPADDR='192.168.194.104/24'
IPADDR=''
MTU=''
NETWORK=''
PREFIXLEN='24'
REMOTE_IPADDR=''
STARTMODE='auto'
USERCONTROL='no'

cat ifcfg-br0
BOOTPROTO='static'
BRIDGE='yes'
BRIDGE_FORWARDDELAY='0'
BRIDGE_PORTS='bond0'
BRIDGE_STP='off'
BROADCAST=''
ETHTOOL_OPTIONS=''
IPADDR='192.168.194.104/24'
#IPADDR=''
MTU=''
NETMASK=''
NETWORK=''
REMOTE_IPADDR=''
STARTMODE='auto'
USERCONTROL='no'
NAME=''


参考资料：
<a href="http://forums.novell.com/novell-product-support-forums/suse-linux-enterprise-server-sles/sles-virtualization/383009-bonding-dual-nics-sles11-xen-mode.html">http://forums.novell.com/novell-product-support-forums/suse-linux-enterprise-server-sles/sles-virtualization/383009-bonding-dual-nics-sles11-xen-mode.html</a>

<a href="http://forums.novell.com/novell-product-support-forums/suse-linux-enterprise-server-sles/sles-virtualization/375183-sles11-xen-bonding-bridging.html">http://forums.novell.com/novell-product-support-forums/suse-linux-enterprise-server-sles/sles-virtualization/375183-sles11-xen-bonding-bridging.html</a>
