--- 
wordpress_id: 329
layout: post
title: !binary |
  bGludXggc2hlbGznu5/orqHnvZHnq5nml6Xlv5fnmoTni6znq4tpcOaVsA==

excerpt: !binary |
  57uf6K6h5pel5b+X5Lit54us56uLaXDmlbDvvIznlKhhd2vlvojlrrnmmJPm
  kJ7lrprvvJoNCg0KYXdrICd7aXBbJDFdKz0xfSBFTkR7Zm9yKGkgaW4gaXAp
  IHtwcmludCBpLCIgICIgaXBbaV19fScgYWNjZXNzLmxvZ3x3YyAtbA0KDQrl
  hbbkuK1pcOS4umF3a+S4reeahOaVsOe7hO+8jCQx5L2c5Li65pWw57uE5LiL
  5qCH77yM55u45ZCMaXDlsLHntK/orqHliLDlkIzkuIDkuKrlhYPntKDkuK3v
  vIzlvojnroDljZXlkKfjgIINCg0K5aaC5p6c5oOz57uf6K6h6K6/6Zeu5oiQ
  5Yqf55qEaXDmlbDvvIzlsLHlnKjliY3pnaLov4fmu6TkuIDkuIvljbPlj6/v
  vJoNCg0KYXdrICd7aWYgKCQxMD09MjAwKSBwcmludCAkMX0nIGFjY2Vzcy5s
  b2d8YXdrICd7aXBbJDFdKz0xfSBFTkR7Zm9yKGkgaW4gaXApIHtwcmludCBp
  LCIgICIgaXBbaV19fSd8d2MgLWw=

date: 2009-07-17 08:26:41 +08:00
wordpress_url: http://blog.59trip.com/?p=329
---
统计日志中独立ip数，用awk很容易搞定：

awk '{ip[$1]+=1} END{for(i in ip) {print i,"  " ip[i]}}' access.log|wc -l

其中ip为awk中的数组，$1作为数组下标，相同ip就累计到同一个元素中，很简单吧。

如果想统计访问成功的ip数，就在前面过滤一下即可：

awk '{if ($10==200) print $1}' access.log|awk '{ip[$1]+=1} END{for(i in ip) {print i,"  " ip[i]}}'|wc -l

其中$10为http请求的返回码，不同的accesslog格式，位置有可能不同，需要修改。
