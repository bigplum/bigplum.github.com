--- 
layout: post
title: 使用pt-tcp-model分析tcp性能
date: 2013-01-23 18:26:24 +08:00
category:
- dev
tags:
- tcp
---

[http://www.percona.com/doc/percona-toolkit/2.1/pt-tcp-model.html](pt-tcp-model)可以对tcpdump抓包结果进行进一步分析，例如：识别一个TCP会话的请求和响应包，从中提取会话处理时间。还可以根据多种条件进行数据提取，具体可以参见man page。

下面说明一下如何用pt-tcp-model统计syn响应时间。


首先用tcpdump在服务器上抓取syn包：

    tcpdump -s 384 -i any -nnq -tttt 'tcp port 80 and tcp[tcpflags] & (tcp-syn) != 0 and not net 10.96.2' > port80.txt

内容如下所示：

    2013-01-24 15:44:47.647685 IP 114.112.87.186.51056 > 110.81.29.248.80: tcp 0
    2013-01-24 15:44:47.647812 IP 114.112.87.186.51056 > 110.81.29.248.80: tcp 0
    2013-01-24 15:44:47.647686 IP 110.81.29.248.80 > 114.112.87.186.51056: tcp 0
    2013-01-24 15:44:47.647694 IP 110.81.29.248.80 > 114.112.87.186.51056: tcp 0
    2013-01-24 15:44:47.647695 IP 110.81.29.248.80 > 114.112.87.186.51056: tcp 0
    2013-01-24 15:44:47.648500 IP 119.119.87.20.2309 > 110.81.29.248.80: tcp 0
    2013-01-24 15:44:47.648505 IP 119.119.87.20.2309 > 110.81.29.248.80: tcp 0
    2013-01-24 15:44:47.648533 IP 110.81.29.248.80 > 119.119.87.20.2309: tcp 0
    2013-01-24 15:44:47.648549 IP 110.81.29.248.80 > 119.119.87.20.2309: tcp 0
    2013-01-24 15:44:47.648550 IP 110.81.29.248.80 > 119.119.87.20.2309: tcp 0
    2013-01-24 15:44:47.684610 IP 110.81.29.248.80 > 113.7.84.58.1312: tcp 0
    
用pt-tcp-model提取会话信息：

    pt-tcp-model --watch-server 119.84.79.248:80 port80.txt > packet.txt

结果如下，其中第四列为处理时间：

    308 1359008753.312484 1359008753.312494  0.000010 114.229.139.29:3497
    359 1359008754.248625 1359008754.248632  0.000007 180.140.15.231:4636
    408 1359008755.042251 1359008755.042261  0.000010 182.129.31.231:2677
    416 1359008755.147541 1359008755.147551  0.000010 118.250.220.148:50287

最后可以很容易用awk分析响应时间分布，或者计算平均值：

    awk '{print $4}' packet.txt|sort|uniq -c
    awk '{sum+=$4} END {print sum/FNR}' packet.txt

还可以用gunplot画个分布图：

    awk '{print $4*1000000}' packet.txt|sort -n|uniq -c|awk '{print $2," ",$1}' > resp.time.txt


resp.plot:

    set title "TCP Port 80 packets/sec"
    set xlabel "SYN Resp Time(us)"
    set ylabel "req number"
    set xrange [0:100]
    set datafile separator " "
    
    set style line 1 linecolor rgb "#000000" lw 1
    
    plot 'resp.time.txt' using 1:2 title "request" with line ls 1
    
    set terminal png font "/Library/Fonts/Arial.ttf"  
    set output "resptime.png"
    
    replot

run gunplot:
 
    gnuplot resp.plot

![resptime.png](/assets/uploads/2013/01/resptime.png)

