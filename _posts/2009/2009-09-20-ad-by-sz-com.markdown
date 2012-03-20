--- 
wordpress_id: 520
layout: post
title: !binary |
  5rex5Zyz55S15L+h55qE5peg6IC76KGM5Li6LeW8ueWHuuW5v+WRiuWSjOeq
  peaOoumakOengQ==

excerpt: !binary |
  55So5rex5Zyz55S15L+h55qEQURTTOS4iue9kee7j+W4uOeisOWIsOi/meen
  jeaDheWGte+8jGZpcmVmb3jnmoTlj7Pkvqfmu5rliqjmnaHojqvlkI3lhbbl
  ppnnmoTkvJrlpJrlh7rkuIDmnaHvvIzkuIDlvIDlp4vku6XkuLrmmK9maXJl
  Zm9454mI5pys55qE6Zeu6aKY77yM5oiR55So55qE5pivcG9ydGFibGXniYjn
  moRmaXJlZm9477yM5ZCO5p2l5Y+R546wY2hyb21l5Lmf5pyJ5LiA5qC355qE
  6Zeu6aKY77yM57uI5LqO5pyJ5LiA5aSp5b+N5LiN5L2P5p+l55yL5LqG5LiA
  5LiL6aG16Z2i55qE5rqQ56CB77yM5Y+R546w5Y6f5p2l5LiN5piv5oiR55qE
  6Zeu6aKY44CCDQoNCuS4i+mdoueahOS7o+eggeWwseaYr+a3seWcs+eUteS/
  oeW+gOaIkeeahOa1j+iniOWZqOaOqOmAgeeahOS7o+egge+8jOeUqOa1j+in
  iOWZqOaQnOe0ojEyMS4xNS4yMDcuMTc25oiW6ICFNDAyMu+8jOmDveiDveaQ
  nOWIsOW+iOWkmuWSjOi/meevh+aWh+eroOexu+S8vOWGheWuueeahOW4luWt
  kOOAguOAguOAgueugOWNleeahOivtOWwseaYr+iOt+WPlueUteiEkeS4iuea
  hOa1j+iniOWZqOeJiOacrOOAgeWxj+W5leeahOWIhui+qOeOh+etieS/oeaB
  r+S+m+eUteS/oeeahOebuOWFs+mDqOmXqOWPguiAg+OAgg==

date: 2009-09-20 19:53:36 +08:00
wordpress_url: http://blog.59trip.com/?p=520
---
用深圳电信的ADSL上网经常碰到这种情况，firefox的右侧滚动条莫名其妙的会多出一条，一开始以为是firefox版本的问题，我用的是portable版的firefox，后来发现chrome也有一样的问题，终于有一天忍不住查看了一下页面的源码，发现原来不是我的问题。

下面的代码就是深圳电信往我的浏览器推送的代码，用浏览器搜索121.15.207.176或者4022，都能搜到很多和这篇文章类似内容的帖子。。。简单的说就是获取电脑上的浏览器版本、屏幕的分辨率等信息供电信的相关部门参考。
<pre name=code class=html>　　var link="http://121.15.207.176:4022/logo.jpg?p=";
　　link += Math.floor((new Date()).getTime()/1000);
　　link += "|";
　　link +=  navigator.appMinorVersion;
　　link += "|";
　　link += screen.availHeight;
　　link += "|";
　　link += screen.availWidth;
　　link += "|";
　　link += screen.colorDepth;
　　link += "|";
　　link += screen.height;
　　link += "|";
　　link += screen.width;
</pre>
可以参考下面这些文章：
<a href="http://www.csmao.com/sz_4022/">http://www.csmao.com/sz_4022/</a>
<a href="http://zhidao.baidu.com/question/90886987.html">http://zhidao.baidu.com/question/90886987.html</a>
<a href="http://bbs.hxsd.com/archive/index.php/t-5253274.html">http://bbs.hxsd.com/archive/index.php/t-5253274.html</a>
<a href="http://www.tianya.cn/publicforum/content/itinfo/cb09054a798e5c8c10c75c64141457bb/1/0/1.shtml">http://www.tianya.cn/publicforum/content/itinfo/cb09054a798e5c8c10c75c64141457bb/1/0/1.shtml</a>
<a href="http://www.xmsq.com/space/7740/viewspace-8594.html">http://www.xmsq.com/space/7740/viewspace-8594.html</a>

目前最有效的办法就是在防火墙上过滤掉121.15.207.0这个网段，或者过滤4022端口，不过这需要路由器支持，深圳电信以前送的华为的HG520s的猫貌似没有这种功能。

今天上网，发现电信居然名目张胆的直接推送广告了，一连打开几个页面都弹出jianguodaye的广告，而且令人发指的是这个广告无法关闭，你只能重新刷新页面，一百遍啊一百遍。。。
<pre name=code class=html>
...iframe src='http://ifeng.gd.vnet.cn/ts/e-ifeng/index.html?
......
... src='http://121.15.207.29:1010/embed.js'></script>
.....
var param="350|250|9|2|1|3|0";
var base_url="http://121.15.207.29:1010/";
var stat_path="http://121.15.207.107/stat.aspx?p=1253445691|214432727|1144|1076|0|0";
try{var obj=new EmbedShow();}catch(e){location.reload(true);}
</pre>

实在忍不住了，无奈啊，中国的互联网。
