--- 
layout: post
title: !binary |
  YmFzaOiEmuacrOeahOWtpuS5oOeslOiusA==

excerpt: "1. \xE4\xB8\x80\xE8\xA1\x8C\xE5\x88\xA4\xE6\x96\xAD\xE8\xAF\xAD\xE5\x8F\xA5\r\n\
  [ -z $vmip ] || [ -z $vmname ] && echo \"Usage: $SCRIPTNAME vmname vmip vmmac\" >&2\r\n\
  \r\n\
  2. \xE8\x8E\xB7\xE5\xBE\x97\xE6\x95\xB0\xE7\xBB\x84\xE9\x95\xBF\xE5\xBA\xA6\r\n\
  host=(\r\n\
  10.1.1.181\r\n\
  10.1.1.182\r\n\
  )\r\n\
  echo ${#host[@]}"
date: 2009-06-30 08:14:14 +08:00
---
1. 一行判断语句
<pre class=php name=code>[ -z $vmip ] || [ -z $vmname ] 
&& echo "Usage: $SCRIPTNAME vmname vmip vmmac" >&2</pre>

2. 获得数组长度
<pre class=php name=code>host=(
10.1.1.181
10.1.1.182
)
echo ${#host[@]}</pre>

3. 十进制转换为十六进制
<pre class=php name=code>id=`echo "10.1.1.182"|awk -F'.' '{printf "%x",$4}'`</pre>
<!--more-->
4. 生成随机数
<pre class=php name=code>hostid=`expr $RANDOM % ${#host[@]}`</pre>

5. sed替换文本
<pre class=php name=code>sed "s/\r//" eth0.tmp|sed -e "s/\(^IPADDR=.*\)/IPADDR=\"$vmip\"/" \
                        > /mnt/etc/sysconfig/network/ifcfg-eth0</pre>
