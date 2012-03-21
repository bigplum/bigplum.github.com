--- 
wordpress_id: 952
layout: post
title: !binary |
  bGludXjkuIvmiZPljIXlj5HluIN3eHB5dGhvbueoi+W6jw==

date: 2010-12-31 13:51:38 +08:00
wordpress_url: http://pipa.tk/?p=952
---
windows打包wxpython程序比较简单，用py2exe就能全部搞定了。

Linux下面有好多工具可以选择: <a href="http://wiki.python.org/moin/DistributionUtilities">http://wiki.python.org/moin/DistributionUtilities</a> 看的头都大了，试用了freeze, cx_freeze 都一一败下阵来。都是没把wx的运行库拷贝到发布目录。

记录一下碰到的错误：
ImportError: libwx_gtk2u_richtext-2.8.so.0: cannot open shared object file: No such file or directory

最后用pyinstaller才搞定。
{% highlight bash%}
# cd pyinstaller-1.4/source/linux
# python Make.py #[-n|-e]
...
# make
# cd ../..
# ./Configure.py
I: read old config from ./config.dat
I: computing EXE_dependencies
I: Finding TCL/TK...
I: could not find TCL/TK
I: testing for Zlib...
I: ... Zlib available
I: Testing for Unicode support...
I: ... Unicode available
I: testing for UPX...
sh: upx: not found
I: ...UPX unavailable
I: computing PYZ dependencies...
I: done generating ./config.dat
# cd ../uploadUI
# python ../pyinstaller-1.4/Makespec.py --onefile uploadUI.py
wrote /home/simon/client/uploadUI/uploadUI.spec
now run Build.py to build the executable
# python ../pyinstaller-1.4/Build.py uploadUI.spec
checking Analysis
checking PYZ
checking PKG
building because exclude_binaries changed
building PKG outPKG3.pkg
checking EXE
rebuilding outEXE2.toc because uploadUI missing
building EXE from outEXE2.toc
Appending archive to EXE /home/simon/client/uploadUI/dist/uploadUI
{% endhighlight %}
