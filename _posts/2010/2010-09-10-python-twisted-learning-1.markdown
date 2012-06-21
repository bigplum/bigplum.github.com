--- 
layout: post
title: !binary |
  cHl0aG9u572R57uc57yW56iL5qGG5p62dHdpc3RlZOWtpuS5oOeslOiusCgx
  KQ==

excerpt: !binary |
  56CU56m25LqG5LiA5ZGo55qEdHdpc3RlZO+8jOe7iOS6juWfuuacrOaQnuaH
  guS6huaAjuS5iOeUqHR3aXN0ZWTlhpnku6PnoIHlrozmiJDmg7PlgZrnmoTl
  ip/og73jgILlhpnmraPmlofkuYvliY3vvIzlhYjmirHmgKjkuIDkuItweXRo
  b27nmoTmlofmoaPmr5RwaHDlt67lpJrkuobvvIzkuZ/pmr7mgKpweXRob27k
  uIDnm7TooqvkurrorqTkuLrmmK/lsI/kvJfor63oqIDvvIxwaHDnmoRhcGno
  r7TmmI7pobXpnaLmnInlvojlpJrkurrotKHnjK7nmoTkvovnqIvvvIznnIvo
  v5nkupvkvovnqIvog73lpJ/lvojlrrnmmJPlrabkvJpwaHDnmoTkuIDkupvm
  ioDlt6fvvIzogIxkb2NzLnB5dGhvbumZpOS6huWHveaVsOivtOaYju+8jOWw
  seayoeS7gOS5iOS+i+WtkO+8jOWunuWcqOiuqeS6uuivn+eXheOAgnR3aXN0
  ZWTnmoTmlofmoaPlsKTnlJrvvIzkvovlrZDkuI3mmK/msqHmnInvvIzlsLHm
  mK/lpKrnroDljZXvvIzlrabkuaDmm7Lnur/mgI7kuYjog73kuI3pmaHlkaLj
  gIINCg0KPHN0cm9uZz7nvZHnu5zkuIrnmoTmlZnnqIvku4vnu43vvJo8L3N0
  cm9uZz4NCjEuIDxhIGhyZWY9Imh0dHA6Ly93aWtpLndvb2RwZWNrZXIub3Jn
  LmNuL21vaW4vVHdpc3RlZFRVVCNBLjJCVHhpV3hYYUUtZGVmZXJyZWRfX19f
  X19fX19EZWZlcnJlZHNfYXJlX2JlYXV0aWZ1bCI+VHdpc3RlZOWFpemXqCAt
  LSBmaW5nZXIg55qE5ryU5YyWPC9hPu+8mui/meS4quaVmeeoi+aYr+WumOaW
  ueWFpemXqOaVmeeoi+eahOS4reaWh+eJiO+8jOS4jei/h+acieeCueiAge+8
  jOS+i+eoi+WwseS4jeimgeeUqOi/meS4queJiOacrOeahOS6hu+8jOebtOaO
  pTxhIGhyZWY9Imh0dHA6Ly90d2lzdGVkbWF0cml4LmNvbS9kb2N1bWVudHMv
  Y3VycmVudC9jb3JlL2hvd3RvL3R1dG9yaWFsL2luZGV4Lmh0bWwiPuWOu+i/
  memHjOaLt+i0nTwvYT7mr5TovoPpnaDosLHjgILln7rmnKzkuIrmgLvkvZPl
  hpnnmoTmjLrkuI3plJnvvIzmiop0d2lzdGVk55qE57K+5Y2O6YO95bGV546w
  5Ye65p2l5LqG77yM57uZ5oiR55qE5oSf6KeJ5bCx5piv5b6I6auY5rex44CC
  54m55Yir5piv5ZCO6Z2i55qE57uE5Lu257uT5p6E77yM6K6+6K6h5b6I57K+
  5aaZ77yM5L2G5oiR55yL5LqG5Lik5aSp6L+Y5piv5rKh55CG6Kej5oCO5LmI
  55So77yM5rGX44CC5omA5Lul77yM5aaC5p6c5Yid5a2m5bu66K6u5bCx57K+
  6K+75YmN6Z2iNOeroO+8jOWQjumdoueahOeyl+eVpeeci+eci+WwseihjOS6
  huOAgg==

date: 2010-09-10 22:31:38 +08:00
---
研究了一周的twisted，终于基本搞懂了怎么用twisted写代码完成想做的功能。写正文之前，先抱怨一下python的文档比php差多了，也难怪python一直被人认为是小众语言，php的api说明页面有很多人贡献的例程，看这些例程能够很容易学会php的一些技巧，而docs.python除了函数说明，就没什么例子，实在让人诟病。twisted的文档尤甚，例子不是没有，就是太简单，学习曲线怎么能不陡呢。

<strong>网络上的教程介绍：</strong>
1. <a href="http://wiki.woodpecker.org.cn/moin/TwistedTUT#A.2BTxiWxXaE-deferred_________Deferreds_are_beautiful">Twisted入门 -- finger 的演化</a>：这个教程是官方入门教程的中文版，不过有点老，例程就不要用这个版本的了，直接<a href="http://twistedmatrix.com/documents/current/core/howto/tutorial/index.html">去这里拷贝</a>比较靠谱。基本上总体写的挺不错，把twisted的精华都展现出来了，给我的感觉就是很高深。特别是后面的组件结构，设计很精妙，但我看了两天还是没理解怎么用，汗。所以，如果初学建议就精读前面4章，后面的粗略看看就行了。

2. <a href="http://www.linux-field.com/?cat=5">http://www.linux-field.com/?cat=5</a>: 这个博客有很多教程，质量参差不齐，不过刚学的话，建议都浏览一下，看看能不能发现心得。

3. <a href="http://hi.baidu.com/xjtukanif/blog/item/7280b88d528fa6e4f11f3622.html">使用twisted编写异步服务器</a>：这个帖子列出了使用twisted做异步通信的两种方法：reactor和defer，说明了怎么使用这两个工具来构造程序，配合例程还是很容易理解的。

4. <a href="http://hi.baidu.com/wind_stay/blog/item/07e12b30aeef4aa35fdf0e05.html">Twisted 相关:简单的自定义协议解析</a>：在理解怎么利用twisted构造异步通信服务器之后，就可以参考这篇文章，设计自己的通信协议，并将其插入到twisted的框架之中。

<strong>IO复用、异步通信</strong>
twisted中用到了大量设计模式，尤其是协议与工厂，几乎贯穿始终，再加上defer这个魔术般的东西隐藏了太多细节，使得大多数的程序结构都难以理解，缺乏可读性。实际上IO多路复用、异步通信等都不是什么高深的概念，epoll或者完成端口模型如果用C程序从头实现，程序结构会比twisted清晰的多。但考虑到twisted封装了细节，提供了统一的编程框架，带来的好处还是显而易见的，特别是提供了大量http、ftp等应用层协议的封装，使得开发Internet程序方便了许多。

但另一方面，要使用twisted，就必须改变原有的编程思维，让既有思路融合进twisted的设计思想，才能有效的利用twisted提供的各种api。让代码脱离开自己的控制，屈从twisted框架，这对于一个写贯了C的程序员来讲，尤其困难。

<strong>defer不是万能的</strong>
如果刚开始学twisted，建议先不要用defer。用defer能完成的功能，同样用reactor也能完成，而且代码可读性会好很多，可以参考上面的第三个参考资料<<a href="http://hi.baidu.com/xjtukanif/blog/item/7280b88d528fa6e4f11f3622.html">使用twisted编写异步服务器</a>>。（目前来看是如此，我用这两个东西分别实现了相同的功能）
