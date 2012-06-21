--- 
layout: post
title: !binary |
  bmFnaW9z5a6J6KOF5omL6K6w77yI5LiA77yJ

excerpt: !binary |
  5LiK5paHPGEgaHJlZj0iaHR0cDovL2Jsb2cuNTl0cmlwLmNvbS9hcmNoaXZl
  cy85NCI+44CK572R57uc566h55CG5bmz5Y+wbmFnaW9z44CLPC9hPuaPkOWI
  sOeahOWNmuWuouW3sue7j+aYr+W+iOWlveeahG5hZ2lvc+WtpuS5oOadkOaW
  meS6hu+8jOWFtuWunuayoeW/heimgeWGjeWGmeaAjuS5iOWuieijhW5hZ2lv
  c++8jOS9humJtOS6jue7meiHquW3seeVmeS4gOS6m+WuieijheiusOW9le+8
  jOi/mOaYr+WGs+WumuWGmeWGmeOAgg0K

date: 2009-06-19 09:43:18 +08:00
---
上文<a href="http://blog.59trip.com/archives/94">《网络管理平台nagios》</a>提到的博客已经是很好的nagios学习材料了，其实没必要再写怎么安装nagios，但鉴于给自己留一些安装记录，还是决定写写。

0. 安装前提
需准备好http服务器，由于已经有了lighttpd做服务器，就顺便使用lighttpd，不使用apache。一般情况下，nagios都是配合apache使用。
pnp图形显示，需要php和gd库支持。
<!--more-->
1. 获取所需要的软件包
nagios-3.0.6    //nagios平台包
nagios-plugins-1.4.13    //nagios监控插件包，完成具体的监控工作
pnp-0.4.14      //性能数据汇总，图形显示插件

2. 安装nagios
我们系统上统一使用nm用户来做网管操作，所以需要加很多配置参数。
<pre class=php name=code>./configure --with-command-group=nm --with-nagios-user=nm --with-nagios-group=nm --with-command-user=nm --prefix=/usr/local/nm/nagios
make all 
make install 
make install-config 
make install-init </pre>

3. 安装nagios-plugin
<pre class=php name=code>./configure --with-nagios-user=nm --with-nagios-group=nm --prefix=/usr/local/nm/nagios
make install </pre>

4. 修改lighttpd配置，nagios默认是需要httpd支持鉴权的，由于没搞定lighttpd的mod_auth，所以就给注释掉相关的配置。
server.modules              = (   增加
<pre class=php name=code>                               "mod_rewrite",
                               "mod_alias",
                               "mod_cgi",</pre>
增加
<pre class=php name=code>alias.url =     (
                "/nagios/cgi-bin" => "/usr/local/nm/nagios/sbin",
                "/nagios" => "/usr/local/nm/nagios/share"
                )
$HTTP["url"] =~ "^/nagios/cgi-bin" {
        cgi.assign = ( "" => "" )
}</pre>

5. 修改nagios配置, 取消鉴权
<pre class=php name=code># vi nagios/etc/cgi.cfg
    use_authentication=0</pre>

6. 检查nagios配置文件，默认情况下nagios会检查localhost的几个服务，可以根据需要修改etc/object下面的localhost.cfg
<pre class=php name=code>/usr/local/nm/nagios/bin/nagios -v /usr/local/nm/nagios/etc/nagios.cfg</pre>

7. 如果没有问题，就可以启动nagios进程了
<pre class=php name=code>/usr/local/nm/nagios/bin/nagios -d /usr/local/nm/nagios/etc/nagios.cfg</pre>

8. 修改nagios监控服务的时间间隔（采样周期）
<pre class=php name=code># vi nagios/etc/nagios.cfg
interval_length=10    //该配置项指示了间隔时间长度
# vi nagios/etc/objects/localhost.cfg
define service{
......
        normal_check_interval           6 //指示该服务的采样周期为6个间隔时间，不配置则默认为5
        }</pre>
本例子中的服务监控间隔时间为6*10秒
