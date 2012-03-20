--- 
wordpress_id: 315
layout: post
title: !binary |
  SmF2YXNjcmlwdCBzbGVlcOWHveaVsOeahOaooeaLn+WunueOsA==

excerpt: !binary |
  5YGaZmlyZWZveOeahOW8gOW/g+e9keaPkuS7tueisOWIsOS4qumXrumimO+8
  jOaDs+WcqOWBt+iPnOaXtuWAmXNsZWVw5Yeg56eS77yM5qih5ouf5Lq65bel
  5pON5L2c77yM5YWN5b6X6KKr5pyN5Yqh5Zmo6K6k5Li65piv5aSW5oyC44CC
  5L2G5pivamF2YXNjcmlwdOayoeaciXNsZWVw6L+Z5Liq5Ye95pWw77yM6ZyA
  6KaB5omL5bel5qih5ouf5a6e546w44CCDQoNCuWcqOe9keS4iuaJvuS6huS4
  gOS4i++8jOWfuuacrOacieS7peS4i+S4pOenjeaWueahiO+8mg0KMS4g5b6q
  546v5Yik5pat5pe26Ze077yM5ruh6Laz5p2h5Lu25YiZ6Lez5Ye65b6q546v
  DQo8cHJlIGNsYXNzPWphdmFzY3JpcHQgbmFtZT1jb2RlPmZ1bmN0aW9uICAg
  c2xlZXAobil7DQogICAgdmFyIHN0YXJ0PW5ldyBEYXRlKCkuZ2V0VGltZSgp
  Ow0KICAgIHdoaWxlKHRydWUpICAgDQogICAgICAgIGlmKG5ldyBEYXRlKCku
  Z2V0VGltZSgpLXN0YXJ0Pm4pICAgDQogICAgICAgICAgICBicmVhazsNCn08
  L3ByZT4=

date: 2009-07-15 08:30:57 +08:00
wordpress_url: http://blog.59trip.com/?p=315
---
做firefox的开心网插件碰到个问题，想在偷菜时候sleep几秒，模拟人工操作，免得被服务器认为是外挂。但是javascript没有sleep这个函数，需要手工模拟实现。

在网上找了一下，基本有以下两种方案：
1. 循环判断时间，满足条件则跳出循环
<pre class="javascript" name=code>function   sleep(n){
    var start=new Date().getTime();
    while(true)
        if(new Date().getTime()-start&gt;n)
            break;
}</pre>
由于循环判断很占用CPU，甚至会导致浏览器崩溃，所以<a href="http://topic.csdn.net/t/20060303/22/4591744.html">这里</a>又有人提出了用xmlhttprequest的同步调用，来实现sleep的功能，我试了一下CPU占用率还是挺高，效果不太理想。
<!--more-->
<pre class="javascript" name=code>function   sleep(num){
    var tempDate=new Date();
    var theXmlHttp=ActiveXObject("Microsoft.XMLHTTP");
    while((new Date()-tempDate)< num){
        try{
            theXmlHttp.open("get","http://www.google.com/JK.asp?JK="+Math.random(),false);
            theXmlHttp.send();
        }
        catch(e){;}
    }
    return;
}</pre>  

2. 使用setTimeout函数模拟，可以几乎不占用CPU
<pre class="javascript" name=code>function Sleep(obj,iMinSecond){
    if (window.eventList==null)
    window.eventList=new Array();
    var ind=-1;
    for (var i=0;i< window.eventList.length;i++){
        if (window.eventList[i]==null){
            window.eventList[i]=obj;
            ind=i;
            break;
        }
    }
    if (ind==-1){
        ind=window.eventList.length;
        window.eventList[ind]=obj;
    }
    setTimeout("GoOn(" + ind + ")",iMinSecond);
}
function GoOn(ind){
    var obj=window.eventList[ind];
    window.eventList[ind]=null;
    if (obj.NextStep) obj.NextStep();
    else obj();
}

function Test(){
    for(var i=0;i<10;i++){
        Sleep(this,i*3000);
        this.NextStep=function()
        {
            alert("continue"+i);
        }
    }
}</pre>  
但是使用setTimeout存在一个问题，就是无法动态的实现sleep功能。如上面的Test()函数，我们预期的效果是得到从0到9的是个数字，但实际的运行结果是10个10；猜想这是由于Javascript解释器在解释完所有脚本之后才开始执行alert函数，这时i的值已经变成10了。

还没想到好的sleep方法，开心农场的插件开发推迟中。
