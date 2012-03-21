--- 
wordpress_id: 921
layout: post
title: !binary |
  5L2/55SoemFiYml4566h55CG572R57uc

date: 2010-12-02 16:30:28 +08:00
wordpress_url: http://pipa.tk/?p=921
---
工作中需要监控很多分布到不同机房的机器，最主要是要监控网络流量，由于机房内部都是内网地址，所以需要一个分布式的监控解决方案。一开始只用nagios+pnp简单采集数据，后来试用了一下cacti，配置上要简单多了，而且图像也好看点，但是不支持分布式监控。于是想到用zabbix，zabbix比nagios简单，比cacti功能强大，配置好zabbix_proxy之后，添加节点就相当简单了，可以在中心监控服务器上进行所有操作。并且zabbix还支持聚合图像，提供了定制页面的功能。

<strong>1. 定制模板</strong>
默认的模板有太多不需要的检测项，需要精简一下。
Configuration ->  Templates 选择 Template_Linux ，点击下方的 Full clone （注：1.8.2之前的版本这个功能有问题，需要升级）。现在重新生成了一个模板，点击该模板的 Items 删掉几乎所有的检测项，留下 CPU/MEM/Out/Incoming 等重要检测项。

zabbix的默认检测方式采用agent，我们的服务器都开了snmpd，所以就不用这个，改用snmp。以网卡out流量统计为例，配置如下：
<a href="/assets/uploads/2010/12/items-add.jpg"><img src="/assets/uploads/2010/12/items-add.jpg" alt="items-add" title="items-add" width="596" height="625" class="alignnone size-full wp-image-923" /></a>
其中 SNMP OID 和 SNMP community 需要配置正确，Description 的 $1 为下面 key 中的第一个参数。

配置完所有的检测项：
<a href="/assets/uploads/2010/12/items-conf.jpg"><img src="/assets/uploads/2010/12/items-conf-1024x104.jpg" alt="items-conf" title="items-conf" width="1024" height="104" class="alignnone size-large wp-image-924" /></a>

<strong>2. 添加 Host</strong>
Configuration ->  Templates -> Create Host
比较简单，填写节点的name，group，IP，等信息，如果通过zabbix_proxy分布式部署，选择相应的proxy。

<strong>3. 编辑 Screen</strong>
Configuration ->  Screens -> Create Screen
填写页面的行列数：
<a href="/assets/uploads/2010/12/screen-init.png"><img src="/assets/uploads/2010/12/screen-init.png" alt="screen-init" title="screen-init" width="652" height="137" class="alignnone size-full wp-image-926" /></a>

点击”change“ 就能将需要显示的 graph 添加到这个页面中。
<a href="/assets/uploads/2010/12/screen-add.png"><img src="/assets/uploads/2010/12/screen-add.png" alt="screen-add" title="screen-add" width="781" height="464" class="alignnone size-full wp-image-927" /></a>

大功告成，回到 Monitoring -> Screens 页面，就能看到所需要的图表集中到一个页面显示了。
