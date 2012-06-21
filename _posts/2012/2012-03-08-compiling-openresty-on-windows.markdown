--- 
layout: post
title: !binary |
  d2luZG93c+S4i+eUqG1pbmdX57yW6K+Rb3BlbnJlc3R5

date: 2012-03-08 21:12:01 +08:00
category: 
- dev
tags: 
- nginx 
---
摘要：通过暴力修改代码，除了zlib/gzip-module，其他模块和luajit都编译成功，但是执行会提示非法地址访问，仅能看看版本号。问题应该在ssl模块，水平有限，抓不到bug了。

如果仅包含pcre和rewirte模块，单独编译nginx代码，可以正常运行。编译pcre时如果提示undefined reference to `__imp__pcre_malloc'，可以改用libpcre.dll.a来链接解决。

<strong>0. make lua failed, so we use luajit</strong>

    liblua.a(ldo.o):ldo.c:(.text+0x28a): undefined reference to `_longjmp'
    liblua.a(loslib.o):loslib.c:(.text+0x62d): undefined reference to `mkstemp'

<strong>1. Install openssl</strong>

    mingw-get install msys-libopenssl
    mingw-get install mingw32-libz
    mingw-get install msys-libtermcap

If lib readline is required, could be downloaded from:
<a href="http://sourceforge.net/projects/cbadvanced/files/Msys Specific/">http://sourceforge.net/projects/cbadvanced/files/Msys Specific/</a>

<strong>2. Modify ngx_openresty-1.0.11.21/configure to copy luajit-5.1.dll</strong>

    shell "${make} install$extra_opts PREFIX=$luajit_prefix DESTDIR=$luajit_root", $dry_run;
    + shell "cp src/lua51.dll $luajit_root/$luajit_prefix/lib/luajit-5.1.dll";
    + shell "cp src/lua51.dll $luajit_prefix/lib/luajit-5.1.dll";
    push @make_cmds, "cd $root_dir/build/$luajit_src && " . "\$(MAKE)ll$extra_opts PREFIX=$luajit_prefix";
    
<strong>3. Download pcre source and install</strong>

    pcre-8.30$ ./configure
    checking for a BSD-compatible install... /bin/install -c
    checking whether build environment is sane... yes
    checking for a thread-safe mkdir -p... /bin/mkdir -p
    checking for gawk... gawk
    checking whether make sets $(MAKE)... yes

<strong>4. Download and copy nginx trunk code from svn into bundle\nginx-1.0.11</strong>

and run configure

    ./configure --with-luajit --with-debug --with-pcre=/usr/local/include 
    --with-zlib=/usr/local --with-openssl=/usr --with-cc-opt="-D FD_SETSIZE=4096 -D 
    __NO_MINGW_LFS -D __WATCOMC__"  --without-http_gzip_module

<strong>5. Adding luajit-5.1.dll for linking</strong>

	build\lua-cjson-1.0.3\Makefile:
	cjson.so: lua_cjson.o strbuf.o
		$(CC) $(LDFLAGS) -o $@ $^ ../luajit-root/usr/local/openresty/luajit/lib/luajit-5.1.dll 
	
	build\lua-redis-parser-0.09rc7\Makefile:
	parser.so: redis-parser.o
		$(CC) $(LDFLAGS) -o $@ $^ ../luajit-root/usr/local/openresty/luajit/lib/luajit-5.1.dll
	
	build\lua-rds-parser-0.04\Makefile:
	parser.so: src/rds_parser.o
		$(CC) $(LDFLAGS) -o $@ $^ ../luajit-root/usr/local/openresty/luajit/lib/luajit-5.1.dll

<strong>6. Replacing u_char with char</strong>

    build\lua-rds-parser-0.04\src\rds_parser.c
    build\lua-rds-parser-0.04\src\rds_parser.h

<strong>7. Modification in build\nginx-1.0.11\objs\Makefile</strong>

1. Modify libpcre path
2. Modify openssl path, for ssl.h existing and delete :

        /usr/include/openssl/ssl.h:	objs/Makefile
            	cd /usr \
            	&& $(MAKE) clean \
            	&& ./config --prefix=/usr/include/openssl no-shared  no-threads \
            	&& $(MAKE) \
            	&& $(MAKE) install LIBDIR=lib

3. Change /usr/local/lib/libpcre.a to /usr/local/lib/libpcre.dll.a ...
 
        objs/ngx_modules.o \
        	-Wl,-rpath,/usr/local/openresty/luajit/lib -Wl,-E advapi32.lib ws2_32.lib -L/c/work
        /ngx_openresty-1.0.11.21/build/luajit-root/usr/local/openresty/luajit/lib -lluajit-5.1 -lm 
        /usr/local/lib/libpcre.dll.a /usr/lib/libssl.dll.a /usr/lib/libcrypto.dll.a

4. Search and delete keepalive module, for it's already put into trunk:

        objs/addon/upstream-keepalive-nginx-module-0.7/ngx_http_upstream_keepalive_module.o \


<strong>8. Modify those files </strong>

    build\ngx_lua-0.5.0rc17\src\ngx_http_lua_regex.c
    build\ngx_lua-0.5.0rc17\src\ngx_http_lua_shdict.h
    build\rds-json-nginx-module-0.12rc7\src\ngx_http_rds_utils.h
    build\rds-csv-nginx-module-0.05rc1\src\ngx_http_rds_utils.h

add stdint.h to support uint8_t:

    #include <stdint.h>


<strong>9. Done</strong>

Now make, if success try to run build\nginx-1.0.11\objs\nginx.exe. Good luck.

    ./nginx.exe -V
    nginx version: nginx/1.1.17
    TLS SNI support enabled
    configure arguments: --prefix=/usr/local/openresty/nginx --with-debug --with-cc-opt='-O0 -D FD_SETSIZE=4096 -D __NO_MINGW_LFS -D __WATCOMC__' --add-module=../ngx_devel_kit-0.2.17 --add-module=../echo-nginx-module-0.38rc1 --add-module=../xss-nginx-module-0.03rc9 --add-module=../ngx_coolkit-0.2rc1 --add-module=../set-misc-nginx-module-0.22rc5 --add-module=../form-input-nginx-module-0.07rc5 --add-module=../encrypted-session-nginx-module-0.02 --add-module=../ngx_lua-0.5.0rc17 --add-module=../headers-more-nginx-module-0.17rc1 --add-module=../srcache-nginx-module-0.13rc3 --add-module=../array-var-nginx-module-0.03rc1 --add-module=../memc-nginx-module-0.13rc3 --add-module=../redis2-nginx-module-0.08rc4 --add-module=../upstream-keepalive-nginx-module-0.7 --add-module=../auth-request-nginx-module-0.2 --add-module=../rds-json-nginx-module-0.12rc7 --add-module=../rds-csv-nginx-module-0.05rc1 --with-ld-opt=-Wl,-rpath,/usr/local/openresty/luajit/lib --with-pcre=/usr/local/include --with-zlib=/usr/local --with-openssl=/usr --without-http_gzip_module --with-http_ssl_module
