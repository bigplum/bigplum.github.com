--- 
wordpress_id: 54
layout: post
title: "\xE5\x8D\x87\xE7\xBA\xA7lighttpd 1.4.X\xE5\x88\xB0lighttpd 1.5"
excerpt: !binary |
  bGlnaHR0cGQgMS415LuOMDblubTliLDnjrDlnKjkuIDnm7Tpg73msqHmnInm
  lL7lh7rkuIDkuKrnqLPlrprnmoTniYjmnKzlh7rmnaXvvIzkuI3nn6XpgZPn
  jrDlnKjnmoTlvIDlj5HogIXmmK/mgI7kuYjorqHliJLnmoTjgIIxLjXmr5Qx
  LjTnmoTlip/og73osozkvLzlj5jljJbkuI3lpJrvvIzmnIDlpKfnmoTlj5jl
  jJbmmK/mlLnlhpnkuoZwcm94eeaooeWdl++8jOWOn+WFiOeahGZhc3RjZ2nm
  qKHlnZfkuZ/ooqtwcm94eeaJgOWPluS7o++8jOS7jjEuNC5Y5Y2H57qn55qE
  6K+d5bCx6ZyA6KaB5YGa5LiA5Lqb5L+u5pS544CCDQoNCjxzdHJvbmc+MS4g
  5LuOc3ZuIGNoZWNrIG91dCAxLjXnmoTmupDku6PnoIE8L3N0cm9uZz4NCnN2
  biBjaGVja291dCBzdm46Ly9zdm4ubGlnaHR0cGQubmV0L2xpZ2h0dHBkL3Ry
  dW5rDQoNCjxzdHJvbmc+Mi4g57yW6K+R5rqQ56CBPC9zdHJvbmc+DQrnvJbo
  r5Hov4fnqIvlj6/ku6Xlj4LogIPmupDnoIHnm67lvZXkuIvnmoRJTlNUQUxM
  LnN2bg==

date: 2009-06-08 16:25:43 +08:00
wordpress_url: http://blog.59trip.com/?p=54
---
lighttpd 1.5从06年到现在一直都没有放出一个稳定的版本出来，不知道现在的开发者是怎么计划的。1.5比1.4的功能貌似变化不多，最大的变化是改写了proxy模块，原先的fastcgi模块也被proxy所取代，从1.4.X升级的话就需要做一些修改。

<strong>1. 从svn check out 1.5的源代码</strong>
svn checkout svn://svn.lighttpd.net/lighttpd/trunk

<strong>2. 编译源码</strong>
编译过程可以参考源码目录下的INSTALL.svn
<code>$ ./autogen.sh
$ ./configure --prefix=/usr/local/light --with-pcre=/usr/local/light 
$ make
$ make install</code>

注：编译时，如果没有glib2-devel库会报错找不到gthread-2.0，需要安装glib2-devel<!--more-->
<code>checking for GTHREAD... configure: error: Package requirements (gthread-2.0 >= 2.4.0) were not met:</code>

<code>No package 'gthread-2.0' found</code>
<code>
Consider adjusting the PKG_CONFIG_PATH environment variable if you
installed software in a non-standard prefix.</code>

<code>Alternatively, you may set the environment variables GTHREAD_CFLAGS
and GTHREAD_LIBS to avoid the need to call pkg-config.
See the pkg-config man page for more details.</code>

<strong>3. 修改配置文件</strong>
vi /usr/local/light/etc/lighttpd.conf
删除server.modules中      "mod_fastcgi",
                               "mod_proxy",
的配置，增加模块 "mod_proxy_core", "mod_proxy_backend_fastcgi" ：
<code>server.modules += ( "mod_proxy_core", "mod_proxy_backend_fastcgi" )</code>
增加php的fastcgi配置
<code>$HTTP["url"] =~ "\.php$" {
        proxy-core.balancer = "round-robin"
        proxy-core.allow-x-sendfile = "enable"
        proxy-core.check-local = "enable"
        proxy-core.protocol = "fastcgi"
        proxy-core.backends = ( "unix:/tmp/php-fastcgi.sock" )
        proxy-core.max-pool-size = 16
}</code>

<strong>4. 启动fast-cgi进程</strong>
lighttpd 1.4中可以自动拉起fast-cgi进程，但1.5版本中改成了spawnfcgi方式，需要单独拉起。使用如下命令：
<code># /usr/local/light/bin/spawn-fcgi -s /tmp/php-fastcgi.sock -f /usr/local/light/bin/php-cgi -u lighttpd -g lighttpd -C 5 -P /var/run/spawn-fcgi.pid</code>

注： 要保证/tmp/php-fastcgi.sock文件是lighttpd 可读写的

5. 启动lighttpd
<code>/usr/local/light/sbin/lighttpd -f /usr/local/light/etc/lighttpd.conf</code>

注： proxy-core.check-local = "enable" 配置会导致下面错误，注释掉就没问题了。
<code>2009-06-08 15:39:46 (error) (configfile-glue.c:169) found deprecated key in 'proxy-core.check-local' = 'use $PHYSICAL["existing-path"] =~ ... { ... } instead'
2009-06-08 15:39:46 (server.c:1507) Configuration contains deprecated keys. Going down.</code>
