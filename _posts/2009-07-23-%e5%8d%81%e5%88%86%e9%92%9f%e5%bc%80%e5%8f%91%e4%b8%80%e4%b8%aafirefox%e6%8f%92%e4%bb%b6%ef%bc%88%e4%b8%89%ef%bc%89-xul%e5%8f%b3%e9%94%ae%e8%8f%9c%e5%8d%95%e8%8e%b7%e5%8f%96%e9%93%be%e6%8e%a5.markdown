--- 
wordpress_id: 393
layout: post
title: !binary |
  5Y2B5YiG6ZKf5byA5Y+R5LiA5LiqZmlyZWZveOaPkuS7tu+8iOS4ie+8iS0g
  eHVs5Y+z6ZSu6I+c5Y2V6I635Y+W6ZO+5o6l5Zyw5Z2A

excerpt: !binary |
  5ZyoZmlyZWZveOS4reW+iOWuueaYk+WwseiDveeUqHh1bOWunueOsOS4gOS4
  quexu+S8vOS4i+i9veW3peWFt+WPs+mUruiPnOWNleiOt+WPlumTvuaOpeWc
  sOWdgOeahOWKn+iDveOAguS+i+WmgmZsYXNoZ2905o+S5Lu255qE4oCc5LiL
  6L295q2k6ZO+5o6l4oCd5Yqf6IO977yaDQo8YSBocmVmPSJodHRwOi8vYmxv
  Zy41OXRyaXAuY29tL3dwLWNvbnRlbnQvdXBsb2Fkcy8yMDA5LzA3L3JpZ2h0
  X2NsaWNrLmpwZyI+PGltZyBjbGFzcz0iYWxpZ25ub25lIHNpemUtbWVkaXVt
  IHdwLWltYWdlLTM5NyIgdGl0bGU9InJpZ2h0X2NsaWNrIiBzcmM9Imh0dHA6
  Ly9ibG9nLjU5dHJpcC5jb20vd3AtY29udGVudC91cGxvYWRzLzIwMDkvMDcv
  cmlnaHRfY2xpY2stMjQ4eDMwMC5qcGciIGFsdD0icmlnaHRfY2xpY2siIHdp
  ZHRoPSIyNDgiIGhlaWdodD0iMzAwIiAvPjwvYT4NCg0K6aaW5YWI5L2/55So
  eHVs5a6a5LmJ5Y+z6ZSu6I+c5Y2V77yM5YW25LitcG9wdXDnmoRpZOW/hemh
  u+S4umNvbnRlbnRBcmVhQ29udGV4dE1lbnXjgIJkb2N1bWVudC5wb3B1cE5v
  ZGXkuLrpvKDmoIflvZPliY3ojrflj5bnmoTljLrln5/lr7nosaHjgII=

date: 2009-07-23 19:38:06 +08:00
wordpress_url: http://blog.59trip.com/?p=393
---
在firefox中很容易就能用xul实现一个类似下载工具右键菜单获取链接地址的功能。例如flashgot插件的“下载此链接”功能：
<!--more-->
<a href="http://pipablog.tk/wp-content/uploads/2009/07/right_click.jpg"><img class="alignnone size-medium wp-image-397" title="right_click" src="http://pipablog.tk/wp-content/uploads/2009/07/right_click-248x300.jpg" alt="right_click" width="248" height="300" /></a>

首先使用xul定义右键菜单，其中popup的id必须为contentAreaContextMenu。document.popupNode为鼠标当前获取的区域对象。
<pre class=xml name=code>
&lt;popup id="contentAreaContextMenu"&gt;
&lt;menuitem id="1234" oncommand="kaixin.click(document.popupNode);" label="Login" image="chrome://kaixin/skin/login.png" accesskey="d"/&gt;
&lt;/popup&gt;
</pre>

document.popupNode有可能返回anchor元素里的span等其他文本元素，所以需要判断一下，才能获取到anchor元素的链接地址：
<pre class=xml name=code> 
click:function(_node){
    while(_node&amp;&amp;_node.nodeType==Node.ELEMENT_NODE) {
        if(_node.href){
        alert(_node.href);
        break;
    }
    _node=_node.parentNode;
}
</pre>

附录，popupNode的参考资料：
<a href="https://developer.mozilla.org/en/DOM/document.popupNode">https://developer.mozilla.org/en/DOM/document.popupNode</a>
<a href="http://www-archive.mozilla.org/xpfe/xptoolkit/popups.html">http://www-archive.mozilla.org/xpfe/xptoolkit/popups.html</a>
右键菜单：
<a href="https://developer.mozilla.org/en/XUL/PopupGuide/Extensions">https://developer.mozilla.org/en/XUL/PopupGuide/Extensions</a>
