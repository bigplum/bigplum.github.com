--- 
layout: post
title: graphviz使用笔记
date: 2012-04-24 15:26:24 +08:00
category:
- dev
tags:
- graphviz
---
Graphviz （Graph Visualization Software的缩写）是一个由AT&T实验室启动的开源工具包，用于绘制DOT语言脚本描述的图形。

DOT语言是一种文本图形描述语言。它提供了一种简单的描述图形的方法，并且可以为人类和计算机程序所理解。

用graphviz来做软件设计是再合适不过的了，特别是做数据结构描述和流程图。由于设计过程中经常会修改/添加/删除，所以如果使用visio一类的所见即所得编辑器，就需要每次很费劲的调整图形布局，浪费大量时间。而使用graphviz，只需要将精力集中在逻辑设计上，图形绘制布局都由工具引擎来搞定。也因此，需要__精确定位__的图形就不适合使用graphviz来绘制。


参考资料：

[使用graphviz绘制流程图](http://www.icodeit.org/%E4%BD%BF%E7%94%A8graphviz%E7%BB%98%E5%88%B6%E6%B5%81%E7%A8%8B%E5%9B%BE/)
[Graphviz 筆記](http://blog.derjohng.com/2008/08/01/graphviz-%E7%AD%86%E8%A8%98/)
[颜色表](http://www.graphviz.org/doc/info/colors.html)
[形状表](http://www.graphviz.org/doc/info/shapes.html)
