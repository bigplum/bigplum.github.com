--- 
wordpress_id: 516
layout: post
title: !binary |
  YmFzaOWmguS9leWwhuS4gOS4quWtl+espuS4sui9rOaNouaIkOaVsOe7hA==

excerpt: !binary |
  55u05o6l6L+Z5qC36LWL5YC85bCx5Y+v5Lul5LqG77yM5b6I566A5Y2V77ya
  DQo8cHJlPmQ9KCAke2xpc3R9ICkNCjwvcHJlPg0K5LiL6Z2i6L+Z5q615Luj
  56CB5LuO5b2T5YmN55uu5b2V55qE5paH5Lu25Lit77yM6ZqP5py66YCJ5Y+W
  5LiA5Liq77yaDQo8cHJlPg0KIyEvYmluL2Jhc2gNCmxpc3Q9YGxzYA0KZD0o
  ICR7bGlzdH0gKQ0Kcm51bT1gZXhwciAkUkFORE9NICUgJHsjZFtAXX1gDQpl
  Y2hvICR7ZFskcm51bV19DQo8L3ByZT4=

date: 2009-08-14 18:08:49 +08:00
wordpress_url: http://blog.59trip.com/?p=516
---
直接这样赋值就可以了，很简单：
<pre>d=( ${list} )
</pre>
下面这段代码从当前目录的文件中，随机选取一个：
<pre>
#!/bin/bash
list=`ls`
d=( ${list} )
rnum=`expr $RANDOM % ${#d[@]}`
echo ${d[$rnum]}
</pre>
