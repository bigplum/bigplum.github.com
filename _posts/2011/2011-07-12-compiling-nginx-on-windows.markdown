--- 
layout: post
title: 在Windows下编译Windows版本的Nginx
date: 2011-07-12 22:28:56 +08:00
---
上一篇讲了肿么[在Linux下使用MinGW编译Windows版本的Nginx](http://pipablog.tk/2011/07/11/compiling-windows-nginx-on-linux-by-mingw/)，这里再补充下肿么直接在Windows下编译Windows版本的Nginx。

Windows下使用mingw比较简单，下载安装之后，<a href="http://ingar.satgnu.net/devenv/mingw32/base.html">参考这篇文章安装rxvt，配置开发环境</a>。

1. 拷贝windows lib库文件到trunk目录: advapi32.lib ws2_32.lib

2. 编译
启动rxvt终端，进入trunk目录，执行：
{% highlight bash%}
./configure --prefix=. --sbin-path=nginx --with-cc-opt="-D FD_SETSIZE=4096 -D __NO_MINGW_LFS -D __WATCOMC__" --without-http_rewrite_module --without-http_gzip_module
vi objs/Makefile   #删除 -Werror
make
{% endhighlight %}

3. 备注
__NO_MINGW_LFS选项用于规避下列错误：
{% highlight bash%}
In file included from src/core/ngx_config.h:37:0,
                 from src/core/nginx.c:7:
src/os/win32/ngx_win32_config.h:129:29: error: conflicting types for 'ssize_t'
c:\mingw\bin\../lib/gcc/mingw32/4.5.2/../../../../include/sys/types.h:118:18: note: previous declaration of 'ssize_t' was here
src/os/win32/ngx_win32_config.h:130:29: error: conflicting types for 'off_t'
c:\mingw\bin\../lib/gcc/mingw32/4.5.2/../../../../include/sys/types.h:55:16: note: previous declaration of 'off_t' was here
make[1]: *** [objs/src/core/nginx.o] Error 1
make[1]: Leaving directory `/e/src/c/nginx-svn/nginx/trunk'
make: *** [build] Error 2
{% endhighlight %}
