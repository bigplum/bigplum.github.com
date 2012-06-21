--- 
layout: post
title: !binary |
  5L2/55SoVkPnvJbor5F3aW5kb3dz54mI5pysbmdpbng=

date: 2011-07-13 16:59:20 +08:00
---
<strong>1. 配置环境</strong>
先参考<a href="http://pipa.tk/archives/1020">《在Windows下编译Windows版本的Nginx》</a>所述，配置mingw的运行环境；然后修改 /usr/local/etc/profile.local
假设Windows SDK安装在 D:\Program Files\Microsoft SDKs， VC2010安装在E:\Program Files\Microsoft Visual Studio 10.0，配置如下变量：
{% highlight bash%}
vi /usr/local/etc/profile.local
PATH="${PATH}:/opt/bin:/e/Program Files/Microsoft Visual Studio 10.0/VC/lib:/e/Program Files/Microsoft Visual Studio 10.0/VC/include:/e/Program Files/Microsoft Visual Studio 10.0/VC/bin:/e/Program Files/Microsoft Visual Studio 10.0/Common7/IDE:/d/Program Files/Microsoft SDKs/Windows/v7.0A/bin:"
LIB="E:\Program Files\Microsoft Visual Studio 10.0\VC\LIB;E:\Program Files\Microsoft Visual Studio 10.0\VC\ATLMFC\LIB;D:\Program Files\Microsoft SDKs\Windows\v7.0A\lib;"
LIBPATH="D:\WINDOWS\Microsoft.NET\Framework\v4.0.30319;D:\WINDOWS\Microsoft.NET\Framework\v3.5;E:\Program Files\Microsoft Visual Studio 10.0\VC\LIB;E:\Program Files\Microsoft Visual Studio 10.0\VC\ATLMFC\LIB;"
export LIB LIBPATH
{% endhighlight %}
使变量生效：
{% highlight bash%}
source /usr/local/etc/profile.local
{% endhighlight %}

<strong>2. 执行脚本</strong>
{% highlight bash%}
./configure --prefix=. --sbin-path=nginx --with-cc-opt="-D FD_SETSIZE=4096 -I \"d:\Program Files\Microsoft SDKs\Windows\v7.0A\include\" -I \"e:\Program Files\Microsoft Visual Studio 10.0\VC\include\"" --without-http_rewrite_module --without-http_gzip_module --with-cc=cl
{% endhighlight %}

修改Makefile，删除告警选项-W4 -WX
{% highlight bash%}
vi objs/Makefile
CFLAGS =  -O2  <strong>-W4 -WX</strong> -nologo -MT -Zi -D FD_SETSIZE=4096 -I "d:\Program Files\Micr.....................
{% endhighlight %}

修改nginx.c, 删除255行；
{% highlight c %}
        if (ngx_show_configure) {
#ifdef NGX_COMPILER
            ngx_log_stderr(0, "built by " NGX_COMPILER);
#endif
#if (NGX_SSL)
#ifdef SSL_CTRL_SET_TLSEXT_HOSTNAME
            ngx_log_stderr(0, "TLS SNI support enabled");
#else
            ngx_log_stderr(0, "TLS SNI support disabled");
#endif
#endif
            /*
            ngx_log_stderr(0, "configure arguments:" NGX_CONFIGURE);
            */
        }
{% endhighlight %}

<strong>3. 编译</strong>
{% highlight bash%}
nmake
.............
l objs/nginx.exe
-rwxr-xr-x 1 l37366 Administrators 610304 Jul 13 10:19 objs/nginx.exe
{% endhighlight %}

<strong>4. 运行</strong>
报错了，堆访问异常。修改下代码，ngx_shmem.c:22
{% highlight c %}
- (void) ngx_sprintf(name, "%V_%s%Z", &shm->name, ngx_unique);
+ (void) ngx_snprintf(name, shm->name.len + 2 + sizeof(NGX_INT32_LEN),
+ "%V_%s%Z", &shm->name, ngx_unique);
{% endhighlight %}
重新编译，可以运行了。
