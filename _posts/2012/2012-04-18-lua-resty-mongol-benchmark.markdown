--- 
layout: post
title: lua-resty-mongol性能测试
date: 2012-04-18 15:26:24 +08:00
category:
- dev
tags:
- mongodb
---

[lua-resty-mongol](https://github.com/bigplum/lua-resty-mongol)是一个基于ngx_lua cosocket API的mongodb驱动，支持mongodb和gridfs的数据访问。
对[lua-resty-mongol](https://github.com/bigplum/lua-resty-mongol)做了一下性能测试，和php driver做简单对比。

__测试脚本__

PHP:
    <?php
    try
    {
        $m = new Mongo("mongodb://admin:admin@10.6.2.51:27019/test"); // connect
        $db = $m->selectDB("test");
        $col = new MongoCollection($db, "test");
        $a = array("name"=>"dog");
        $col->insert($a);
        echo "ok";
    }
    catch ( MongoConnectionException $e )
    {
        header("Status: 400");
        echo '<p>Couldn\'t connect to mongodb, is the "mongo" process running?</p>';
        exit();
    }

lua:
    local mongo = require "resty.mongol"
    conn = mongo:new()
    ok, err = conn:connect("10.6.2.51","27019")
    if not ok then
        ngx.say("connect failed: "..err)
    end
    
    local db = conn:new_db_handle("test")
    db:auth("admin","admin")
    col = db:get_col("test")
    
    r, err = col:insert({{name="dog"}}, nil, true)
    
    if not r then
        ngx.status = 400
        ngx.say("not ok")
    else
        ngx.say("ok")
    end
    
    local ok, err = conn:set_keepalive(0,1000)
    if not ok then
        ngx.say("failed to set keepalive: ", err)
        return
    end

__结论__

mongodb基础数据为2千万。在100并发的情况下，lua-resty-mongol的rqs要少于php；但是200以上并发，php-fpm就出错了，并发越大，请求出错的比例越大，1000并发的时候基本就不可用了。
lua-resty-mongol在1000并发还能正常处理，直把cpu榨干。

__100并发php-fpm(128进程)__

    Concurrency Level:      100
    Time taken for tests:   29.207 seconds
    Complete requests:      100000
    Failed requests:        0
    Write errors:           0
    Total transferred:      14000000 bytes
    HTML transferred:       200000 bytes
    Requests per second:    3423.82 [#/sec] (mean)
    Time per request:       29.207 [ms] (mean)
    Time per request:       0.292 [ms] (mean, across all concurrent requests)
    Transfer rate:          468.10 [Kbytes/sec] received
    
    # vmstat 3
    procs -----------memory---------- ---swap-- -----io---- -system-- -----cpu------
     r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy id wa st
     0  0      0 963136 118028 830352    0    0     0     3   13   12  1  0 99  0  0
    55  0      0 936296 118028 831004    0    0     0     0 8180 3195 15 15 69  0  0
     5  0      0 935792 118028 832104    0    0     0     0 21763 13323 38 34 28  0  0
     3  0      0 935032 118028 833248    0    0     0     0 23602 18365 43 38 19  0  0
     2  0      0 933528 118028 834224    0    0     0     1 25535 16463 35 31 34  0  0
     7  0      0 930656 118028 835548    0    0     0     0 26086 16750 49 45  6  0  0
     5  0      0 929424 118028 836736    0    0     0  1904 26419 18626 48 43  8  1  0
     5  0      0 929576 118028 838040    0    0     0     0 26203 18051 50 46  4  0  0
     4  0      0 928832 118028 839048    0    0     0     0 25447 17577 35 33 32  0  0
    129  0      0 926704 118028 840204    0    0     0     0 25506 15398 40 40 19  0  0
     1  0      0 926200 118028 841468    0    0     0     0 27278 14775 45 41 15  0  0
     0  0      0 925624 118028 841992    0    0     0  1868 9827 7752 20 17 61  2  0
     0  0      0 925784 118028 841988    0    0     0     0   41   22  0  0 100  0  0

__500并发php-fpm(128进程)__

    Concurrency Level:      500
    Time taken for tests:   17.449 seconds
    Complete requests:      100000
    *Failed requests:        51013*
       (Connect: 0, Receive: 0, Length: 51013, Exceptions: 0)
    Write errors:           0
    Non-2xx responses:      51013
    Total transferred:      22723223 bytes
    HTML transferred:       8566132 bytes
    Requests per second:    5731.07 [#/sec] (mean)
    Time per request:       87.244 [ms] (mean)
    Time per request:       0.174 [ms] (mean, across all concurrent requests)
    Transfer rate:          1271.76 [Kbytes/sec] received

__100并发lua-resty-mongol__

    Concurrency Level:      100
    Time taken for tests:   47.230 seconds
    Complete requests:      100000
    Failed requests:        0
    Write errors:           0
    Total transferred:      17000000 bytes
    HTML transferred:       300000 bytes
    Requests per second:    2117.29 [#/sec] (mean)
    Time per request:       47.230 [ms] (mean)
    Time per request:       0.472 [ms] (mean, across all concurrent requests)
    Transfer rate:          351.50 [Kbytes/sec] received
    vmstat 3
    procs -----------memory---------- ---swap-- -----io---- -system-- -----cpu------
     r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy id wa st
     0  0      0 770400 118004 937032    0    0     0     3   12   12  1  0 99  0  0
     1  0      0 768240 118008 937232    0    0     0    19 8814  515  9  6 85  0  0
     2  0      0 767328 118008 937884    0    0     0     0 22968 1645 22 19 59  0  0
     1  0      0 766872 118008 938524    0    0     0     0 22925 1197 24 17 58  0  0
     1  0      0 766720 118008 939168    0    0     0     0 22496 1416 24 17 60  0  0
     1  0      0 765800 118008 939784    0    0     0   747 22596 1186 22 20 56  2  0
     1  0      0 765056 118008 940292    0    0     0     0 16807  957 18 12 70  0  0
     1  0      0 764904 118008 940652    0    0     0     0 15967 1017 16 14 71  0  0
     1  0      0 764136 118016 941272    0    0     0     0 22797 1128 24 17 59  0  0
     1  0      0 763680 118016 941812    0    0     0     0 19584  977 21 15 64  0  0
     1  0      0 762920 118016 942448    0    0     0   891 23230 1101 22 19 57  1  0
     1  0      0 762456 118016 943064    0    0     0   376 22710 1119 23 18 59  0  0
     1  0      0 761696 118016 943672    0    0     0     0 22947 1251 24 19 58  0  0
     1  0      0 761392 118016 944312    0    0     0     1 22875 1132 23 18 59  0  0
     2  0      0 760016 118016 944936    0    0     0     0 22489 1276 24 19 57  0  0
     2  0      0 760320 118020 945556    0    0     0   677 22556 1243 24 18 56  1  0
     2  0      0 758800 118020 946168    0    0     0     0 22841 1014 23 20 57  0  0
     0  0      0 760016 118020 946288    0    0     0     0 2046  139  2  2 96  0  0

__1000并发lua-resty-mongol__

    Concurrency Level:      1000
    Time taken for tests:   28.071 seconds
    Complete requests:      100000
    Failed requests:        0
    Write errors:           0
    Total transferred:      17000000 bytes
    HTML transferred:       300000 bytes
    Requests per second:    3562.43 [#/sec] (mean)
    Time per request:       280.707 [ms] (mean)
    Time per request:       0.281 [ms] (mean, across all concurrent requests)
    Transfer rate:          591.42 [Kbytes/sec] received
    
    # vmstat 3
    procs -----------memory---------- ---swap-- -----io---- -system-- -----cpu------
     r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy id wa st
     0  0      0 512584 118004 1193296    0    0     0     3   12   12  1  0 99  0  0
     3  0      0 507872 118004 1193560    0    0     0     0 22454  570 28 19 52  0  0
     4  0      0 506456 118004 1193532    0    0     0     0 26159  911 34 21 46  0  0
     3  0      0 505296 118004 1193488    0    0     0     0 33848  478 54 33 13  0  0
     4  0      0 504960 118004 1193408    0    0     0     0 31956  682 48 30 22  0  0
     2  0      0 508824 118004 1193384    0    0     0     0 30053  924 41 27 32  0  0
     2  0      0 507016 118004 1193348    0    0     0    11 25676  459 33 19 48  0  0
     3  0      0 506416 118004 1193344    0    0     0     0 31351  837 45 30 25  0  0
     3  0      0 509024 118004 1193328    0    0     0     1 31092  723 47 27 25  0  0
     4  0      0 506600 118004 1193324    0    0     0     5 27853  334 37 22 41  0  0
     0  0      0 510728 118004 1193308    0    0     0     0 20200  406 31 18 50  0  0
     0  0      0 511344 118004 1193304    0    0     0     9  167   22  0  0 99  1  0
