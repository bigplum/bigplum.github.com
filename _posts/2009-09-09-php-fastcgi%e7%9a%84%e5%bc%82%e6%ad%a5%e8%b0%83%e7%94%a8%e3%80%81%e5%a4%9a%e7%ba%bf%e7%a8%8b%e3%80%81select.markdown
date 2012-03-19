--- 
wordpress_id: 597
layout: post
title: !binary |
  cGhwIGZhc3RjZ2nnmoTlvILmraXosIPnlKjjgIHlpJrnur/nqIvjgIFzZWxl
  Y3Q=

excerpt: !binary |
  57O757uf55qEcGhw5piv5L2/55SoZmFzdGNnaeaPkOS+m+acjeWKoeeahO+8
  jOWQr+WKqOaXtumihOWFiHNwYXdu5LqGbuS4qnBocC1jZ2nov5vnqIvvvIzo
  va7mtYHmj5DkvpvmnI3liqHjgILnlLHkuo7nlKhwaHDlgZrkuobkuIDkupvm
  nI3liqHvvIzogIzov5nkupvmnI3liqHnmoTmiafooYzml7bpl7Tmr5TovoPp
  lb/vvIzmtonlj4rliLDlpJrkuKrnvZHnu5zoioLngrnkuYvpl7TkuqTkupLv
  vIzov5nmoLflsLHlr7zoh7RwaHAtY2dp6L+b56iL5Zyo5Li65LiA5Liq6K+3
  5rGC5o+Q5L6b5pyN5Yqh5LmL5ZCO77yM5LiL5Liq6K+35rGC5bCx5b+F6aG7
  5o6S6Zif562J5b6F77yM5piO5pi+6ZmN5L2O5LqG5ZCe5ZCQ6YeP44CCDQoN
  Cui/meS4qumXrumimOeglOeptuS6huW+iOS5he+8jOi/mOaYr+ayoeino+OA
  guacieS4quinhOmBv+eahOaWueazle+8jOWwseaYr+iuqXBocC1jZ2nmjInp
  nIDlkK/liqjvvIzlpoLmnpzov5vnqIvmlbDkuI3lpJ/lsLHoh6rliqhmb3Jr
  5LiA5Liq77yM6L+Z5qC35Y+v5Lul5pyA5aSn6ZmQ5bqm55qE5Yip55So57O7
  57uf6LWE5rqQ77yM5L2G5q+U6L6D5rWq6LS55YaF5a2Y77yM6ICM5LiU5LiN
  5aW9566h55CG77yM5LiA5pem5p+Q5Liq6L+b56iL5oyC5q2777yM5bCx5Lya
  5LiA55u05oyC5L2P77yM5aSW55WM5peg5rOV5bmy6aKE44CCDQo=

date: 2009-09-09 11:12:16 +08:00
wordpress_url: http://blog.59trip.com/?p=597
---
系统的php是使用fastcgi提供服务的，启动时预先spawn了n个php-cgi进程，轮流提供服务。由于用php做了一些服务，而这些服务的执行时间比较长，涉及到多个网络节点之间交互，这样就导致php-cgi进程在为一个请求提供服务之后，下个请求就必须排队等待，明显降低了吞吐量。

这个问题研究了很久，还是没解。有个规避的方法，就是让php-cgi按需启动，如果进程数不够就自动fork一个，这样可以最大限度的利用系统资源，但比较浪费内存，而且不好管理，一旦某个进程挂死，就会一直挂住，外界无法干预。

php没有多线程，但是可以用fork来实现多进程，这个方法就与上述的规避方法差不多了，还是每个进程处理一个请求，如果想让一个进程并发处理多个请求就不行了。

其实我设想的模型是单进程多连接并能实时响应的，避免了多线程同步带来的复杂性，又能最大限度调动系统资源。这个模型是以前的产品中使用的，性能优势发挥的淋漓尽致，很牛逼的击败了世界上的所有同类产品。所以就研究了一下python的twisted框架，发现很像，有可能可以利用twisted来达成目的。

基于这个设想，突然想到php也有select调用，那能不能将php脚本的网络传输异步化，把php-cgi进程空闲出来呢？答案也是否定的，php-cgi进程会等到当前的请求完成之后才会处理下一个请求，所以即使进程空闲了也是白搭。

问题在于php自身的设计机制，php能很好的响应每次请求，并且回收所使用的资源，但是如果想把它做成一个驻留的后台服务就有点像赶鸭子上架，即使php提供了共享内存、消息队列等几乎unix系统中所有的多进程调用。
