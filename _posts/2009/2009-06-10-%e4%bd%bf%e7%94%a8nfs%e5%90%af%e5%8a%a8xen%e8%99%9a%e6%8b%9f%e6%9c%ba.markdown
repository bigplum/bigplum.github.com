--- 
wordpress_id: 75
layout: post
title: !binary |
  5L2/55SoTkZT5ZCv5YqoeGVu6Jma5ouf5py6

excerpt: !binary |
  5Lyg57uf55qE5L2/55SoeGVu6Jma5ouf5py655qE5pa55byP5piv5ZyoZG9t
  MOacrOWcsOeUn+aIkOS4gOS4quW3sue7j+WuieijheWlveezu+e7n+eahGx2
  5oiW6ICF5paH5Lu277yM5Zyo5LiK6Z2i5ZCv5YqoZG9tVeezu+e7n+S5i+WQ
  ju+8jOeZu+mZhuWIsGNvbnNvbGXnlYzpnaLkv67mlLlpcOWcsOWdgOetiemF
  jee9ruOAguaVtOS4quatpemqpOmavuS7pemAmui/h+iEmuacrOiHquWKqOWu
  jOaIkOOAguaJgOS7peimgeaDs+WunueOsGFtYXpvbiBFQzLpgqPmoLfoh6rl
  iqjnlJ/miJDorqHnrpfnjq/looPnmoTlip/og73vvIzlsLHkuI3og73ov5nm
  oLfmnaXmkJ7kuobjgIINCumAmui/h05GUyBib290IGRvbVXvvIzlj6/ku6Xp
  mY3kvY7nlJ/miJDomZrmi5/mnLrnmoTlpI3mnYLluqbvvIzln7rmnKzlrp7n
  jrDoh6rliqjljJbnlJ/miJBkb21V55qE5Yqf6IO944CC5Lul5LiL6L+H56iL
  5Lulc3VzZTEwIFNQMuS4uuS+i+OAgg==

date: 2009-06-10 18:10:09 +08:00
wordpress_url: http://blog.59trip.com/?p=75
---
传统的使用xen虚拟机的方式是在dom0本地生成一个已经安装好系统的lv或者文件，在上面启动domU系统之后，登陆到console界面修改ip地址等配置。整个步骤难以通过脚本自动完成。所以要想实现amazon EC2那样自动生成计算环境的功能，就不能这样来搞了。
通过NFS boot domU，可以降低生成虚拟机的复杂度，基本实现自动化生成domU的功能。以下过程以suse10 SP2为例。
1. 编译支持NFS启动的xen内核，请参考前面的文章<a href="http://blog.59trip.com/archives/44"><如何编译XEN虚拟机内核（二）-使domU支持NFS引导 ></a><!--more-->
2. 安装NFS服务器，这个比较简单，通过yast->Network Services->NFS Server启动NFS Server服务。
3. 准备root文件系统，没找到suse的生成root fs的工具，就手工拷贝了一个root目录到/home/vm/boot.1
4. 修改/etc/exports, 将/home/vm/boot.1加入到nfs中
<pre name=code class=php>/home/vm/boot.1 *(ro,sync,async,no_root_squash,subtree_check)</pre>
测试一下nfs是否正常：
<pre name=code class=php>#mount -t nfs nfsserver:/home/vm/boot.1/mnt</pre>
5. 准备xen配置文件suse.vm
<pre name=code class=php># Common things.
kernel  = '/boot/vmlinuz-2.6.18.8-xen'
memory  = '256'

#  Name
name     = 'suse10'
hostname = 'suse10'

# Networking basics
vif     = [ 'ip=192.168.194.99' ]
netmask   = '255.255.255.0'
gateway   = '192.168.194.1'
ip        = '192.168.194.99'
broadcast = '192.168.194.255'

# NFS option
nfs_server = '192.168.194.249'
nfs_root   = '/home/vm/boot.1'
root       = '/dev/nfs'
</pre>
6. 启动domU
<pre name=code class=php>#xm create suse.vm -c</pre>
如果没有异常，domU启动之后就自动获取到ip地址192.168.194.99。
登陆系统后，查看root文件系统的大小和nfsserver目录/home/vm/boot.1的可用大小是一样的。
<pre name=code class=php>#suse10:~ # df -k
Filesystem           1K-blocks      Used Available Use% Mounted on
/dev/hda1             59085232   9184580  49900652  16% /
udev                    131176        48    131128   1% /dev</pre>
用fdisk -l，则查看不到有磁盘设备。

