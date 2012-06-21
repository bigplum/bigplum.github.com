--- 
layout: post
title: !binary |
  5aaC5L2V57yW6K+RWEVO6Jma5ouf5py65YaF5qC477yI5LqM77yJLeS9v2Rv
  bVXmlK/mjIFORlPlvJXlr7w=

excerpt: !binary |
  MS4g5L+u5pS55YaF5qC457yW6K+R6YCJ6aG577yM6YCa6L+HbWFrZSBtZW51
  Y29uZmln5L+u5pS557yW6K+R6YCJ6aG577yM5a+55pu05paw5ZCO55qE5YaF
  5qC46L+b6KGM6YeN5paw57yW6K+R77yaDQpjZCAgeGVuLTMuMy4xL2J1aWxk
  LWxpbnV4LTIuNi4xOC14ZW5feDg2XzMyLw0KbWFrZSBtZW51Y29uZmlnDQpj
  ZCAuLg0KbWFrZSBsaW51eC0yLjYteGVuLWJ1aWxkICAgLy/ku4Xph43mlrDn
  vJbor5Hmm7TmlrDnmoTlhoXlrrkNCm1ha2UgbGludXgtMi42LXhlbi1pbnN0
  YWxsICAgDQoNCjIuIOS9v2RvbVXlhoXmoLjmlK/mjIFORlPlkK/liqgNCmEu
  IOS9v+WGheaguOaUr+aMgU5GUw==

date: 2009-06-04 19:16:09 +08:00
---
1. 修改内核编译选项，通过make menuconfig修改编译选项，对更新后的内核进行重新编译：
cd  xen-3.3.1/build-linux-2.6.18-xen_x86_32/
make menuconfig
cd ..
make linux-2.6-xen-build   //仅重新编译更新的内容
make linux-2.6-xen-install   

2. 使domU内核支持NFS启动
a. 使内核支持NFS
make menuconfig > enable under File systems > Network File Systems:
<*> NFS file system support<!--more-->
b. 编辑.config 将 CONFIG_ROOT_NFS=y 和 CONFIG_IP_PNP=y 修改为y，如果没有这两个选项，需要手工添加；
c. make menuconfig 检查"File systems > Network File Systems > Root file system on NFS" 是否选中，并保存；
d. 用上述1的方法重新编译内核；
e. 用<a href="http://www.xenhome.co.cc/blog/archives/36">这里面</a>提到的方法重新生成vmlinuz
可以修改domU的配置文件，使domU从NFS引导。（不过需要先制作好一份可用的root文件系统）

3. 支持NFS引导的sxp文件
# Common things.
kernel  = '/boot/vmlinuz-2.6.18.8-xen'
#ramdisk = "/boot/initrd-2.6.18-xen"

memory  = '256'

#  Name
name     = 'nfsvm'
hostname = 'nfsvm'

# Networking basics
vif     = [ 'ip=192.168.194.97' ]
netmask   = '255.255.255.0'
gateway   = '192.168.194.1'
ip        = '192.168.194.97'
broadcast = '192.168.194.255'

# NFS option
nfs_server = '192.168.194.94'
nfs_root   = '/mnt/boot'
root       = '/dev/nfs'
