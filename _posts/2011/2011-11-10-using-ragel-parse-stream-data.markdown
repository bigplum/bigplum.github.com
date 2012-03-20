--- 
wordpress_id: 1046
layout: post
title: !binary |
  UmFnZWzop6PmnpDmtYHlvI8oc3RyZWFtKeaVsOaNrg==

date: 2011-11-10 09:48:41 +08:00
wordpress_url: http://pipa.tk/?p=1046
---
Ragel是一个状态机代码生成器，支持多种语言C, C++, Objective-C, D, Java, Ruby。一般用来写正则表达式解析协议数据，然后编译成相应代码嵌入到其他语言中。

[Ragel](http://www.complang.org/ragel/")的介绍和入门可以看这里：<http://blog.dccmx.com/2011/01/ragel-intro-1/>

解析http头的例子可以看这里：<http://yaoweibin2008.blog.163.com/blog/static/110313920098211472956/>，下面的例子抄了部分URL的定义。

所谓流式解析就是限制buffer使用，保持内存为一个常量。例如，要解析4k的数据，如果不使用流式解析，就必须申请4k的buffer。如果使用流式解析，可以每次读取1k数据，解析之后丢弃掉。

Ragel很好的支持这种模式，只需要在解析之后保存cs（自动机状态），解析之前设置cs，就能从上次断点继续解析。

{% highlight c %}
#include <stdio.h>
#include <string.h>

%%{
    machine range_url;

    action rts_act {
        range_t->total_start = range_t->total_start * 10 + *fpc - '0';
    }
    action rte_act {
        range_t->total_end = range_t->total_end * 10 + *fpc - '0';
    }
    action rss_act {
        range_t->seg_start = range_t->seg_start * 10 + *fpc - '0';
    }
    action rse_act {
        range_t->seg_end = range_t->seg_end * 10 + *fpc - '0';
    }
    action url_act {
        range_t->url[range_t->url_idx] = *fpc;
        range_t->url_idx++;
    }

    CTL = (cntrl | 127);
    safe = ("$" | "-" | "_" | ".");
    extra = ("!" | "*" | "'" | "(" | ")" | ",");
    reserved = (";" | "/" | "?" | ":" | "@" | "&" | "=" | "+");
    unsafe = (CTL | " " | "\"" | "#" | "%" | "<" | ">");
    national = any -- (alpha | digit | reserved | extra | safe | unsafe);
    unreserved = (alpha | digit | safe | extra | national);
    escape = ("%" xdigit xdigit);
    uchar = (unreserved | escape);

    range_total_start = ([0-9]+ );
    range_total_end = ([0-9]+ );
    range_seg_start = ([0-9]+);
    range_seg_end = ([0-9]+);

    range_total = (range_total_start $ rts_act '-' range_total_end $ rte_act );
    range_seg = (range_seg_start $ rss_act '-' range_seg_end $ rse_act );

    scheme = ( alpha | "+" | "-" | "." )* ;
    url = (uchar | reserved )* $ url_act;

    line := range_total ':' range_seg ':' url "\n";
}%%

%%write data;

typedef struct {
    int    cs;
    off_t  total_start;
    off_t  total_end;
    off_t  seg_start;
    off_t  seg_end;
    char   url[1024];
    int    url_idx;
} range_url_t;

int parser_init(range_url_t *range_t) {

    int cs = 0;
    %%write init;

    range_t->cs = cs;            /* init */
    range_t->total_start = 0;
    range_t->total_end = 0;
    range_t->seg_start = 0;
    range_t->seg_end = 0;
    memset(range_t->url, 0, 1024);
    range_t->url_idx = 0;

    return 0;
}

void parser(char *buffer, range_url_t *range_t) {

    char *p = buffer;
    char *pe = p + strlen(buffer);

    int cs = range_t->cs;        /* set cs */
    %%write exec;

    range_t->cs = cs;             /* save cs */
}

int main() {
    char s[100] = "1000-2000:3000-4000:http://aslfjsd/skfjdks/sdf28347?p=2834&f=123abc\n";
    char s1[100];
    char s2[100];
    int i;
    range_url_t   range_t;

    for (i = 0;i<=strlen(s);i++) {
        snprintf(s1, i + 1, "%s", s);
        sprintf(s2, "%s", s+i);

        printf("==%s,%s\n",s1,s2);

        parser_init(&range_t);
        parser(s1, &range_t);
        parser(s2, &range_t);

        printf("=%ld, %ld\n", range_t.total_start, range_t.total_end);
        printf("=%ld, %ld\n", range_t.seg_start, range_t.seg_end);
        printf("=%s\n", range_t.url);
    }

    return 0;
}
{% endhighlight %}
