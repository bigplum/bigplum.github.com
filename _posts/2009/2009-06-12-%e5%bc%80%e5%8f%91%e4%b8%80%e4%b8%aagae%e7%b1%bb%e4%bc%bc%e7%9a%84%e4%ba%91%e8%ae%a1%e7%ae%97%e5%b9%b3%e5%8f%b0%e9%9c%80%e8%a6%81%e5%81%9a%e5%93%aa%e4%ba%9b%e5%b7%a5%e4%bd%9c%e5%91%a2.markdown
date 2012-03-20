--- 
wordpress_id: 91
layout: post
title: !binary |
  5byA5Y+R5LiA5LiqR0FF57G75Ly855qE5LqR6K6h566X5bmz5Y+w6ZyA6KaB
  5YGa5ZOq5Lqb5bel5L2c5ZGiPw==

excerpt: !binary |
  UmVzZWFyY2ggYSBjbG91ZCBjb21wdXRpbmcgcGxhdGZvcm0gbGlrZSBHQUUu
  DQoNCui/memHjOaJgOiusueahOS6keiuoeeul+W5s+WPsOeJueaMh0dBRei/
  meexu++8jGFtYXpvbiBFQzLvvIxJQk3nrYnlhbbku5blhazlj7jnmoTkupHo
  rqHnrpfmqKHlvI/lkoxnb29nbGXnmoTkuI3lpKrkuIDmoLfvvIzlkI7pnaLl
  j6bmloflho3orrLov7DjgII=

date: 2009-06-12 11:51:51 +08:00
wordpress_url: http://blog.59trip.com/?p=91
---
Research a cloud computing platform like GAE.

这里所讲的云计算平台特指GAE这类，amazon EC2，IBM等其他公司的云计算模式和google的不太一样，后面另文再讲述。

<a href="http://code.google.com/intl/zh-CN/appengine/">GAE</a>是google推出的集计算和数据库服务于一体的云计算服务。目前支持python和java语言（运行于sandbox之上，功能有所剪裁），并且可通过GQL存储、操作数据库（GAE提供的数据库和传统的关系型数据库不一样）。用户申请GAE账号之后，通过SDK上传代码，建立自己的网络服务。
<!--more-->
GAE的应用使用appspot.com的二级域名，由于总所周知的原因，appspot.com域名所指向的ip经常无法访问，所以人们就想了很多办法规避这一问题，所以如果国内能有类似的服务就好了，免除大家翻墙之苦。

据说目前已经有克隆GAE的开源代码：<a href="http://AppDrop.com">AppDrop</a>，<a href="http://www.10gen.com/">10Gen</a>，但前者已经无法访问，后者只是一个数据库。还是自力更生吧，研究一个支持php的分布式web服务平台，支持用户注册，开发，调用api，而不用考虑硬件扩展，地域分布，可靠性等问题。

1. 首先我们需要很多很多机器，虽然现在没有，但所有的设计都应该基于大量机器的基础之上，要时刻想着怎么把计算分布到很多很多机器之上。

2. 要有一个php的解释器，提供沙箱功能，能隔离用户应用、计算用户所占用资源，同时裁剪掉底层api，只提供需要的功能。

3. 应用管理，用户上传应用之后，全网都应该能访问到这个应用，将该应用调度到空闲的资源上运算；并且统计应用占用的资源，不能把所有资源都抢光了。

4. 用户管理，这个就不赘述了。

5. 数据库功能可以有两种实现方式，一：采用GAE的方式，用分布式数据库做底层支撑，我们可以用htable等开源产品，在其之上开发SQL接口；二：用mysql等关系数据库提供服务，在前端用mysql proxy等产品做调度，这种方式会相对简单一些。

6. 完成上述工作之后，还需要有个域名来提供应用访问入口。

还有其他基本的工作需要做，负载均衡、数据备份等。

本文只讨论了技术相关的问题，如果要上线运行还有很多其他的非技术问题，例如：ICP许可、内容审查等。当然还有最大的问题：哪个公司能有这么多钱去烧一个？
