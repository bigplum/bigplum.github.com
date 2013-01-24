--- 
layout: post
title: !binary |
  bmdpbnjmupDnoIHop6PmnpAoMikt6L+b56iL566h55CG
tags:
- nginx
date: 2010-11-17 10:32:01 +08:00
---

nginx中进程有这几种类型：
{% highlight c %}
#define NGX_PROCESS_SINGLE     0          //单进程
#define NGX_PROCESS_MASTER     1          //多进程中的主进程
#define NGX_PROCESS_SIGNALLER  2          //重启、刷新等管理进程
#define NGX_PROCESS_WORKER     3          //多进程中的工作进程
#define NGX_PROCESS_HELPER     4          //cache管理进程
{% endhighlight %}

可以看出nginx的工作模型主要两种，单进程和多进程。单进程一般只在测试时候使用，正式环境一般是多进程，通过配置项`work_processes`配置工作进程数。

1. 进程维护 
============
通过对POSIX信号的处理，nginx很好的支持了动态刷新配置文件和热升级，这个设计极大的提高了软件的可维护性。开发服务器端程序，可以照抄nginx的设计。

信号处理函数为`ngx_signal_handler(int signo)`，根据不同的进程类型（主要是worker和master），分别给全局变量赋值。在主循环中根据这些全局变量的值，再做不同处理。
{% highlight c %}
        case ngx_signal_value(NGX_RECONFIGURE_SIGNAL):
            ngx_reconfigure = 1;
            action = ", reconfiguring";
            break;
{% endhighlight %}

以刷新配置文件为例，master进程的主循环中如果`ngx_reconfigure`为1，则执行操作：启动新的worker，给旧的worker发信号。

`ngx_master_process_cycle(ngx_cycle_t *cycle)`
{% highlight c %}
        if (ngx_reconfigure) {
            ngx_reconfigure = 0;

            if (ngx_new_binary) {
                ngx_start_worker_processes(cycle, ccf->worker_processes,
                                           NGX_PROCESS_RESPAWN);
                ngx_start_cache_manager_processes(cycle, 0);
                ngx_noaccepting = 0;

                continue;
            }

            ngx_log_error(NGX_LOG_NOTICE, cycle->log, 0, "reconfiguring");

            cycle = ngx_init_cycle(cycle);
            if (cycle == NULL) {
                cycle = (ngx_cycle_t *) ngx_cycle;
                continue;
            }

            ngx_cycle = cycle;
            ccf = (ngx_core_conf_t *) ngx_get_conf(cycle->conf_ctx,
                                                   ngx_core_module);
            ngx_start_worker_processes(cycle, ccf->worker_processes,
                                       NGX_PROCESS_JUST_RESPAWN);
            ngx_start_cache_manager_processes(cycle, 1);
            live = 1;
            ngx_signal_worker_processes(cycle,
                                        ngx_signal_value(NGX_SHUTDOWN_SIGNAL));
        }
{% endhighlight %}

worker进程在收到NGX_SHUTDOWN_SIGNAL信号之后，关闭监听端口，并不立刻退出，而是等待当前所有会话结束之后才会退出。

`ngx_worker_process_cycle(ngx_cycle_t *cycle, void *data)`
{% highlight c %}
        if (ngx_quit) {
            ngx_quit = 0;
            ngx_log_error(NGX_LOG_NOTICE, cycle->log, 0,
                          "gracefully shutting down");
            ngx_setproctitle("worker process is shutting down");

            if (!ngx_exiting) {
                ngx_close_listening_sockets(cycle);
                ngx_exiting = 1;
            }
        }
{% endhighlight %}


2. master与worker
===============
master进程不参与具体事务处理，所有事务都由worker处理。nginx采用prefork的工作方式，预先准备好若干个worker进程直接接收连接请求，不通过master中转。即所有worker都阻塞在epoll上，来一个请求，就由其中一个进程accept，然后处理。这样就带来两个问题:

1.  如何保证多个worker之间负载均衡；
2.  如何保证不发生惊群的现象。

nginx使用了一个很轻巧的设计，在worker进程内部设置了全局变量`ngx_accept_disabled`，当`ngx_accept_disabled > 0`时，该worker才能accept请求，否则需要请求加锁才能accept。通过加锁避免了多个worker进程竞争请求，也就避免了惊群现象。

同时，如果服务器很繁忙，那么空闲的worker也较容易获得accept机会，使负载大致达到均衡。

每次accept之后，`ngx_accept_disabled`做如下更新:
{% highlight c %}
        ngx_accept_disabled = ngx_cycle->connection_n / 8
                              - ngx_cycle->free_connection_n;
{% endhighlight %}
显然当`connection_n > 8 * free_connection_n`时`ngx_accept_disabled > 0`，worker不需要加锁，也就是负载达到`1/9`时，worker就需要竞争accept了。`free_connection_n`最大值为配置项`worker_connections`。

竞争加锁机制，需要开启配置项`accept_mutex`。


3. 进程间通信
==============
master和worker之间通过socketpair创建一对描述符进行通信。创建进程和进程间通信的主要代码在文件`ngx_process_cycle.c`和`ngx_channel.c`。

保存进程信息的数据结构：

    typedef struct {
        ngx_pid_t           pid;
        int                 status;
        ngx_socket_t        channel[2]; //保存双方通信的fd, 0-父进程使用，1-子进程

        ngx_spawn_proc_pt   proc;
        void               *data;
        char               *name;

        unsigned            respawn:1;
        unsigned            just_spawn:1;
        unsigned            detached:1;
        unsigned            exiting:1;
        unsigned            exited:1;
    } ngx_process_t;

在fork完子进程后，父进程会将新进程的channel信息广播给其他已经创建的子进程。
目前进程间通信仅用于reload，upgrade, quit等场景。子进程在事件循环中作为只读事件处理消息：

    ngx_int_t
    ngx_add_channel_event(ngx_cycle_t *cycle, ngx_fd_t fd, ngx_int_t event,
        ngx_event_handler_pt handler)
    {

    ......
        rev->channel = 1;
        wev->channel = 1;

        ev = (event == NGX_READ_EVENT) ? rev : wev; //event = NGX_READ_EVENT

        ev->handler = handler;

        if (ngx_add_conn && (ngx_event_flags & NGX_USE_EPOLL_EVENT) == 0) {
    ......

