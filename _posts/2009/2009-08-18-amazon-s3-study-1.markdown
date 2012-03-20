--- 
wordpress_id: 528
layout: post
title: !binary |
  QW1hem9uIFMz5LqR5a2Y5YKo5pyN5Yqh56CU56m277yI5LiA77yJ

excerpt: !binary |
  QW1hem9uIDxhIGhyZWY9Imh0dHA6Ly9hd3MuYW1hem9uLmNvbS9zMy8iPlNp
  bXBsZSBTdG9yYWdlIFNlcnZpY2U8L2E+IChBbWF6b24gUzMp5piv5LqS6IGU
  572R5beo5aS05Lqa6ams6YCKMDblubTmjqjlh7rnmoTlrZjlgqjmnI3liqHv
  vIzlkozmma7pgJrnmoTnvZHnm5jkuI3lkIzvvIxTM+S4u+imgemdouWQkeW8
  gOWPkeiAheOAgg0KDQowLiDnm7jlhbPog4zmma/mioDmnK8NCnR3aXR0ZXLl
  kI7lj7DlrZjlgqjkvb/nlKhTM+eahOacjeWKoe+8jOS4uuaJgOacieeUqOaI
  t+aPkOS+m+WbvueJh+WtmOWCqOOAgg0KUzPkuI3mmK9BbWF6b27kuLrkuobm
  j5DkvpvlrZjlgqjmnI3liqHogIzmnoTlu7rnmoTvvIzogIzmmK/liKnnlKjm
  j5Dkvpvlhbbku5bmnI3liqHnmoTliankvZnotYTmupDmnaXmj5DkvpvmnI3l
  iqHvvIxBbWF6b27ov5jmj5DkvpvkupHorqHnrpfjgIHmlbDmja7lupPnrYnm
  nI3liqHvvIzogIzov5nkupvmnI3liqHmmK/nu4/ov4flhbboh6rmnInkuJrl
  iqHlhYXliIbpqozor4Hov4fnmoTvvIzmiYDku6Xlj6/pnaDmgKflgLzlvpfk
  v6Hku7vjgII=

date: 2009-08-18 11:27:59 +08:00
wordpress_url: http://blog.59trip.com/?p=528
---
Amazon <a href="http://aws.amazon.com/s3/">Simple Storage Service</a> (Amazon S3)是互联网巨头亚马逊06年推出的存储服务，和普通的网盘不同，S3主要面向开发者，是付费的，用多少资源付多少钱。

0. 背景技术
twitter后台存储使用S3的服务，为所有用户提供图片存储。。。
亚马逊是搞电子商务的，为什么会搞起云服务呢？S3不是Amazon为了提供存储服务而构建的，而是利用其他服务的剩余资源来提供存储服务，Amazon还提供云计算、数据库等服务，而这些服务是经过其自有业务充分验证过的，所以可靠性值得信任。
分布式、异步、容错的，与google的分布式文件系统的设计理念类似。
<!--more-->
1. 成本
使用S3服务，需要付出一定的成本，下面是美国使用的价格。按下面的价钱计算，每月使用5G空间，10G流量，大约需付出2.5$的成本，合每年大概200RMB，在国内租个同样水平的虚拟主机价钱大致相当，但是amazon的稳定性、可靠性应该没有哪个国内的主机商比的上，所以成本相对还是可以接受的；

<strong>Storage  存储</strong>
$0.150 per GB – first 50 TB / month of storage used
<strong>Data Transfer  传输</strong>
$0.100 per GB – all data transfer in
$0.170 per GB – first 10 TB / month data transfer out
<strong>Requests   请求</strong>
$0.01 per 1,000 PUT, COPY, POST, or LIST requests
$0.01 per 10,000 GET and all other requests*

和自己建备份环境的成本对比，参考这里：<a href="http://jeremy.zawodny.com/blog/archives/007624.html">http://jeremy.zawodny.com/blog/archives/007624.html</a>

2. 提供的服务
S3只提供存储服务，不提供计算服务，所以不能用来做网站只能用于数据备份、图片外链、文件下载等用途。或者当一个高可靠的网盘使用。
支持上传最大5GB的单个文件。
支持域名绑定，鉴权访问，支持REST和SOAP接口，支持HTTP下载，还支持BT下载。
<strong>但由于Amazon服务器位于国外，所以要当心被GFW和谐。</strong>

3. 可靠性
Amazon的服务条款承诺了提供99.9%的可用时间，还为此提供了信用保证，如果低于3个9的可用性，会提供10%~25%的赔偿。

4. 如何使用
参考这里：<a href="http://www.ibm.com/developerworks/cn/java/j-s3/index.html">http://www.ibm.com/developerworks/cn/java/j-s3/index.html</a>
<a href="http://www.chedong.com/blog/archives/001241.html">http://www.chedong.com/blog/archives/001241.html</a>
