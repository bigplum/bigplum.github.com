--- 
wordpress_id: 1046
layout: post
title: !binary |
  UmFnZWzop6PmnpDmtYHlvI8oc3RyZWFtKeaVsOaNrg==

date: 2011-11-10 09:48:41 +08:00
wordpress_url: http://pipa.tk/?p=1046
---
Ragel是一个状态机代码生成器，支持多种语言C, C++, Objective-C, D, Java, Ruby。一般用来写正则表达式解析协议数据，然后编译成相应代码嵌入到其他语言中。

<a href="http://www.complang.org/ragel/">Ragel</a>的介绍和入门可以看这里：<a href="http://blog.dccmx.com/2011/01/ragel-intro-1/">http://blog.dccmx.com/2011/01/ragel-intro-1/</a>
解析http头的例子可以看这里：<a href="http://yaoweibin2008.blog.163.com/blog/static/110313920098211472956/">http://yaoweibin2008.blog.163.com/blog/static/110313920098211472956/</a>，下面的例子抄了部分URL的定义。

所谓流式解析就是限制buffer使用，保持内存为一个常量。例如，要解析4k的数据，如果不使用流式解析，就必须申请4k的buffer。如果使用流式解析，可以每次读取1k数据，解析之后丢弃掉。

Ragel很好的支持这种模式，只需要在解析之后保存cs（自动机状态），解析之前设置cs，就能从上次断点继续解析。

[c]
#include &lt;stdio.h&gt;
#include &lt;string.h&gt;

%%{
    machine range_url;

    action rts_act {
        range_t-&gt;total_start = range_t-&gt;total_start * 10 + *fpc - '0';
    }
    action rte_act {
        range_t-&gt;total_end = range_t-&gt;total_end * 10 + *fpc - '0';
    }
    action rss_act {
        range_t-&gt;seg_start = range_t-&gt;seg_start * 10 + *fpc - '0';
    }
    action rse_act {
        range_t-&gt;seg_end = range_t-&gt;seg_end * 10 + *fpc - '0';
    }
    action url_act {
        range_t-&gt;url[range_t-&gt;url_idx] = *fpc;
        range_t-&gt;url_idx++;
    }

    CTL = (cntrl | 127);
    safe = (&quot;$&quot; | &quot;-&quot; | &quot;_&quot; | &quot;.&quot;);
    extra = (&quot;!&quot; | &quot;*&quot; | &quot;'&quot; | &quot;(&quot; | &quot;)&quot; | &quot;,&quot;);
    reserved = (&quot;;&quot; | &quot;/&quot; | &quot;?&quot; | &quot;:&quot; | &quot;@&quot; | &quot;&amp;&quot; | &quot;=&quot; | &quot;+&quot;);
    unsafe = (CTL | &quot; &quot; | &quot;\&quot;&quot; | &quot;#&quot; | &quot;%&quot; | &quot;&lt;&quot; | &quot;&gt;&quot;);
    national = any -- (alpha | digit | reserved | extra | safe | unsafe);
    unreserved = (alpha | digit | safe | extra | national);
    escape = (&quot;%&quot; xdigit xdigit);
    uchar = (unreserved | escape);

    range_total_start = ([0-9]+ );
    range_total_end = ([0-9]+ );
    range_seg_start = ([0-9]+);
    range_seg_end = ([0-9]+);

    range_total = (range_total_start $ rts_act '-' range_total_end $ rte_act ); 
    range_seg = (range_seg_start $ rss_act '-' range_seg_end $ rse_act );

    scheme = ( alpha | &quot;+&quot; | &quot;-&quot; | &quot;.&quot; )* ;
    url = (uchar | reserved )* $ url_act;

    line := range_total ':' range_seg ':' url &quot;\n&quot;;
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

    range_t-&gt;cs = cs;            /* init */
    range_t-&gt;total_start = 0;
    range_t-&gt;total_end = 0;
    range_t-&gt;seg_start = 0;
    range_t-&gt;seg_end = 0;
    memset(range_t-&gt;url, 0, 1024);
    range_t-&gt;url_idx = 0;

    return 0;
}


void parser(char *buffer, range_url_t *range_t) {

    char *p = buffer;
    char *pe = p + strlen(buffer);

    int cs = range_t-&gt;cs;        /* set cs */
    %%write exec;

    range_t-&gt;cs = cs;             /* save cs */
}


int main() {
    char s[100] = &quot;1000-2000:3000-4000:http://aslfjsd/skfjdks/sdf28347?p=2834&amp;f=123abc\n&quot;;
    char s1[100];
    char s2[100];
    int i;
    range_url_t   range_t;

    for (i = 0;i&lt;=strlen(s);i++) {
        snprintf(s1, i + 1, &quot;%s&quot;, s);
        sprintf(s2, &quot;%s&quot;, s+i);

        printf(&quot;==%s,%s\n&quot;,s1,s2);

        parser_init(&amp;range_t);
        parser(s1, &amp;range_t);
        parser(s2, &amp;range_t);

        printf(&quot;=%ld, %ld\n&quot;, range_t.total_start, range_t.total_end);
        printf(&quot;=%ld, %ld\n&quot;, range_t.seg_start, range_t.seg_end);
        printf(&quot;=%s\n&quot;, range_t.url);
    }

    return 0;
}

[/c]
