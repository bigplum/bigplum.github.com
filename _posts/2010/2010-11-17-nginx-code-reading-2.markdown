--- 
wordpress_id: 889
layout: post
title: !binary |
  bmdpbnjmupDnoIHop6PmnpAoMikt6L+b56iL566h55CG

excerpt: !binary |
  bmdpbnjkuK3ov5vnqIvmnInov5nlh6Dnp43nsbvlnovvvJoNCltjXQ0KI2Rl
  ZmluZSBOR1hfUFJPQ0VTU19TSU5HTEUgICAgIDAgICAgICAgICAgLy/ljZXo
  v5vnqIsNCiNkZWZpbmUgTkdYX1BST0NFU1NfTUFTVEVSICAgICAxICAgICAg
  ICAvL+Wkmui/m+eoi+S4reeahOS4u+i/m+eoiw0KI2RlZmluZSBOR1hfUFJP
  Q0VTU19TSUdOQUxMRVIgIDIgICAgICAgIC8v6YeN5ZCv44CB5Yi35paw562J
  566h55CG6L+b56iLDQojZGVmaW5lIE5HWF9QUk9DRVNTX1dPUktFUiAgICAg
  MyAgICAgICAgLy/lpJrov5vnqIvkuK3nmoTlt6XkvZzov5vnqIsNCiNkZWZp
  bmUgTkdYX1BST0NFU1NfSEVMUEVSICAgICA0ICAgICAgICAgLy9jYWNoZeeu
  oeeQhui/m+eoiw0KWy9jXQ==

date: 2010-11-17 10:32:01 +08:00
wordpress_url: http://pipa.tk/?p=889
---
nginx中进程有这几种类型：
{% highlight c %}
#define NGX_PROCESS_SINGLE     0          //单进程
#define NGX_PROCESS_MASTER     1        //多进程中的主进程
#define NGX_PROCESS_SIGNALLER  2        //重启、刷新等管理进程
#define NGX_PROCESS_WORKER     3        //多进程中的工作进程
#define NGX_PROCESS_HELPER     4         //cache管理进程
{% endhighlight %}

可以看出nginx的工作模型主要两种，单进程和多进程。单进程一般只在测试时候使用，正式环境一般是多进程，通过配置项work_processes配置工作进程数。

<strong>1. 进程维护</strong>
通过对POSIX信号的处理，nginx很好的支持了动态刷新配置文件和热升级，这个设计极大的提高了软件的可维护性，开发服务器端程序，可以照抄nginx的设计。

信号处理函数为ngx_signal_handler(int signo)，根据不同的进程类型（主要是worker和master），分别给全局变量赋值。在主循环中根据这些全局变量的值，再做不同处理。
{% highlight c %}
        case ngx_signal_value(NGX_RECONFIGURE_SIGNAL):
            ngx_reconfigure = 1;
            action = ", reconfiguring";
            break;
{% endhighlight %}

以刷新配置文件为例，master进程的主循环中如果ngx_reconfigure为1，则执行操作：启动新的worker，给旧的worker发信号。
ngx_master_process_cycle(ngx_cycle_t *cycle)：
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
ngx_worker_process_cycle(ngx_cycle_t *cycle, void *data)
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

<strong>2. master与worker</strong>
master进程不参与具体事务处理，所有事务都由worker处理。nginx采用prefork的工作方式，预先准备好若干个worker进程直接接收连接请求，不通过master中转。即所有worker都阻塞在epoll上，来一个请求，就由其中一个进程accept，然后处理。这样就带来两个问题，1、如何保证多个worker之间负载均衡；2、如何保证不发生惊群的现象。

nginx使用了一个很轻巧的设计，在worker进程内部设置了全局变量ngx_accept_disabled，当ngx_accept_disabled > 0 时，该worker才能accept请求，否则需要请求加锁才能accept。通过加锁避免了多个worker进程竞争请求，也就避免了惊群现象。

同时，如果服务器很繁忙，那么空闲的worker也较容易获得accept机会，使负载大致达到均衡。

每次accept之后，ngx_accept_disabled 做如下更新。显然当 connection_n > 8 * free_connection_n 时ngx_accept_disabled > 0，worker不需要加锁，也就是负载达到1/9时，worker就需要竞争accept了。
{% highlight c %}
        ngx_accept_disabled = ngx_cycle->connection_n / 8
                              - ngx_cycle->free_connection_n;
{% endhighlight %}

最后，竞争加锁机制，需要开启配置项accept_mutex。



