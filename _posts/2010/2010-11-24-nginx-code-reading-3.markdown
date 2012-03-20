--- 
wordpress_id: 900
layout: post
title: !binary |
  bmdpbnjmupDnoIHop6PmnpAoMykt5LuO5LqL5Lu25aSE55CG5Yiw5Lia5Yqh
  5aSE55CG

excerpt: !binary |
  5LqG6Kej5LqGbmdpbnjnmoTmqKHlnZfljJbnu5PmnoTlkozov5vnqIvlhbPn
  s7vkuYvlkI7vvIzlj6/ku6Xnn6XpgZPlnKh3b3JrZXLov5vnqIvnmoTkuLvl
  vqrnjq/ph4zpnaLvvIxuZ2lueOWunumZheS4iuWcqOW+queOr+WkhOeQhuS4
  gOS4quS4qklP5LqL5Lu277yM6YKj5LmI5YW35L2T55qE5Lia5Yqh5aSE55CG
  5qih5Z2X5piv5oCO5LmI5oyC5o6l6L+b6L+Z5Liq5qGG5p625ZGi77yf

date: 2010-11-24 09:25:45 +08:00
wordpress_url: http://pipa.tk/?p=900
---
了解了nginx的模块化结构和进程关系之后，可以知道在worker进程的主循环里面，nginx实际上在循环处理一个个IO事件，那么具体的业务处理模块是怎么挂接进这个框架呢？

以http为例，在模块初始化时，ngx_http_commands中定义了函数ngx_http_block()，该函数负责初始化http模块。
[c]
static ngx_command_t  ngx_http_commands[] = {

    { ngx_string(&quot;http&quot;),
      NGX_MAIN_CONF|NGX_CONF_BLOCK|NGX_CONF_NOARGS,
      ngx_http_block,
      0,
      0,
      NULL },

      ngx_null_command
};
[/c]

同时，ngx_http_block将ngx_http_init_connection()函数挂接进 ngx_listening_s 的handler。 这个handler在event模块执行accept之后被调用。
[c]
struct ngx_listening_s {
    ngx_socket_t        fd;

    struct sockaddr    *sockaddr;
    socklen_t           socklen;    /* size of sockaddr */
    size_t              addr_text_max_len;
    ngx_str_t           addr_text;

    int                 type;

    int                 backlog;
    int                 rcvbuf;
    int                 sndbuf;

    /* handler of accepted connection */
    ngx_connection_handler_pt   handler;  
[/c]

整个流程见下图：
<a href="/assets/uploads/2010/11/nginx_http_init.jpg"><img src="/assets/uploads/2010/11/nginx_http_init.jpg" alt="nginx_http_init" title="nginx_http_init" width="1021" height="354" class="alignnone size-full wp-image-901" /></a>
