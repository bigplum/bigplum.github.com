--- 
wordpress_id: 846
layout: post
title: !binary |
  cHl0aG9u572R57uc57yW56iL5qGG5p62dHdpc3RlZOWtpuS5oOeslOiusCgy
  KQ==

excerpt: !binary |
  5o6l5LiK56+H77yM5oiR5Lus5p2l55yL55yL5oCO5LmI5YiG5Yir55SoZGVm
  ZXLlkoxyZWFjdG9y5p2l5a6e546w5ZCM5qC355qEaHR0cOWuouaIt+err+OA
  gg0KDQrov5nkuKrmmK/lrpjmlrnmlofmoaPnu5nnmoTkvovlrZDvvIzkvb/n
  lKjkuoZkZWZlcu+8mg==

date: 2010-09-14 10:45:31 +08:00
wordpress_url: http://pipa.tk/?p=846
---
接上篇，我们来看看怎么分别用defer和reactor来实现同样的http客户端。

这个是官方文档给的例子，使用了defer：
<pre class=python name=code>
from pprint import pformat

from twisted.internet import reactor
from twisted.internet.defer import Deferred
from twisted.internet.protocol import Protocol
from twisted.web.client import Agent
from twisted.web.http_headers import Headers

class BeginningPrinter(Protocol):
    def __init__(self, finished):
        self.finished = finished
        self.remaining = 1024 * 10

    def dataReceived(self, bytes):
        if self.remaining:
            display = bytes[:self.remaining]
            print 'Some data received:'
            print display
            self.remaining -= len(display)

    def connectionLost(self, reason):
        print 'Finished receiving body:', reason.getErrorMessage()
        self.finished.callback(None)

agent = Agent(reactor)
d = agent.request(
    'GET',
    'http://example.com/',
    Headers({'User-Agent': ['Twisted Web Client Example']}),
    None)

def cbRequest(response):
    print 'Response version:', response.version
    print 'Response code:', response.code
    print 'Response phrase:', response.phrase
    print 'Response headers:'
    print pformat(list(response.headers.getAllRawHeaders()))
    finished = Deferred()
    response.deliverBody(BeginningPrinter(finished))
    return finished
d.addCallback(cbRequest)

def cbShutdown(ignored):
    reactor.stop()
d.addBoth(cbShutdown)

reactor.run()
</pre>

下面是只用reactor实现的例子：
<pre class=python name=code>
from twisted.internet import protocol, reactor, defer, utils, interfaces
from twisted.web import http, client

class HTTPClient(http.HTTPClient):
    def __init__(self, fatcory):
       self._factory = fatcory

    def connectionMade(self): 
        print 'connected'
        self.sendCommand('GET', self._factory.url)
        self.sendHeader('User-Agent', 'Twisted Web Client Example')
        self.endHeaders()
        
    def handleStatus(self, version, status, message):
        print("%s %s %s\r\n" %(version, status, message))
        
    def handleHeader(self, key, val):
        print("%s: %s\r\n" %(key, val))
        
    def handleEndHeaders(self):
        print("\r\n")
        
    def rawDataReceived(self, data):
        print(data)
        
    def handleResponseEnd(self):
        reactor.stop()

class HTTPClientFactory(client.HTTPClientFactory):
    def __init__(self, url):
        client.HTTPClientFactory.__init__(self, url)
        self.url = url

    def buildProtocol(self, addr):
        return HTTPClient(self)
        
reactor.connectTCP('google.com', 80, HTTPClientFactory('/'))    
reactor.run()
</pre>

是不是比defer要清晰一点，可能也有其他场景下使用defer要更好点，但是初学可以选择从reactor入手，能更快的熟悉这个框架。
