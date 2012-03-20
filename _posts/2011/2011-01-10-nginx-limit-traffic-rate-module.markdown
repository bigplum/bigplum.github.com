--- 
wordpress_id: 965
layout: post
title: !binary |
  bmdpbnjkuIvovb3liqjmgIHpmZDpgJ/mqKHlnZcgTmdpbngtbGltaXQtdHJh
  ZmZpYy1yYXRlLW1vZHVsZQ==

date: 2011-01-10 14:06:35 +08:00
wordpress_url: http://pipa.tk/?p=965
---
nginx自身提供了限制并发连接数和限制单连接速率的功能，可以根据这两个参数，对客户端进行粗略的速度控制。例如，设定每个ip最大5个并发连接，每个连接最大100kBps，那么可以将客户端的最大速率控制在500kBps；但是这样带来一个问题，如果用户使用单线程的下载工具，那么只能达到100kBps的速度，只有使用多线程下载工具才能达到500kBps。

所以就做了一个模块，可以动态的进行限速，针对配置文件中定义的变量给定一个最大速度，所有满足这个变量的连接共享这个最大速度。

    http {
        limit_traffic_rate_zone   rate $remote_addr 32m;   //remote_addr可以替换成request_uri等变量
        
        server {
            location /download/ {
                limit_traffic_rate  rate 20k;
            }
        }
    }

从这里下载：<a href="https://github.com/bigplum/Nginx-limit-traffic-rate-module">https://github.com/bigplum/Nginx-limit-traffic-rate-module</a>
