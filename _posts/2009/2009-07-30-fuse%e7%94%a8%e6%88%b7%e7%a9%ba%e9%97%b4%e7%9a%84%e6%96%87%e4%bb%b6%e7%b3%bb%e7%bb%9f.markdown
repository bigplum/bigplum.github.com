--- 
wordpress_id: 440
layout: post
title: !binary |
  RlVTRS0t55So5oi356m66Ze055qE5paH5Lu257O757uf

excerpt: !binary |
  RlVTReaYr+S4gOS4quWGheaguOaWh+S7tuezu+e7n+eahOaOpeWPo++8jOmA
  mui/h+ivpeaOpeWPo+WPr+S7peWcqOeUqOaIt+epuumXtOWunueOsOS4gOS4
  quaWh+S7tuezu+e7n++8jOWwhuWFtm1vdW505Yiw5YaF5qC477yb6L+Z5qC3
  6K+05Y+v6IO95q+U6L6D5oq96LGh77yM5b2i6LGh5LiA54K55bCx5piv5Y+v
  5Lul5oqK5Lu75L2V5Lic6KW/6YO95YGa5oiQ5pys5Zyw5paH5Lu257O757uf
  5p2l55So77yM5L6L5aaC77yaZ21haWxmcyjlsIZnbWFpbOW9k+acrOWcsOeh
  rOebmOadpeeUqCksIGJsb2dmc++8iOWwhndvcmRwcmVzc+aUvuWIsOacrOWc
  sO+8iSwgc3NoZnMuLi4uLi4NCg0KbGludXgyLjblhoXmoLjlt7Lnu4/pu5jo
  rqTmlK/mjIFmdXNl5qih5Z2X77yM6YCa6L+HbW9kcHJvYmUgZnVzZeWKoOi9
  veOAguWuieijheW+iOeugOWNle+8jDxhIGhyZWY9Imh0dHA6Ly9zb3VyY2Vm
  b3JnZS5uZXQvcHJvamVjdHMvZnVzZS8iPuS4i+i9vTwvYT7vvIxjb25maWd1
  cmUvbWFrZS9tYWtlIGluc3RhbGzljbPlj6/jgII=

date: 2009-07-30 08:07:17 +08:00
wordpress_url: http://blog.59trip.com/?p=440
---
<em>FUSE makes it possible to implement a filesystem in a userspace program. Features include: simple yet comprehensive API, secure mounting by non-root users, support for 2.4 and 2.6 Linux kernels, multi-threaded operation. etc...</em>

FUSE是一个内核文件系统的接口，通过该接口可以在用户空间实现一个文件系统，将其mount到内核；这样说可能比较抽象，形象一点就是可以把任何东西都做成本地文件系统来用，例如：gmailfs(将gmail当本地硬盘来用), blogfs（将wordpress放到本地）, sshfs......<a href="http://sourceforge.net/apps/mediawiki/fuse/index.php?title=FileSystems#BloggerFS">更多</a>

linux2.6内核已经默认支持fuse模块，通过modprobe fuse加载。安装很简单，<a href="http://sourceforge.net/projects/fuse/">下载</a>，configure/make/make install即可。
<!--more-->
FUSE支持<a href="http://sourceforge.net/apps/mediawiki/fuse/index.php?title=LanguageBindings">很多语言接口</a>，我使用的是python：<a href="http://sourceforge.net/apps/mediawiki/fuse/index.php?title=FusePython">FusePython</a>，安装过程如下：
<pre class=php name=code>linux-cjfq:~/fusepy/python # python setup.py build
running build
running build_py
creating build
creating build/lib.linux-i686-2.4
copying fuse.py -> build/lib.linux-i686-2.4
creating build/lib.linux-i686-2.4/fuseparts
copying fuseparts/setcompatwrap.py -> build/lib.linux-i686-2.4/fuseparts
copying fuseparts/subbedopts.py -> build/lib.linux-i686-2.4/fuseparts
copying fuseparts/__init__.py -> build/lib.linux-i686-2.4/fuseparts
running build_ext
building 'fuseparts._fusemodule' extension
creating build/temp.linux-i686-2.4
creating build/temp.linux-i686-2.4/fuseparts
gcc -pthread -fno-strict-aliasing -DNDEBUG -O2 -march=i586 -mtune=i686 -fmessage-length=0 -Wall -D_FORTIFY_SOURCE=2 -g -fPIC -I/usr/local/include/fuse -I/usr/include/python2.4 -c fuseparts/_fusemodule.c -o build/temp.linux-i686-2.4/fuseparts/_fusemodule.o -D_FILE_OFFSET_BITS=64
gcc -pthread -shared build/temp.linux-i686-2.4/fuseparts/_fusemodule.o -L/usr/local/lib -lfuse -lrt -ldl -o build/lib.linux-i686-2.4/fuseparts/_fusemodule.so
</pre>
FusePython的example中带了两个例子，
1. hello.py: 虚拟一个只带hello文件的文件系统
<pre class=php name=code># python hello.py /mnt
# cat /mnt/hello
Hello World!</pre>
2. xmp.py 将根目录虚拟成一个文件系统，执行后可以看到/mnt目录下的内容与/下相同
<pre class=php name=code># python xmp.py /mnt</pre>
