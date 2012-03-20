--- 
wordpress_id: 263
layout: post
title: !binary |
  bGludXggc2hlbGzohJrmnKzlrZfnrKbkuLLmk43kvZznmoTkuIDkupvmgLvn
  u5Mo5LqMKQ==

date: 2009-07-07 00:27:05 +08:00
wordpress_url: http://blog.59trip.com/?p=263
---
接上篇<a href="http://blog.59trip.com/archives/52">《linux shell脚本字符串操作的一些总结》</a>
4. 截取字符串
<pre class=php name=code>date|cut -c5         //取第五个字符
date|cut -c5-10    //取第五～十个字符
date|cut -c-5        //取前五个字符
date|cut -c5-        //取第五个以后的字符</pre>

5. 将字符串与数字比较
例如，列出当前目录下大于1M的文件<!--more-->
<pre class=php name=code>ls -l|awk '{if($5>1000000) print $0}'</pre>

6. 查找目录下包含特定字符串的文件
<pre class=php name=code>find . -name "*.php" -exec grep -H "sso" {} \;  //在当前目录下，查找包含sso的php文件，并且列出文件名</pre>
