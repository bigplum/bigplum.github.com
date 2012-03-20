--- 
wordpress_id: 94
layout: post
title: !binary |
  572R57uc566h55CG5bmz5Y+wbmFnaW9z

excerpt: !binary |
  6L+Z5Lik5aSp5Zyo56CU56m25oCO5LmI566h55CG5YWs5Y+455qE5pyN5Yqh
  5Zmo77yM55yL5LqGbXJ0Z++8jGNhY3Rp562J6L2v5Lu277yM5pyA57uI6L+Y
  5piv6YCJ5LqGbmFnaW9z44CCDQpuYWdpb3PkvZzkuLrlvIDmupDnmoTkvIHk
  uJrnuqfnvZHnu5znrqHnkIblubPlj7DvvIzog73lpJ/mu6HotrPlpKfpg6jl
  iIbkuK3lsI/lnovkvIHkuJrnmoTnvZHnu5znrqHnkIbpnIDmsYLjgIJtcnRn
  44CBY2FjdGnomb3nhLbkuZ/mnInlvojlvLrlpKfnmoTnrqHnkIbjgIHnm5Hm
  jqflip/og73vvIzljbTnvLrlsJHkuoblvojph43opoHnmoTlkYrorabmnLrl
  iLbvvIzogIzlkYrorabljbTmmK/kvIHkuJrnuqfnvZHnrqHnmoTph43opoHl
  ip/og73vvJvnibnliKvlnKjnlLXkv6Hns7vnu5/kuK3vvIzml6nmnJ/nmoTn
  vZHnrqHlip/og73lvojoloTlvLHvvIzkvYbmmK/lkYrorabmmK/lv4XkuI3l
  j6/lsJHnmoTjgII=

date: 2009-06-15 21:30:25 +08:00
wordpress_url: http://blog.59trip.com/?p=94
---
这两天在研究怎么管理公司的服务器，看了mrtg，cacti等软件，最终还是选了nagios。
nagios作为开源的企业级网络管理平台，能够满足大部分中小型企业的网络管理需求。mrtg、cacti虽然也有很强大的管理、监控功能，却缺少了很重要的告警机制，而告警却是企业级网管的重要功能；特别在电信系统中，早期的网管功能很薄弱，但是告警是必不可少的。<!--more-->

nagios和mrtg、cacti还有一个区别就是，nagios只是一个平台，提供了监控、数据收集、告警等机制，但其自身不负责实现这些具体功能。这些功能交给了插件完成，同时，如果想得到一段时间内的变化趋势图，例如要知道网络流量的变化，就需要通过pnp之类的另外的软件来完成。

关于nagios的安装、使用，这个博客有很详尽的说明，写的相当不错，推荐参考：<a href="http://blog.chinaunix.net/u/28387/showart_360530.html">http://blog.chinaunix.net/u/28387/showart_360530.html</a>
