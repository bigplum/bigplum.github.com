--- 
wordpress_id: 849
layout: post
title: !binary |
  cHl0aG9u572R57uc57yW56iL5qGG5p62dHdpc3RlZOWtpuS5oOeslOiusCgz
  KS3nlJ/kuqfogIXkuI7mtojotLnogIU=

excerpt: !binary |
  dHdpc3RlZOaPkOS+m+S6hueUn+S6p+iAheS4jua2iOi0ueiAheezu+e7n++8
  iHByb2R1Y2VyIGFuZCBjb25zdW1lcu+8ie+8jOeUqOS6juWkhOeQhuWkp+a1
  gemHj+e9kee7nOaVsOaNrua1geOAguW9k+S9oOeahOeoi+W6j+mcgOimgeS6
  p+eUn+Wkp+mHj+aVsOaNruWQjOaXtumAmui/h+e9kee7nOi+k+WHuu+8jOaI
  luiAheWBmuexu+S8vHByb3h555qE5Yqf6IO95piv77yM5bCx5YWr5oiQ6ZyA
  6KaB55So5Yiw6L+Z5Liq5Lic5Lic5LqG44CCdHdpc3RlZOaPkOS+m+eahGFw
  aeWwgeijheS6huW+iOWkmue7huiKgu+8jOeUqOi1t+adpeaMuuaWueS+v+ea
  hO+8jOS9huimgeaQnua4healmui/mOimgei0ueS4gOeVquWRqOaKmOOAgnBy
  b2R1Y2Vy55qE6K+05piO5paH5qGj5Zyo6L+Z6YeM77yaPGEgaHJlZj0iaHR0
  cDovL3R3aXN0ZWRtYXRyaXguY29tL2RvY3VtZW50cy9jdXJyZW50L2NvcmUv
  aG93dG8vcHJvZHVjZXJzLmh0bWwiPmh0dHA6Ly90d2lzdGVkbWF0cml4LmNv
  bS9kb2N1bWVudHMvY3VycmVudC9jb3JlL2hvd3RvL3Byb2R1Y2Vycy5odG1s
  PC9hPu+8jOacieWkn+eugOa0geeahOOAgg==

date: 2010-09-25 16:25:14 +08:00
wordpress_url: http://pipa.tk/?p=849
---
twisted提供了生产者与消费者系统（producer and consumer），用于处理大流量网络数据流。当你的程序需要产生大量数据同时通过网络输出，或者做类似proxy的功能是，就八成需要用到这个东东了。twisted提供的api封装了很多细节，用起来挺方便的，但要搞清楚还要费一番周折。producer的说明文档在这里：<a href="http://twistedmatrix.com/documents/current/core/howto/producers.html">http://twistedmatrix.com/documents/current/core/howto/producers.html</a>，有够简洁的。

从邮件列表里看到一个例程，这里抄袭之。
<pre class=python name=code>
"""Serve as a sample implementation of a twisted producer/consumer
system, with a simple TCP server which asks the user how many random
integers they want, and it sends the result set back to the user, one
result per line."""
import random

from zope.interface import implements
from twisted.internet import interfaces, reactor
from twisted.internet.protocol import Factory
from twisted.protocols.basic import LineReceiver

class Producer:
    """Send back the requested number of random integers to the client."""
    implements(interfaces.IPushProducer)
    def __init__(self, proto, cnt):
        self._proto = proto
        self._goal = cnt
        self._produced = 0
        self._paused = False
        
    def pauseProducing(self):
        """When we've produced data too fast, pauseProducing() will be
            called (reentrantly from within resumeProducing's transport.write
            method, most likely), so set a flag that causes production to pause
            temporarily."""
            
        self._paused = True
        print('pausing connection from %s' %
                (self._proto.transport.getPeer()))
                
    def resumeProducing(self):
        self._paused = False
        while not self._paused and self._produced < self._goal:
            next_int = random.randint(0, 10000)
            self._proto.transport.write('%d\r\n' % (next_int))
            self._produced += 1
        if self._produced == self._goal:
            self._proto.transport.unregisterProducer()
            self._proto.transport.loseConnection()
            
    def stopProducing(self):
        pass

class ServeRandom(LineReceiver):
    """Serve up random data."""
    def connectionMade(self):
        print('connection made from %s' % (self.transport.getPeer()))
        self.transport.write('how many random integers do you want?\r\n')
    def lineReceived(self, line):
        cnt = int(line.strip())
        producer = Producer(self, cnt)          #这里生成一个生产者，产生随机数
        self.transport.registerProducer(producer, True)    #将消费者与生产者连接起来，socket作为消费者
        producer.resumeProducing()
    def connectionLost(self, reason):
        print('connection lost from %s' % (self.transport.getPeer()))
        
factory = Factory()
factory.protocol = ServeRandom
reactor.listenTCP(1234, factory)
print('listening on 1234...')
reactor.run()
</pre>

当消费者遇到资源瓶颈时，Producer::pauseProducing() 和 Producer::resumeProducing() 这两个函数会被自动调用；如果消费者缓冲区满了，那么就会自动调用pauseProducing()，如果消费者能够继续处理数据，那么就调用resumeProducing()。

通过producer这个模型，可以有效利用资源，避免被缓冲区被撑爆，cpu被用光等问题。
