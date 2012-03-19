--- 
wordpress_id: 497
layout: post
title: !binary |
  5L2/55SoY3lnd2lu5byA5Y+RbGludXggY+eoi+W6j++8iOS6jO+8iS3luLjn
  lKjlt6Xlhbc=

excerpt: !binary |
  bGludXjlvIDlj5Hln7rmnKzmmK/ln7rkuo7lkb3ku6TooYznlYzpnaLnmoTv
  vIznibnliKvmmK/lgZrmnI3liqHlmajnq6/nmoTnqIvluo/lvIDlj5HjgILl
  vZPnhLbkuZ/mnInkuIDkupvlvojkvJjnp4DnmoRHVUnlvIDlj5Hlt6Xlhbfv
  vIzkvYbmiJHkuIDoiKzpg73kuI3nlKjvvIzkuZ/lvojlsJHop4HliKvkurrk
  vb/nlKjjgILpq5jmiYvkuIDoiKznlKhFbWFjc+aIluiAhXZp55u05o6l5Zyo
  dGVsbmV05a6i5oi356uv5LiK5YaZ5Luj56CB77yM5oiR6L+Y5piv5Lmg5oOv
  5Zyod2luZG93c+S4i+eUqHNvdXJjZSBpbnNpZ2h05oiW6ICFdWXlhpnlpb3k
  u6PnoIHvvIzkvKDliLBsaW51eOWQjue8luivkeiwg+ivle+8jOWmguaenOac
  ieS6m+Wwj+S/ruaUueaJjeeUqHZp57yW6L6R44CCDQoNCipuaXjnmoTorr7o
  rqHljp/liJnmmK9rZWVwIGl0IHNpbXBsZe+8jOS4gOagt+W3peWFt+WPquWu
  jOaIkOS4gOS4queLrOeri+eahOWKn+iDve+8jOmAmui/h+euoemBk+OAgeiE
  muacrOWwhui/meS6m+W3peWFt+e7hOWQiOi1t+adpeW9ouaIkOeahOWKn+iD
  veWwseW+iOW8uuWkp+S6huOAguacgOWkp+eahOS4gOS4quWlveWkhOaYr+WP
  r+S7peiHquWKqOWMluWkhOeQhu+8jOS+i+WmguaIkeWGmeeahOWfn+WQjeaf
  peivouW3peWFt++8jOWwseaYr+eUqGJhc2johJrmnKzlhpnnmoTvvIzliqDo
  tbfmnaXku6PnoIHkuI3liLAxMDDooYzvvIzopoHmmK/mlL7liLB3aW5kb3dz
  5LiL6Z2i77yM55yf5LiN55+l6YGT6K+l5aaC5L2V5LiL5omL44CC5Lul5YmN
  5YGa5oCn6IO95rWL6K+V5oql5ZGK77yM6KaB5LuO5LiA5aCG55qEY3B144CB
  56OB55uY44CB572R57uc55qE6L6T5Ye657uT5p6c5Lit6YCJ5Y+W54m55a6a
  55qE5pWw5o2u55Sf5oiQ5Zu+6KGo77yM5bCx5YCf5YqpKm5peOWRveS7pOih
  jOW3peWFt+adpeetm+mAieaVsOaNru+8jOmAmui/h+eugOWNleeahOWHoOS4
  quWRveS7pOWwsemAieWHuumcgOimgeeahOaVsOaNru+8jOeEtuWQjuaUvuWI
  sGV4Y2Vs6KGo5qC877yM5bCx5YGa5Ye65ryC5Lqu55qE5puy57q/5LqG44CC
  DQoNCuS7iuWkqeWFiOS7i+e7jeWHoOS4quW4uOeUqOeahOWRveS7pO+8jGNk
  44CBbHPnrYnln7rmnKzlkb3ku6TnmoTlsLHkuI3ku4vnu43kuobvvIzkuLvo
  poHorrLorrLlvIDlj5HluLjnlKjnmoTjgII=

date: 2009-08-07 13:43:02 +08:00
wordpress_url: http://blog.59trip.com/?p=497
---
linux开发基本是基于命令行界面的，特别是做服务器端的程序开发。当然也有一些很优秀的GUI开发工具，但我一般都不用，也很少见别人使用。高手一般用Emacs或者vi直接在telnet客户端上写代码，我还是习惯在windows下用source insight或者ue写好代码，传到linux后编译调试，如果有些小修改才用vi编辑。

*nix的设计原则是keep it simple，一样工具只完成一个独立的功能，通过管道、脚本将这些工具组合起来形成的功能就很强大了。最大的一个好处是可以自动化处理，例如我写的域名查询工具，就是用bash脚本写的，加起来代码不到100行，要是放到windows下面，真不知道该如何下手。以前做性能测试报告，要从一堆的cpu、磁盘、网络的输出结果中选取特定的数据生成图表，就借助*nix命令行工具来筛选数据，通过简单的几个命令就选出需要的数据，然后放到excel表格，就做出漂亮的曲线了。

今天先介绍几个常用的命令，cd、ls等基本命令的就不介绍了，主要讲讲开发常用的。
<strong>0. man</strong>
这个是超级必备技能，新手上路一定要善于利用这个工具，很多时候在网上查了半天，却发现man手册中的第一页就写清楚怎么用了。man也可以查libc函数库的信息，例如
a. man 2 stat  查函数int stat(const char *path, struct stat *buf);  //cygwin下好像不能使用
b. man stat   查命令stat
<!--more-->
<strong>1. vi编辑器</strong>
linux开发必备技能，vi的命令很多不需要完全掌握，记得几个常用的就行了：
a. a/i 进入编辑模式;
b. 使用ESC从编辑模式退出到命令模式;
c. / 搜索
d. h/j/k/l  移动
e. $ ^ ctrl+f ctrl+b 跳转
f.  x dd  删除
g. y p 拷贝、粘贴
记得上面的就差不多了，更详细的自己去找教材看，我也记不住了。

<strong>2. cat/more</strong>
查看文件命令，通常和管道一起使用。
a. ls -l /home |more  分屏显示/home目录下的文件

<strong>3. 重定向'>' '<' 和管道'|'</strong>
a. ls -l > /tmp/out.txt  将屏幕输出重定向到新文件
b. ls -l >> /tmp/out.txt  将屏幕输出重定向添加到文件
c. 生成一个a.txt文件，内容从标准输入获取
linux:~ # cat > a.txt << EOF
> adsf
> EOF

<strong>4. grep wc cut</strong>
a. grep abc 1.txt   查找1.txt中包含abc的行，并输出
b. grep abc 1.txt|wc -l    统计1.txt中包含abc的行
c. grep abc 1.txt|cut -c 1-5    查找1.txt中包含abc的行 ，并输出每行的前5个字符

<strong>5. awk</strong>
awk是很强大的文本处理工具，数据统计就靠它了；linux开发必备技能，最常的用法就是取一堆输出中的某一列数据，如：
a. ls -l /|awk '{print $5}'   取出/目录下所有文件、目录的大小
b. 参考这篇<<a href="http://blog.59trip.com/archives/329">linux shell统计网站日志的独立ip数</a>>

<strong>6. sed </strong>
也是文本处理工具，和awk配合使用，不介绍了，我一般都不用的，除非涉及到行数计算、或者替换文件内容时。例如，根据输入参数，自动生成配置文件。

