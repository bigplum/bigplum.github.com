--- 
layout: post
title: !binary |
  U1VTRSBTTEVTMTEgYm9uZOe9keWNoeeahFhFTue9keahpemXrumimA==

date: 2009-11-12 14:07:20 +08:00

tags: 
    - xen
---
Novell SUSE今年3月份推出了SLES11，可以从其网站上下载到安装包。SLES11将内核升级到2.6.27, python升级到2.6，xen升级到3.3，虽然比主流版本都还差点，但比SLES 10好很多了。

SLES 10的XEN网桥是使用network-bridge脚本启动的，启动该脚本之后，就不能用yast来管理网络了，SLES 11（也可能是xen3.3）改进了这个问题，将网桥改成由ifconfig管理，这样xen只需要将vif附加到网桥上即可。

具体步骤：使用yast配置好网卡之后，执行yast xen，Install Hypervisor and Tools，yast会完成网桥的配置。

但需要注意，如果是bond网卡，yast配置出来的网桥并不可用，需要做如下修改：

1. Rename ifcfg-br2 to ifcfg-bond0
2. Delete ifcfg-br1
3. Edit ifcfg-br0 and replace "BRIDGE_PORTS='eth1'" with BRIDGE_PORTS='bond0'"
4. 将ifcfg-bond0的IPADDR删除，将IP配置到ifcfg-br0中, 修改BOOTPROTO='static'
5. Restart networking (service network restart) 或者重启机器，如果不行就用yast重新配置一下br0的IP

network配置文件：

`cat ifcfg-bond0`

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
    
`cat ifcfg-br0`

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
