--- 
layout: post
title: !binary |
  ZmFzdGNnaSBwaHAtY2dp6Ieq5Yqo6YCA5Ye655qE6Zeu6aKY

excerpt: !binary |
  5aaC5p6c5L2/55SoZmFzdGNnaeeahOaWueW8j+WQr+WKqHBocO+8jHBocC1j
  Z2nov5vnqIvlnKjov5DooYzkuIDmrrXml7bpl7TkuYvlkI7kvJroh6rliqjp
  gIDlh7rvvIznhLblkI7niLbov5vnqIvlho3mi4notbfkuIDkuKrmlrDnmoRw
  aHAtY2dp5o+Q5L6b5pyN5Yqh44CCDQoNCjxzdHJvbmc+bGlnaHR0cGTniYjm
  nKzlpoLkuLoxLjQ8L3N0cm9uZz7vvIxsaWdodHRwZOaPkOS+m+S6huS4gOS4
  qumFjee9rumhueaMh+WumnBocC1jZ2nnmoTpgIDlh7rmnaHku7Y6IFBIUF9G
  Q0dJX01BWF9SRVFVRVNUUywg5oyH5a6acGhwLWNnaeWcqOWkhOeQhuWkmuWw
  keS4quivt+axguS5i+WQjumAgOWHuuacjeWKoeOAgg0KPHByZT4NCmZhc3Rj
  Z2kuc2VydmVyID0gKCAiLnBocCIgPT4NCiAgKCggInNvY2tldCIgPT4gIi90
  bXAvcGhwLWZhc3RjZ2kuc29ja2V0IiwNCiAgICAgImJpbi1wYXRoIiA9PiAi
  L3Vzci9sb2NhbC9iaW4vcGhwIiwNCiAgICAgImJpbi1lbnZpcm9ubWVudCIg
  PT4gKCANCiAgICAgICAiUEhQX0ZDR0lfQ0hJTERSRU4iID0+ICIxNiIsDQog
  ICAgICAgIlBIUF9GQ0dJX01BWF9SRVFVRVNUUyIgPT4gIjEwMDAwIiANCiAg
  ICAgKQ0KICApKQ0KKTwvcHJlPg==

date: 2009-08-13 17:23:24 +08:00
---
如果使用fastcgi的方式启动php，php-cgi进程在运行一段时间之后会自动退出，然后父进程再拉起一个新的php-cgi提供服务。

<strong>lighttpd版本如为1.4</strong>，lighttpd提供了一个配置项指定php-cgi的退出条件: PHP_FCGI_MAX_REQUESTS, 指定php-cgi在处理多少个请求之后退出服务。
<pre>
fastcgi.server = ( ".php" =>
  (( "socket" => "/tmp/php-fastcgi.socket",
     "bin-path" => "/usr/local/bin/php",
     "bin-environment" => ( 
       "PHP_FCGI_CHILDREN" => "16",
       "PHP_FCGI_MAX_REQUESTS" => "10000" 
     )
  ))
)</pre>

<strong>1.5的lighttpd里</strong>，由于spawn-fcgi被剥离出来，所以这个参数的指定就由spawn-fcgi完成，但spawn-fcgi实际上没有传递该参数给php-cgi进程，所以php-cgi使用PHP_FCGI_MAX_REQUESTS的默认值500。
<!--more-->
spawn-fcgi只提供了php-cgi子进程个数的指定：
<pre class=c name=code>
    if (child_count >= 0) {
    	snprintf(cgi_childs, sizeof(cgi_childs), "PHP_FCGI_CHILDREN=%d", child_count);
    	putenv(cgi_childs);
    }
</pre>

如果想指定PHP_FCGI_MAX_REQUESTS，可以模仿上面的代码修改spawn-fcgi.c，将PHP_FCGI_MAX_REQUESTS传递给php-cgi。

一些网站提到php-cgi进程数不宜过大，4G内存才能开到20个进程，但是据我观察1G内存开36个php-cgi是没问题的。
