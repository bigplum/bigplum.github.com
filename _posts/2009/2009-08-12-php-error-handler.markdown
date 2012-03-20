--- 
wordpress_id: 507
layout: post
title: !binary |
  cGhw5Lit55qE6ZSZ6K+v5aSE55CG5Ye95pWw

excerpt: !binary |
  cGhw5Lit6Zmk5LqG5bi46KeB55qEdHJ5L2NhdGNo77yMZXJyb3JfcmVwb3J0
  aW5nKCnkuYvlpJbvvIzov5jmj5DkvpvkuoZzZXRfZXJyb3JfaGFuZGxlcigp
  5Ye95pWw55So5LqO6Ieq5a6a5LmJ6ZSZ6K+v5aSE55CG5Ye95pWw44CCDQoN
  CnBocOm7mOiupOeahOmUmeivr+WkhOeQhuaYr+ebtOaOpeWcqOmhtemdouS4
  iuaJk+WNsOmUmeivr+S/oeaBr++8jOS+i+Wmgu+8mg0KDQpXYXJuaW5nOiBt
  a2RpcigpIFtmdW5jdGlvbi5ta2Rpcl06IFBlcm1pc3Npb24gZGVuaWVkIGlu
  IC91c3IvbG9jYWwvbGlnaHQvaHRkb2NzL2EucGhwIG9uIGxpbmUgMg0KV2Fy
  bmluZzogY2hkaXIoKSBbZnVuY3Rpb24uY2hkaXJdOiBObyBzdWNoIGZpbGUg
  b3IgZGlyZWN0b3J5IChlcnJubyAyKSBpbiAvdXNyL2xvY2FsL2xpZ2h0L2h0
  ZG9jcy9kLnBocCBvbiBsaW5lIDMwDQoNCuiAjOS4iui/sOeahOi/lOWbnuS/
  oeaBr+aYr+S7pTIwMOeahGh0dHAgY29kZei/lOWbnueahO+8jOi/meagt+Ww
  see7mVJFU1RmdWzlupTnlKjluKbmnaXlm7DmibDjgILpgJrov4dzZXRfZXJy
  b3JfaGFuZGxlcuWPr+S7peW+iOWlveeahOino+WGs+i/meS4qumXrumimO+8
  jOaNleaNieaJgOaciemUmeivr++8jOeEtuWQjuWvueS6juS4pemHjeeahOmU
  meivr+e7meWHujUwMOeahGh0dHDov5Tlm57noIHvvIzmjIfnpLrlrqLmiLfn
  q6/lgZrlh7rnm7jlupTnmoTlk43lupTjgII=

date: 2009-08-12 16:15:48 +08:00
wordpress_url: http://blog.59trip.com/?p=507
---
php中除了常见的try/catch，error_reporting()之外，还提供了set_error_handler()函数用于自定义错误处理函数。

php默认的错误处理是直接在页面上打印错误信息，例如：

Warning: mkdir() [function.mkdir]: Permission denied in /usr/local/light/htdocs/a.php on line 2
Warning: chdir() [function.chdir]: No such file or directory (errno 2) in /usr/local/light/htdocs/d.php on line 30

而上述的返回信息是以200的http code返回的，这样就给RESTful应用带来困扰。通过set_error_handler可以很好的解决这个问题，捕捉所有错误，然后对于严重的错误给出500的http返回码，指示客户端做出相应的响应。
<!--more-->
<pre class=php name=code>
function ErrorHandler($errno, $errstr, $errfile, $errline) {
    switch($errno){
        case E_ERROR:               $err = "Error";                  break;
        case E_WARNING:             $err = "Warning";                break;
        case E_CORE_ERROR:          $err = "Core Error";             break;
        case E_USER_ERROR:          $err = "User Error";             break;
        case E_COMPILE_ERROR:       $err = "Compile Error";          break;
        case E_PARSE:               $err = "Parse Error";            break;
        
        case E_NOTICE:              $err = "Notice";                 
        case E_CORE_WARNING:        $err = "Core Warning";           
        case E_COMPILE_WARNING:     $err = "Compile Warning";        
        case E_USER_WARNING:        $err = "User Warning";           
        case E_USER_NOTICE:         $err = "User Notice";            
        case E_STRICT:              $err = "Strict Notice";          
        case E_RECOVERABLE_ERROR:   $err = "Recoverable Error";      
        default:                    $err = "Unknown error ($errno)"; 
        return true;
    }
    header("HTTP/1.1 500 Internal Server Error");
    echo 'Internal Server Error: '."$errno:$err".'<br/>'; 
    echo 'msg: '.$errstr.'<br/>';  
    runlog("catch error($errno:$err:$errstr), $errfile:$errline");
    die();
}
set_error_handler("ErrorHandler");</pre>

参考：<a href="http://www.i1981.com/blog/article.asp?id=298">http://www.i1981.com/blog/article.asp?id=298</a>
