--- 
wordpress_id: 71
layout: post
title: !binary |
  cGhwIGN1cmznmoRDVVJMT1BUX1dSSVRFRlVOQ1RJT07lj4LmlbDkvb/nlKg=

excerpt: !binary |
  Y3VybOW6k+aYr+S4gOS4quW8uuWkp+eahGh0dHDljY/orq7mk43kvZzlupPv
  vIzlj6/ku6Xmlrnkvr/nmoTmnoTpgKBodHRw6K+35rGC77yM5bm26I635Y+W
  6L+U5Zue77yM5LiL6L295paH5Lu2562J44CC5pSv5oyBcGhw44CBY+OAgXB5
  dGhvbuOAgeWRveS7pOihjOetieWkmuenjeaOpeWPo+OAgg0KDQrlnKhwaHDk
  uK3vvIzkvb/nlKhjdXJs5LiL6L295paH5Lu277yM6Zmk5LqGQ1VSTE9QVF9G
  SUxF5Y+C5pWw77yM55u05o6l5bCG5paH5Lu26L6T5Ye65YiwZnDlr7nkuo7n
  moTmlofku7bkuK3lpJbvvJoNCjxwcmUgY2xhc3M9ImNvZGUiIG5hbWU9InBo
  cCI+Y3VybF9zZXRvcHQoJGNoLCBDVVJMT1BUX0ZJTEUsICRmcCk7PC9wcmU+
  DQrov5jlj6/ku6Xkvb/nlKhDVVJMT1BUX1dSSVRFRlVOQ1RJT07vvIzlrprk
  uYnlm57osIPlh73mlbDvvIzlr7nov5Tlm57nmoTmlofku7bov5vooYzov5vk
  uIDmraXlpITnkIY=

date: 2009-06-09 20:22:54 +08:00
wordpress_url: http://blog.59trip.com/?p=71
---
curl库是一个强大的http协议操作库，可以方便的构造http请求，并获取返回，下载文件等。支持php、c、python、命令行等多种接口。

在php中，使用curl下载文件，除了CURLOPT_FILE参数，直接将文件输出到fp对于的文件中外：
<pre class="php" name="code">curl_setopt($ch, CURLOPT_FILE, $fp);</pre>
还可以使用CURLOPT_WRITEFUNCTION，定义回调函数，对返回的文件进行进一步处理。<!--more-->
curl_setopt($ch, CURLOPT_WRITEFUNCTION, "call_func");
call_func有两个参数$ch, $out，$ch为curl的操作句柄，$out为下载的文件片段（分片大小一般为1500个字节）,例程如下，完成了写入文件，并且输出到浏览器的功能。
<pre class="php" name="code">
$echolen = 0;
function call_func($ch, $out) {
    global $fp,$echolen, $basename;
    $len = fwrite($fp,$out); 
    
    if(!$echolen) {       //首先需要输出http header，指示文件类型给浏览器识别
        send_header($basename);
    }
    $echolen = $len;
    echo $out;
    return $echolen;     
}
</pre>
