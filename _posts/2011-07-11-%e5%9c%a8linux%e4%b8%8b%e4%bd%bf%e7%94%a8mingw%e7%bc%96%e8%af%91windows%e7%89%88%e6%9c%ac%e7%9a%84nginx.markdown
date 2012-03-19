--- 
wordpress_id: 1010
layout: post
title: !binary |
  5ZyoTGludXjkuIvkvb/nlKhNaW5HV+e8luivkVdpbmRvd3PniYjmnKznmoRO
  Z2lueA==

date: 2011-07-11 17:30:37 +08:00
wordpress_url: http://pipa.tk/?p=1010
---
简单的说，<a href="http://mingw.org/">MinGW</a>是一个和cygwin类似的东东，可以在windows下面使用gcc等GNU工具开发程序，通常用于移植linux下开发的软件到windows。最大的区别在于mingw使用的是windows native api，因此编译出来的程序不用依赖第三方的dll库，只需要windows自身的dll；而cygwin编译的程序，需要附带cygwin的dll才能运行；并且mingw的性能要好一点。

mingw可在windows和linux下运行，通过指定target platform，linux下可编译windows平台程序。
<strong>0.  安装wine</strong>
wine是linux下执行win程序的软件包，编译windows版本的nginx，需要通过wine配合。Igor Sysoev通过wine来发布官方的windows版nginx，但是没有给出具体的编译步骤。在网上看了无数帖子之后，还是没找到具体的步骤，只好自己摸索。
[bash]
The Windows version is provided as a binary-only due to the current build process (which currently uses some Wine tools). When the build process has been cleaned up, source will be made available. Igor does not want to support build issues with the current system.
[/bash]

