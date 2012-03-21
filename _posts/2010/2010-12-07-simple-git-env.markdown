--- 
wordpress_id: 934
layout: post
title: !binary |
  5pCt5bu6566A5piTZ2l05byA5Y+R546v5aKD

date: 2010-12-07 17:01:09 +08:00
wordpress_url: http://pipa.tk/?p=934
---
准备两个linux机器，其中一个是git服务器，主要用于备份代码；另一个是工作机。这样搞死一个也不会导致代码丢失。

在git服务器上
{% highlight bash%}
#mkdir test.git
#cd test.git
#git --bare init
{% endhighlight %}
在工作机上，进入代码目录：
{% highlight bash%}
#git init
#git add .
#git commit -am "init"
#git branch
* master
#git push root@git_server_ip:/root/nginx/test.git/ master
{% endhighlight %}
然后就可以在工作机上建立分支，进行merge等操作了。

参考资料：
<a href="http://zh-cn.whygitisbetterthanx.com/#">
Why Git is Better than X</a>
<a href="http://people.debian.org.tw/~chihchun/2008/12/19/linus-torvalds-on-git/">Linus Torvalds on git</a>
<a href="http://www.zeuux.org/science/learning-git.cn.html">学习 Git</a>
<a href="http://blog.prosight.me/index.php/2009/11/485">小组级git服务器搭建</a>
