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

从网上能找到很多画数据结构图和流程图的例子，这里就不赘述，主要介绍怎么画UML时序图。先看效果：


![graphviz时序图](/assets/uploads/2012/04/sequence.png)

代码：
    digraph G{
        ranksep=.1; size = "7.5,7.5";
        node [fontsize=10, shape=point, color=grey,  label=""];
        edge [arrowhead=none, style=filled, color=grey];
    
        a -> b [style=invis]
        b -> c [style=invis]
        c -> d [style=invis]
    
        a [color=black, shape=box, label="a"];
        a -> a10-> a11-> a12-> a13-> a14-> a15-> a16-> a17-> a18-> a19-> a20-> a21; 
    
        b [color=black, shape=box, label="b"];
        b->b10->b11->b12->b13->b14->b15->b16->b17->b18->b19->b20->b21 ;
    
        c [color=black, shape=box, label="c"];
        c -> c10-> c11-> c12-> c13-> c14-> c15-> c16-> c17-> c18-> c19-> c20-> c21; 
    
        d [color=black, shape=box, label="d"];
        d -> d10-> d11-> d12-> d13-> d14-> d15-> d16-> d17-> d18-> d19-> d20-> d21; 
    
        { rank = same; a;   b;   c;   d;   }
        { rank = same; a10; b10; c10; d10; }
        { rank = same; a11; b11; c11; d11; }
        { rank = same; a12; b12; c12; d12; }
        { rank = same; a13; b13; c13; d13; }
        { rank = same; a14; b14; c14; d14; }
        { rank = same; a15; b15; c15; d15; }
        { rank = same; a16; b16; c16; d16; }
        { rank = same; a17; b17; c17; d17; }
        { rank = same; a18; b18; c18; d18; }
        { rank = same; a19; b19; c19; d19; }
        { rank = same; a20; b20; c20; d20; }
        { rank = same; a21; b21; c21; d21; }
        //下面隐藏线用于保证左右竖线不会错乱
        { rank = same; edge[style=invis] a11->b11-> c11-> d11 }
        { rank = same; edge[style=invis] a14->b14-> c14-> d14 }
        { rank = same; edge[style=invis] a15->b15-> c15-> d15 }
        { rank = same; edge[style=invis] a19->b19-> c19-> d19 }
    
        edge [style=filled, fontsize=8, weight=0, arrowhead=normal, color=black];
        a10 -> b10 [label="msg"];
        b10 -> b11 [label="msg"];
        b11 -> d11 [label="msg"];
        d12 -> c12 [label="msg"];
        c13 -> a13 [label="msg"];
        a14 -> c14 [label="msg"];
        a15 -> d15 [label="msg"];
    }

参考资料：

* [使用graphviz绘制流程图](http://www.icodeit.org/%E4%BD%BF%E7%94%A8graphviz%E7%BB%98%E5%88%B6%E6%B5%81%E7%A8%8B%E5%9B%BE/)
* [Graphviz 筆記](http://blog.derjohng.com/2008/08/01/graphviz-%E7%AD%86%E8%A8%98/)
* [颜色表](http://www.graphviz.org/doc/info/colors.html)
* [形状表](http://www.graphviz.org/doc/info/shapes.html)
