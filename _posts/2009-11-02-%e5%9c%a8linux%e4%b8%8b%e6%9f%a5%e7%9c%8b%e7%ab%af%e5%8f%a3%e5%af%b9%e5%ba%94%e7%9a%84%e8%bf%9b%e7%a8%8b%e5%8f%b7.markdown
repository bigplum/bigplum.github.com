--- 
wordpress_id: 673
layout: post
title: !binary |
  5ZyobGludXjkuIvmn6XnnIvnq6/lj6Plr7nlupTnmoTov5vnqIvlj7c=

excerpt: "\xE5\x9C\xA8windows\xE4\xB8\x8B\xEF\xBC\x8C\xE5\x8F\xAF\xE4\xBB\xA5\xE4\xBD\xBF\xE7\x94\xA8netstat\xE7\x9B\xB4\xE6\x8E\xA5\xE6\x9F\xA5\xE7\x9C\x8B\xE7\xAB\xAF\xE5\x8F\xA3\xE5\xAF\xB9\xE5\xBA\x94\xE7\x9A\x84\xE8\xBF\x9B\xE7\xA8\x8Bid\xEF\xBC\x8C\xE5\x8A\xA0\xE4\xB8\x8Ao\xE5\x8F\x82\xE6\x95\xB0\xE5\x8D\xB3\xE5\x8F\xAF\xEF\xBC\x9A\r\n\
  \r\n  -o            \xE6\x98\xBE\xE7\xA4\xBA\xE4\xB8\x8E\xE6\xAF\x8F\xE4\xB8\xAA\xE8\xBF\x9E\xE6\x8E\xA5\xE7\x9B\xB8\xE5\x85\xB3\xE7\x9A\x84\xE6\x89\x80\xE5\xB1\x9E\xE8\xBF\x9B\xE7\xA8\x8B ID\xE3\x80\x82\r\n\
  \r\n\
  \xE4\xBD\x86\xE6\x98\xAFlinux\xE7\x9A\x84netstat\xE6\xB2\xA1\xE6\x9C\x89\xE8\xBF\x99\xE4\xB8\xAA\xE5\x8F\x82\xE6\x95\xB0\xEF\xBC\x8C\xE5\xB0\xB1\xE7\x9C\x8B\xE4\xB8\x8D\xE5\x88\xB0\xE8\xBF\x9B\xE7\xA8\x8Bid\xE4\xBA\x86\xE3\x80\x82\xE5\x8F\xAF\xE4\xBB\xA5\xE4\xBD\xBF\xE7\x94\xA8lsof\xE5\x91\xBD\xE4\xBB\xA4\xE5\xAE\x8C\xE6\x88\x90\xE8\xBF\x99\xE4\xB8\xAA\xE5\x8A\x9F\xE8\x83\xBD\xEF\xBC\x9A\r\n\
  \r\n\
  # lsof -i\r\n\
  COMMAND    PID   USER   FD   TYPE    DEVICE SIZE NODE NAME\r\n\
  slpd      1869 daemon    6u  IPv4      4906       TCP localhost:svrloc (LISTEN)\r\n\
  slpd      1869 daemon    8u  IPv4      4908       UDP 239.255.255.253:svrloc\r\n\
  slpd      1869 daemon    9u  IPv4      4909       UDP SVRLOC.MCAST.NET:svrloc\r\n\
  portmap   1894 nobody    3u  IPv4      4999       UDP *:sunrpc\r\n\
  portmap   1894 nobody    4u  IPv4      5000       TCP *:sunrpc (LISTEN)\r\n\
  zmd       1970   root    5u  IPv4      5177       TCP *:novell-zen (LISTEN)\r\n\
  sshd      2030   root    3u  IPv6      5286       TCP *:ssh (LISTEN)\r\n\
  ntpd      2048    ntp   16u  IPv4      5349       UDP *:ntp\r\n\
  ntpd      2048    ntp   17u  IPv6      5350       UDP *:ntp\r\n\
  ntpd      2048    ntp   18u  IPv6      5352       UDP localhost:ntp"
date: 2009-11-02 16:54:56 +08:00
wordpress_url: http://blog.59trip.com/?p=673
---
在windows下，可以使用netstat直接查看端口对应的进程id，加上o参数即可：

  -o            显示与每个连接相关的所属进程 ID。

但是linux的netstat没有这个参数，就看不到进程id了。可以使用lsof命令完成这个功能：

# lsof -i
COMMAND    PID   USER   FD   TYPE    DEVICE SIZE NODE NAME
slpd      1869 daemon    6u  IPv4      4906       TCP localhost:svrloc (LISTEN)
slpd      1869 daemon    8u  IPv4      4908       UDP 239.255.255.253:svrloc
slpd      1869 daemon    9u  IPv4      4909       UDP SVRLOC.MCAST.NET:svrloc
portmap   1894 nobody    3u  IPv4      4999       UDP *:sunrpc
portmap   1894 nobody    4u  IPv4      5000       TCP *:sunrpc (LISTEN)
zmd       1970   root    5u  IPv4      5177       TCP *:novell-zen (LISTEN)
sshd      2030   root    3u  IPv6      5286       TCP *:ssh (LISTEN)
ntpd      2048    ntp   16u  IPv4      5349       UDP *:ntp
ntpd      2048    ntp   17u  IPv6      5350       UDP *:ntp
ntpd      2048    ntp   18u  IPv6      5352       UDP localhost:ntp
