--- 
layout: post
title: !binary |
  ZnVzZeeUn+aIkOeahOaWh+S7tuezu+e7n+WmguS9leaUr+aMgeWkmueUqOaI
  t+iuv+mXrg==

excerpt: !binary |
  6L+Z5Liq5pyI55SocHl0aG9u5YaZ5LqG5LiA5LiqZnVzZeeahOWuouaIt+er
  r+eoi+W6j++8jOWunueOsOS6huS4gOS4quiZmuaLn+eahOaWh+S7tuezu+e7
  n++8jOWPr+S7peaUr+aMgXJlYWQsIHdyaXRlLCBjbG9zZeetieaWh+S7tuaT
  jeS9nO+8jOS9huaYr+S7iuWkqeWcqOeUqOeahOaXtuWAmeWPkeeOsO+8jOi/
  meS4quaWh+S7tuezu+e7n+WPquWvueaJp+ihjOeoi+W6j+eahOeUqOaIt+WP
  r+inge+8jOWFtuS7lueUqOaIt+agueacrOeci+S4jeWIsOi/meS4qmZz77yM
  ZGbjgIFtb3VudOS5n+eci+S4jeWIsO+8jGxz5pe25o+Q56S64oCccGVybWlz
  c2lvbiBkZW554oCd77yMIOmDgemXt+S6huOAgg0KDQrmjInnkIbor7Tmlofk
  u7bns7vnu59tb3VudOS5i+WQju+8jOWvueeUqOaIt+aYr+WQpuWPr+ingeaY
  r+eUseaWh+S7tueahOWxnuS4u+WSjOWxnuaAp+WGs+WumueahO+8jOS9huaY
  r+S8vOS5jmZ1c2XnmoTmqKHlnZflj4jorr7orqHkuobkuIDlsYLlronlhajp
  mZDliLbvvIzpu5jorqTmg4XlhrXkuIvlj6rog73ov5vnqIvlsZ7kuLvlj6/o
  p4HjgILnoJTnqbbkuobkuIDkuItzc2hmc++8jOaJvuWIsOS4gOS4qmFsbG93
  X290aGVy55qE6YCJ6aG577yM5Y+I56CU56m25LqG5Y2K5aSp5omN5pCe5riF
  5qWa5oCO5LmI55So77yMZnVzZeeahOWGheaguOaooeWdl+aUr+aMgeivpemA
  iemhue+8jOWPqumcgOimgeWcqOaJp+ihjOeoi+W6j+aXtuWKoOS4ii1vIGFs
  bG93X290aGVy5Y2z5Y+v44CCDQoNCuWmguS4i+aJgOekuu+8jA0KLi9mdXNl
  ZnMucHkgIG5vbmUgL21udCAtbyBmc25hbWU9MTIzLGFsbG93X290aGVyDQoN
  CmZ1c2XjgIFweXRob27nmoTkuK3mlofotYTmlpnlvojlsJHvvIzoi7Hmlofo
  tYTmlpnkuZ/kuI3lpJrvvIzluIzmnJvog73luK7liLDmnInnlKjnmoTkurrj
  gII=

date: 2009-11-05 15:52:28 +08:00
---
这个月用python写了一个fuse的客户端程序，实现了一个虚拟的文件系统，可以支持read, write, close等文件操作，但是今天在用的时候发现，这个文件系统只对执行程序的用户可见，其他用户根本看不到这个fs，df、mount也看不到，ls时提示“permission deny”， 郁闷了。

按理说文件系统mount之后，对用户是否可见是由文件的属主和属性决定的，但是似乎fuse的模块又设计了一层安全限制，默认情况下只能进程属主可见。研究了一下sshfs，找到一个allow_other的选项，又研究了半天才搞清楚怎么用，fuse的内核模块支持该选项，只需要在执行程序时加上-o allow_other即可。

如下所示，
./fusefs.py  none /mnt -o fsname=123,allow_other

fuse、python的中文资料很少，英文资料也不多，希望能帮到有用的人。
