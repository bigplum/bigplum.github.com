--- 
wordpress_id: 42
layout: post
title: !binary |
  5aaC5L2V5pW05ZCIZGlzY3V6IeiuuuWdm+WIsOWFtuS7luezu+e7n+S4rQ==

date: 2009-06-03 13:11:21 +08:00
wordpress_url: http://www.xenhome.co.cc/blog/?p=42
---
论坛是一个商业网站必不可少的部分，网上有很多开源的论坛系统，discuz!就是一个很成熟的功能强大的系统。因此如何将论坛整合到原有的商业系统中就是一个必要的步骤。

本文只考虑discuz!论坛独立部署的情况，不和ucenter、uchome进行用户数据同步。由于dicuz!论坛安装必须使用ucenter，所以就下载了一个完全版本<a href="http://www.comsenz.com/downloads/install#">Discuz! 7.0.0_FULL</a>，自动包含了ucenter。<!--more-->

discuz!用户注册、登陆管理采用了cookie和服务器端sessioin相结合的原理。用户注册时discuz!会在数据库的表cdb_members和cdb_memberfields插入两条新纪录，作为该用户数据。
在用户登陆成功后，discuz!在客户端写入cookie:cookietime, auth, sid，作为客户端鉴权使用；在服务器端，discuz!为该用户在表cdb_sessions插入一条会话记录。

因此，若需要将原系统的用户数据整合到discuz!中，只需要编写一个脚本，将原系统的uid、username、email等信息插入到discuz!的表中，并且为用户填入cookie值，更新session信息即可。

<strong>更新数据库：</strong>
$db->query("INSERT INTO {$tablepre}members (uid, username, password, secques, adminid, groupid, regip, regdate, lastvisit, lastactivity, posts, email, showemail, timeoffset, pmsound, invisible, newsletter)
	VALUES ('$uid', '$username', '$password', '$secques', '0', '$groupinfo[groupid]', '$onlineip', '$timestamp', '$timestamp', '$timestamp', '0', '$email', '0', '9999', '1', '$invisiblenew', '1')");
$db->query("INSERT  INTO {$tablepre}memberfields (uid) VALUES ('$uid')");

<strong>填写cookie函数：</strong>
dsetcookie('cookietime', $cookietime, 31536000);
dsetcookie('auth', authcode("$discuz_pw\t$discuz_secques\t$discuz_uid", 'ENCODE'), $cookietime, 1, true);
dsetcookie('loginuser');
dsetcookie('activationauth');
dsetcookie('pmnum');

<strong>更新session函数：</strong>
updatesession();