<strong>1.  首先安装mingw</strong>
从官网下载安装包，解压执行：
[bash]
sh x86-mingw32-build.sh

 Do you wish to select components individually? (Default: NO)? 

 Please enter your preferred option: (Default: 1): 

 Would you like me to download any of these optional language packages?
 (Default: YES)? 

 Do you require support for language `ada'? (Default: YES) no
 Do you require support for language `c++'? (Default: YES) 
 Do you require support for language `f77'? (Default: YES) no
 Do you require support for language `java'? (Default: YES) no
 Do you require support for language `objc'? (Default: YES) no

 (Default: /home/simon/packages/mingw-3.4.5)? 

 Enter the index number for your choice: (Default: 0): 1

 Would you like to enable NLS for your cross compiler?
 (Default: NO)? 

 Would you like to use shared libraries available on this host?
 (Default: YES)? no

 Do you wish to retain the standard setjmp/longjmp exception handler?
 (Default: YES)?

 Where should I install the cross-compiler, and its support tools?
 (This directory will be created, if necessary, to allow the
  installation to be completed).
 (Default: /home/simon/mingw32)? 

 Which directory should I use to create the build tree?
 (This is required during the build process; it should be a directory
  which will be used exclusively for building the cross-compiler, and
  will be created, if necessary; it may be optionally removed after
  successful completion of the build and installation process).
 (Default: /home/simon/tmp/mingw-3.4.5)? 

 Would you like me to delete all build files, when I'm done?
 (Default: YES)? 

 Ok to commence building? (Default: YES)? 
[/bash]

<strong>2. 配置mingw开发环境</strong>
[bash]
mkdir $HOME/bin
cat &gt;$HOME/bin/mingw &lt;&lt; EOF
#!/bin/sh
export CC=/home/simon/mingw32/bin/i386-mingw32-gcc
export RANLIB=/home/simon/mingw32/bin/i386-mingw32-ranlib
export PATH=&quot;/home/simon/mingw32/bin:\$PATH&quot;
exec &quot;\$@&quot;
EOF
chmod u+x $HOME/bin/mingw
[/bash]

<strong>3. 从svn库获取nginx最新代码</strong>
[bash]
svn checkout svn://svn.nginx.org/nginx/trunk
[/bash]
<strong>
4. 编译nginx</strong>
由于有些告警无法消除，所以增加了WATCOMC和_NO_OLDNAMES两个定义：
[bash]
~/bin/mingw ./configure --without-http_rewrite_module --without-http_gzip_module --prefix=. --sbin-path=nginx --with-cc-opt=&quot;-D FD_SETSIZE=4096 -D __WATCOMC__ -D _NO_OLDNAMES&quot; --with-debug --crossbuild=win32
[/bash]

修改objs/Makefile, 将CFLAGS中的-w删除，便于通过编译：
[bash]
CFLAGS =  -pipe  -O -g -D FD_SETSIZE=4096 -D __WATCOMC__ -D _NO_OLDNAMES
[/bash]

从Windows SDK中拷贝advapi32.lib ws2_32.lib两个文件到trunk目录下。如果没有安装visual studio，可以<a href="http://www.microsoft.com/download/en/details.aspx?displaylang=en&id=3138">从msdn上下载Windows SDK</a>。选择安装里面的include和lib就可以了，大约有200MB。

执行make，nginx会在objs目录下生成，可以看到是Win32程序。
[bash]
$ file objs/nginx 
objs/nginx: PE32 executable for MS Windows (console) Intel 80386 32-bit
[/bash]

<strong>5. 运行</strong>
将nginx和conf目录拷贝到windows机器，执行nginx即可。
用ab测试，性能看起来还不错。作为一个只有1.9M的绿色版web服务器，运行之后两个进程大约只占5M内存，真是精巧无比。如果去掉-g编译选项，性能还会更好。
[bash]
Server Software:        nginx/1.0.5
Server Hostname:        192.168.194.93
Server Port:            80

Document Path:          /
Document Length:        18 bytes

Concurrency Level:      100
Time taken for tests:   16.503225 seconds
Complete requests:      5000
Failed requests:        0
Write errors:           0
Total transferred:      1135000 bytes
HTML transferred:       90000 bytes
Requests per second:    302.97 [#/sec] (mean)
Time per request:       330.065 [ms] (mean)
Time per request:       3.301 [ms] (mean, across all concurrent requests)
Transfer rate:          67.14 [Kbytes/sec] received

Connection Times (ms)
              min  mean[+/-sd] median   max
Connect:        0    1   5.7      0      53
Processing:    33  325  29.2    326     398
Waiting:       20  291  28.2    293     350
Total:         83  326  25.0    327     401
[/bash]

<strong>6. 关于pcre库</strong>
rewrite模块需要<a href="http://sourceforge.net/projects/pcre/files/pcre/8.12/pcre-8.12.tar.gz/download">pcre</a>库，可以通过下列方式编译安装：
[bash]
~/bin/mingw ./configure --host=i386-mingw32
~/bin/mingw make
DESTDIR=$HOME/mingw32 make install
[/bash]
但是通过mingw编译安装之后，无法链接成功，问题待解决:
[bash]
	objs/src/http/modules/ngx_http_fastcgi_module.o \
	objs/src/http/modules/ngx_http_uwsgi_module.o \
	objs/src/http/modules/ngx_http_scgi_module.o \
	objs/src/http/modules/ngx_http_memcached_module.o \
	objs/src/http/modules/ngx_http_empty_gif_module.o \
	objs/src/http/modules/ngx_http_browser_module.o \
	objs/src/http/modules/ngx_http_upstream_ip_hash_module.o \
	objs/ngx_modules.o \
	advapi32.lib ws2_32.lib /home/simon/mingw32/usr/lib/libpcre.a
objs/src/core/ngx_regex.o: In function `ngx_regex_init':
/home/simon/work/nginx-svn/trunk/src/core/ngx_regex.c:21: undefined reference to `__imp__pcre_malloc'
/home/simon/work/nginx-svn/trunk/src/core/ngx_regex.c:22: undefined reference to `__imp__pcre_free'
objs/src/core/ngx_regex.o: In function `ngx_regex_compile':
/home/simon/work/nginx-svn/trunk/src/core/ngx_regex.c:72: undefined reference to `__imp__pcre_compile'
/home/simon/work/nginx-svn/trunk/src/core/ngx_regex.c:97: undefined reference to `__imp__pcre_fullinfo'
/home/simon/work/nginx-svn/trunk/src/core/ngx_regex.c:107: undefined reference to `__imp__pcre_fullinfo'
/home/simon/work/nginx-svn/trunk/src/core/ngx_regex.c:117: undefined reference to `__imp__pcre_fullinfo'
/home/simon/work/nginx-svn/trunk/src/core/ngx_regex.c:123: undefined reference to `__imp__pcre_fullinfo'
objs/src/core/ngx_regex.o: In function `ngx_regex_capture_count':
/home/simon/work/nginx-svn/trunk/src/core/ngx_regex.c:146: undefined reference to `__imp__pcre_fullinfo'
objs/src/core/ngx_regex.o: In function `ngx_regex_exec_array':
/home/simon/work/nginx-svn/trunk/src/core/ngx_regex.c:167: undefined reference to `__imp__pcre_exec'
objs/src/http/ngx_http_variables.o: In function `ngx_http_regex_exec':
/home/simon/work/nginx-svn/trunk/src/http/ngx_http_variables.c:1831: undefined reference to `__imp__pcre_exec'
objs/src/http/modules/ngx_http_ssi_filter_module.o: In function `ngx_http_ssi_if':
/home/simon/work/nginx-svn/trunk/src/http/modules/ngx_http_ssi_filter_module.c:2472: undefined reference to `__imp__pcre_exec'
objs/src/http/modules/ngx_http_fastcgi_module.o: In function `ngx_http_fastcgi_split':
/home/simon/work/nginx-svn/trunk/src/http/modules/ngx_http_fastcgi_module.c:2561: undefined reference to `__imp__pcre_exec'
collect2: ld returned 1 exit status
make[1]: *** [objs/nginx] 错误 1
make[1]:正在离开目录 `/home/simon/work/nginx-svn/trunk'
make: *** [build] 错误 2
[/bash]
