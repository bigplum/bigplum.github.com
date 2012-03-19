--- 
wordpress_id: 52
layout: post
title: !binary |
  bGludXggc2hlbGzohJrmnKzlrZfnrKbkuLLmk43kvZznmoTkuIDkupvmgLvn
  u5M=

date: 2009-06-06 23:21:36 +08:00
wordpress_url: http://blog.59trip.com/?p=52
---
网上收集的资料总结。

1. 计算字符串长度
echo “$str”|awk '{print length($0)}'
expr length “$str”
echo “$str”|wc -c
但是第三种得出的值会多1，可能是把结束符也计算在内了 
<!--more-->
2. 判断字符串是否为空
if [ "$str" =  "" ] 
if [ x"$str" = x ]
if [ -z "$str" ] 

3. 将字符串作为参数传给awk处理
who   |   awk   '/^'"$USER"'/   {   print   $2   }'   (1)    //将$USER作为参数传给awk，利用了字符串连接的功能；
who   |   awk   '$1   ==   user   {   print   $2   }'   user="$USER"  //标准的方式
另外，还可以用环境变量传递参数给awk；
