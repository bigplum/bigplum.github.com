--- 
layout: post
title: !binary |
  cHl0aG9u55qEc3Zu5qih5Z2X

date: 2011-11-29 19:43:31 +08:00
---
在suse10下安装svn需要编译，挺麻烦的。安装trac和svn时，发现需要python的svn模块，找了半天找到一个pysvn，装上之后发现不是这个模块。原来应该通过swig编译svn代码。

步骤如下：

{% highlight bash%}
cd ~/install_files
tar zxf subversion-1.4.3.tar.gz
cd subversion-1.4.3
./configure PYTHON=/usr/local/bin/python \
--with-swig=$HOME/packages/bin/swig --without-berkeley-db \
--with-ssl --with-zlib
make
make install
make swig-py
make install-swig-py
cd /usr/local/lib/python2.3/site-packages
echo /usr/local/lib/svn-python > subversion.pth
ln -s /usr/local/lib/svn-python/libsvn
ln -s /usr/local/lib/svn-python/svn
ln -s /usr/local/lib/libsvn_swig_py-1.so.0
Test it with python -c "from svn import client" (No errors should result.)
{% endhighlight %}

在suse这样的系统上安装python相关的东西很痛苦，装一个trac要下好几个包，又是编译，又是用yast安装。unix的这种哲学有时候也挺不便的。
