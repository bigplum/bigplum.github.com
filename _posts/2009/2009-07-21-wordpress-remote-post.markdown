--- 
wordpress_id: 356
layout: post
title: !binary |
  d29yZHByZXNz55qE6L+c56iL5Y+R5biD5Yqf6IO9

excerpt: !binary |
  d29yZHByZXNz5pSv5oyB5Lik56eN6L+c56iL5Y+R5biD5Yqf6IO977yM6YCa
  6L+H6YKu5Lu25Y+R5biD5ZKM6YCa6L+HYXRvbeaOpeWPo+WPkeW4g+OAgumA
  mui/h+mCruS7tuWPkeW4g+mcgOimgeWNleeLrOeUs+ivt+S4gOS4qumCrueu
  se+8jOWcqOWQjuWPsOmFjee9ruWlveS5i+WQju+8jOaJgOacieWPkeW+gOi/
  meS4qumCrueuseeahOmCruS7tumDveS8muiiq+WPkeW4g+WIsOWNmuWuouS4
  iuOAgg0KDQphdG9t5o6l5Y+j55u45a+5566A5Y2V5LiA54K577yM5Y+q6ZyA
  6KaB5Zyo5ZCO5Y+w5byA5ZCv6YCJ6aG55ZCO77yM6YCa6L+HUkVTVOaOpeWP
  o+WwseiDveaPkOS6pOaWh+eroOS6huOAgg==

date: 2009-07-21 20:26:38 +08:00
wordpress_url: http://blog.59trip.com/?p=356
---
wordpress支持两种远程发布功能，通过邮件发布和通过atom接口发布。通过邮件发布需要单独申请一个邮箱，在后台配置好之后，所有发往这个邮箱的邮件都会被发布到博客上。

atom接口相对简单一点，只需要在后台开启选项后，通过REST接口就能提交文章了。

不过wordpress的atom接口需要url rewrite支持，据说apache用自动生成的.htaccess就能搞定，但是lighttpd下的rewrite规则就比较麻烦，需要配置一条："^/wp-app.php/(.*)" =&gt; "/wp-app.php?$1"。
<!--more-->
然后生成一个xml文件，格式可以从http://blog.59trip.com/wp-app.php/post/236获取，236为文章id。如下：
<pre class=xml name=code>&lt;?xml version="1.0" encoding="utf-8"?&gt;
&lt;entry xmlns="http://www.w3.org/2005/Atom"
xmlns:app="http://www.w3.org/2007/app" xml:lang="en"&gt;
&lt;title type="text"&gt;
测试
&lt;/title&gt;
&lt;content type="xhtml"&gt;
测试
&lt;/content&gt;
&lt;/entry&gt;</pre>
提交发布命令：
curl -v -X POST --data @a.xml -H "Content-Type:application/atom+xml" -u name:pwd http://blog.59trip.com/wp-app.php/posts

本站完整的rewrite规则如下：
$HTTP["host"] == "blog.59trip.com" {
url.rewrite-once = (
"^/wp-app.php/(.*)" =&gt; "/wp-app.php?$1",
"^/(wp-.+).*/?" =&gt; "$0",
"^/(xmlrpc.php)" =&gt; "$0",
"^/keyword/([A-Za-z_0-9\-]+)/?$" =&gt; "/index.php?keyword=$1",
"^/.*?(\?.*)?$" =&gt; "/index.php$1"
)
}

部分内容参考该贴：<a href="http://www.liangpeng.net/y2009/m06/wordpressatomxieyideshiyong_699.html">http://www.liangpeng.net/y2009/m06/wordpressatomxieyideshiyong_699.html</a>
