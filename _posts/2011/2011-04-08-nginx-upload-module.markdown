--- 
layout: post
title: !binary |
  bmdpbnjnmoTmlq3ngrnkuIrkvKDmqKHlnZc=

date: 2011-04-08 15:54:58 +08:00
---
总所周知，http文件上传是不支持断点续传的，为了支持断点续传，需要自定义协议，同时修改HTTP服务器和客户端来支持。通常做法是在浏览器上开发插件支持的。

<a href="http://www.grid.net.ru/nginx/upload.en.html">nginx upload module</a>对http协议做了一个<a href="http://www.grid.net.ru/nginx/resumable_uploads.en.html#2.3">简单扩展</a>，叫做Resumable uploads over HTTP，根据这个协议，做个客户端就能很好的配合这个插件使用。

协议很简单，在上传的header中增加下面几个参数，服务器会根据header指示将分片写入临时文件中；等整个文件上传完成后，服务器将整个文件再传递给后端服务器处理。
[shell]
Content-Disposition	#attachment, filename="name of the file being uploaded"
Content-Type	#mime type of a file being uploaded (must not be multipart/form-data);
X-Content-Range or Content-Range	#byte range of a segment being uploaded;
X-Session-ID or Session-ID	#identifier of a session of a file being uploaded (see 2.3);
[/shell]

用curl模拟了一次上传过程，结果如下：
[shell]
# curl localhost:8081/upload/ -d abc -H "Content-Type: text/xml" -H "Content-Disposition: attachment; filename=big.TXT" -H "X-Content-Range: bytes 100-102/511920" -H "Session-ID: 1111215056" -v

* About to connect() to localhost port 8081 (#0)
*   Trying 127.0.0.1... connected
* Connected to localhost (127.0.0.1) port 8081 (#0)
> POST /upload/ HTTP/1.1
> User-Agent: curl/7.21.3 (i686-pc-linux-gnu) libcurl/7.21.3 zlib/1.2.3
> Host: localhost:8081
> Accept: */*
> Content-Type: text/xml
> Content-Disposition: attachment; filename=big.TXT
> X-Content-Range: bytes 100-102/511920
> Session-ID: 1111215056
> Content-Length: 3
>
< HTTP/1.1 201 Created    #表示文件分片创建成功，整个文件上传成功后返回200
< Server: nginx/0.8.53
< Date: Fri, 08 Apr 2011 07:38:53 GMT
< Content-Length: 36
< Connection: close
< Range: 0-2/511920,6-8/511920,100-102/511920    #表示服务器已经接收到的分片
<
* Closing connection #0
[/shell]
