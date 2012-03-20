--- 
wordpress_id: 112
layout: post
title: !binary |
  bmFnaW9z5a6J6KOF5omL6K6w77yI5LqM77yJ

excerpt: !binary |
  5ZyoPGEgaHJlZj0iaHR0cDovL2Jsb2cuNTl0cmlwLmNvbS9hcmNoaXZlcy8x
  MDciPm5hZ2lvc+WuieijheaJi+iusO+8iOS4gO+8iTwvYT7kuK3lt7Lnu4/l
  ronoo4Xlpb3kuoZuYWdpb3PlubPlj7DvvIzlubbkuJTphY3nva7kuobln7rm
  nKznmoTmnI3liqHvvIznjrDlnKjnu6fnu63lronoo4VwbnDmj5Lku7bku6Xn
  nIvliLDlj6/niLHnmoTmgKfog73lm77lvaLjgII=

date: 2009-06-21 08:12:32 +08:00
wordpress_url: http://blog.59trip.com/?p=112
---
在<a href="http://blog.59trip.com/archives/107">nagios安装手记（一）</a>中已经安装好了nagios平台，并且配置了基本的服务，现在继续安装pnp插件以看到可爱的性能图形。

1. 安装pnp
<pre class=php name=code>./configure --prefix=/usr/local/nm/nagios --with-nagios-user=nm --with-nagios-group=nm --datarootdir=/usr/local/nm/nagios/share/pnp --with-perfdata-dir=/usr/local/nm/nagios/share/perfdata/
make all
make install

# mkdir /usr/local/nm/nagios/share/perfdata
# chown nm:nm /usr/local/nm/nagios/share/perfdata</pre>
<!--more-->
2. 修改nagios配置，生成性能统计数据
<pre class=php name=code># vi nagios/etc/nagios.cfg
process_performance_data=1          //修改为1
service_perfdata_command=process-service-perfdata  //默认此句被注释掉了

# vi nagios/etc/objects/localhost.cfg
define host{
.....
        alias                   localhost
        process_perf_data 1        //增加此句
        address                 127.0.0.1
        }

# vi nagios/etc/objects/commands.cfg
#define command{    //将这个command替换为pnp的command
#       command_name    process-service-perfdata
#       command_line    /usr/bin/printf "%b" "$LASTSERVICECHECK$\t$HOSTNAME$\t$SERVICEDESC
$\t$SERVICESTATE$\t$SERVICEATTEMPT$\t$SERVICESTATETYPE$\t$SERVICEEXECUTIONTIME$\t$SERVICEL
ATENCY$\t$SERVICEOUTPUT$\t$SERVICEPERFDATA$\n" >> /usr/local/NSP/nagios/var/service-perfda
ta.out
#       }

define command{
        command_name process-service-perfdata
        command_line /usr/local/NSP/nagios/libexec/process_perfdata.pl
}</pre>

3. 访问pnp的地址http://site/nagios/pnp，如果正常则会显示所监控服务的性能图形，如果异常会显示debug信息。
如果nagios上显示数据正确，而图形显示不正确，可以试试删除nagios/share/perfdata目录下的对应hostname的目录，然后重启nagios。

