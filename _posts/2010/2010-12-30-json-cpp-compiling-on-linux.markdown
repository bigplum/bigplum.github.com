--- 
wordpress_id: 948
layout: post
title: !binary |
  anNvbi1jcHDlupPlnKhsaW51eOS4i+eahOe8luivkQ==

date: 2010-12-30 09:54:07 +08:00
wordpress_url: http://pipa.tk/?p=948
---
jsoncpp是一个c++封装的json包，跨平台支持windows、linux、unix等多系统，macOS据说也支持。在windows下面使用比较简单，直接往vc里面添加项目就可以了。linux下面编译需要使用到scons，scons又是一个牛叉的工具，功能和GNU make一样，又比make简单多了。scons是python工具，需要先安装好python。

下载scons-src-2.0.1，解压。不需要编译安装，可以直接使用源码，用法如下。
{% highlight bash%}
        # cd scons-src-2.0.1
        # export MYSCONS=`pwd`/src
        # export SCONS_LIB_DIR=$MYSCONS/engine
        # python $MYSCONS/script/scons.py [arguments]
{% endhighlight %}

具体到jsoncpp的编译，可以进入到jsoncpp目录，执行
{% highlight bash%}
# cd jsoncpp-src-0.5.0
# python $MYSCONS/script/scons.py platform=linux-gcc
{% endhighlight %}

生成jsoncpp-src-0.5.0/libs/linux-gcc-4.3/libjson_linux-gcc-4.3_libmt.a和.so两个库文件。
