--- 
wordpress_id: 115
layout: post
title: !binary |
  bmFnaW9z5a6J6KOF5omL6K6w77yI5LiJ77yJ

excerpt: !binary |
  5YaN5p2l5LuL57uN5Lik5Liq5pyJ55So55qE5o+S5Lu244CC5L+66KOFbmFn
  aW9z6aaW5YWI5bCx5piv5Li65LqG55uR5o6n5pyN5Yqh5Zmo55qE572R57uc
  5rWB6YeP77yM5p+l5LqG5LiA5LiL77yMbmFnaW9z5a6Y5pa55pyJ5LiqcGVy
  bOWGmeeahOaPkuS7tmNoZWNrX3RyYWZmaWPjgILotYTmlpnlvojlsJHvvIzo
  o4XkuIrkuYvlkI5uYWdpb3Plj6/ku6XnnIvliLDnvZHnu5zmtYHph4/mlbDm
  ja7vvIzkvYbmmK9wbnDml6Dms5XmmL7npLrlm77lvaLvvIzmsqHmnInnu6fn
  u63lrprkvY3pl67popjjgILlho3mib7kuobkuIDkuKo8YSBocmVmPSJodHRw
  Oi8vd3d3Lml0bm1zLm5ldC9kaXNjdXovdmlld3RocmVhZC5waHA/dGlkPTc2
  NyZleHRyYT1wYWdlRDEmcGFnZT0xIj7lm73kurrlhpnnmoRjaGVja190cmFm
  ZmljLnNo6ISa5pysPC9hPu+8jHBucOiDveato+W4uOaYvuekuu+8jOW+iOWl
  veW+iOW8uuWkp+OAgg==

date: 2009-06-22 08:46:21 +08:00
wordpress_url: http://blog.59trip.com/?p=115
---
再来介绍两个有用的插件。俺装nagios首先就是为了监控服务器的网络流量，查了一下，nagios官方有个perl写的插件check_traffic。资料很少，装上之后nagios可以看到网络流量数据，但是pnp无法显示图形，没有继续定位问题。再找了一个<a href="http://www.itnms.net/discuz/viewthread.php?tid=767&extra=pageD1&page=1">国人写的check_traffic.sh脚本</a>，pnp能正常显示，很好很强大。
<!--more-->
另一个是nagios扩展：<a href="http://sourceforge.net/project/showfiles.php?group_id=26589">NRPE</a>，远程监控客户端的服务状态，有了这个之后，只需在网络中安装一个nagios平台，在被监控主机上安装NRPE，就能远程完成所有的监控功能。

<strong>一、check_traffic.sh脚本安装</strong>
1. 拷贝check_traffic.sh到目录nagios/libexec

2.执行命令获取需监控的网卡id
<pre class=php name=code># nagios/libexec/check_traffic.sh -V 2c -C public -H localhost -L
List Interface for host localhost.
Interface index 1 orresponding to  lo
Interface index 2 orresponding to  eth0</pre>
我们监控的是eth0，其id为2

3. 增加网卡监控配置
<pre class=php name=code># vi nagios/etc/object/localhost.cfg
define host{
        use                     linux-server        
        host_name               localhost
        alias                   localhost
        process_perf_data 1
        address                 127.0.0.1
        }
define service{
        use                             local-service       
        host_name                       localhost           //host需要定义
        service_description             Traffic_eth0
        check_command                   check_traffic_sh!2!12,30!15,35  //第一个参数2为eth0的id
        notifications_enabled           0
        normal_check_interval           6
        }
# vi nagios/etc/object/commands.cfg
define command{
        command_name    check_traffic_sh
        command_line    $USER1$/check_traffic.sh  -V 2c -C public -H $HOSTADDRESS$ -I $ARG1$ -w $ARG2$ -c $ARG3$ -K -B
        }</pre>

4. 重启nagios进程

<strong>二、安装NRPE</strong>
<strong>平台部分安装</strong>
1. 编译安装
<pre class=php name=code># ./configure --prefix=/usr/local/nm/nagios --with-nagios-user=nm --with-nagios-group=nm --with-nrpe-user=nm --with-nrpe-group=nm
# make all
# make install-plugin
# make install-daemon
# make install-daemon-config</pre>

2. 增加配置, 监控192.168.194.110上的load情况
<pre class=php name=code># vi nagios/etc/object/localhost.cfg
define service{
        use                             local-service
        host_name                       192.168.194.110
        service_description             110 Current Load
        check_command                   check_nrpe!check_load
        }
# vi nagios/etc/object/commands.cfg
define command{
        command_name check_nrpe
        command_line $USER1$/check_nrpe -H $HOSTADDRESS$ -c $ARG1$
}</pre>

<strong>被监控主机部分安装</strong>
1. 被监控主机只需要安装nagios-plugin和nrpe，我们只需要把平台上的nagios整个目录打包拷贝过来即可。

2. 修改nrpe配置，允许nagios平台访问
<pre class=php name=code># vi nagios/etc/nrpe.cfg
allowed_hosts=192.168.194.111    //192.168.194.111为平台ip</pre>

3. 启动nrpe服务进程
<pre class=php name=code># nagios/bin/nrpe -c nagios/etc/nrpe.cfg -d</pre>

4. 回到平台上，检测nrpe服务是否可以访问
<pre class=php name=code># nagios/libexec/check_nrpe -H 192.168.194.110
NRPE v2.12       //正确结果</pre>

5. 如果返回“CHECK_NRPE: Error - Could not complete SSL handshake”，可能有以下几种情况：
<ul>
	<li>a. 平台与主机之间nrpe版本不匹配	</li>
	<li>b. 确认nrpe的服务和检测程序的SSL是否开启</li>
	<li>c. 确认nrpe.cfg可以被nrpe的服务进程所读取，权限是否正确</li>
	<li>d. 伪随机设备文件是否可读（这个问题可能特定平台才有，如sun上面）</li>
	<li>e. 如果nrpe由xinetd启动，要看看xinetd的配置only_from 是否配置为平台的ip</li>
</ul>


6. 重启平台的nagios，访问页面就能看到远程主机的监控结果了。
