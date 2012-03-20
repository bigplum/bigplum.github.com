--- 
wordpress_id: 1029
layout: post
title: !binary |
  5L2/55SoVkPnvJbor5F3aW5kb3dz54mI5pysbmdpbng=

date: 2011-07-13 16:59:20 +08:00
wordpress_url: http://pipa.tk/?p=1029
---
<strong>1. 配置环境</strong>
先参考<a href="http://pipa.tk/archives/1020">《在Windows下编译Windows版本的Nginx》</a>所述，配置mingw的运行环境；然后修改 /usr/local/etc/profile.local
假设Windows SDK安装在 D:\Program Files\Microsoft SDKs， VC2010安装在E:\Program Files\Microsoft Visual Studio 10.0，配置如下变量：
[bash]
vi /usr/local/etc/profile.local
PATH=&quot;${PATH}:/opt/bin:/e/Program Files/Microsoft Visual Studio 10.0/VC/lib:/e/Program Files/Microsoft Visual Studio 10.0/VC/include:/e/Program Files/Microsoft Visual Studio 10.0/VC/bin:/e/Program Files/Microsoft Visual Studio 10.0/Common7/IDE:/d/Program Files/Microsoft SDKs/Windows/v7.0A/bin:&quot;
LIB=&quot;E:\Program Files\Microsoft Visual Studio 10.0\VC\LIB;E:\Program Files\Microsoft Visual Studio 10.0\VC\ATLMFC\LIB;D:\Program Files\Microsoft SDKs\Windows\v7.0A\lib;&quot;
LIBPATH=&quot;D:\WINDOWS\Microsoft.NET\Framework\v4.0.30319;D:\WINDOWS\Microsoft.NET\Framework\v3.5;E:\Program Files\Microsoft Visual Studio 10.0\VC\LIB;E:\Program Files\Microsoft Visual Studio 10.0\VC\ATLMFC\LIB;&quot;
export LIB LIBPATH
[/bash]
使变量生效：
[bash]
source /usr/local/etc/profile.local
[/bash]

<strong>2. 执行脚本</strong>
[bash]
./configure --prefix=. --sbin-path=nginx --with-cc-opt=&quot;-D FD_SETSIZE=4096 -I \&quot;d:\Program Files\Microsoft SDKs\Windows\v7.0A\include\&quot; -I \&quot;e:\Program Files\Microsoft Visual Studio 10.0\VC\include\&quot;&quot; --without-http_rewrite_module --without-http_gzip_module --with-cc=cl
[/bash]

修改Makefile，删除告警选项-W4 -WX
[bash]
vi objs/Makefile
CFLAGS =  -O2  &lt;strong&gt;-W4 -WX&lt;/strong&gt; -nologo -MT -Zi -D FD_SETSIZE=4096 -I &quot;d:\Program Files\Micr.....................
[/bash]

修改nginx.c, 删除255行；
[c]
        if (ngx_show_configure) {
#ifdef NGX_COMPILER
            ngx_log_stderr(0, &quot;built by &quot; NGX_COMPILER);
#endif
#if (NGX_SSL)
#ifdef SSL_CTRL_SET_TLSEXT_HOSTNAME
            ngx_log_stderr(0, &quot;TLS SNI support enabled&quot;);
#else
            ngx_log_stderr(0, &quot;TLS SNI support disabled&quot;);
#endif
#endif
            /*
            ngx_log_stderr(0, &quot;configure arguments:&quot; NGX_CONFIGURE);
            */
        }
[/c]

<strong>3. 编译</strong>
[bash]
nmake
.............
l objs/nginx.exe
-rwxr-xr-x 1 l37366 Administrators 610304 Jul 13 10:19 objs/nginx.exe
[/bash]

<strong>4. 运行</strong>
报错了，堆访问异常。修改下代码，ngx_shmem.c:22
[c]
- (void) ngx_sprintf(name, &quot;%V_%s%Z&quot;, &amp;shm-&gt;name, ngx_unique);
+ (void) ngx_snprintf(name, shm-&gt;name.len + 2 + sizeof(NGX_INT32_LEN),
+ &quot;%V_%s%Z&quot;, &amp;shm-&gt;name, ngx_unique);
[/c]
重新编译，可以运行了。
