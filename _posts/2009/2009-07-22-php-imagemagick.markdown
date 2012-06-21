--- 
layout: post
title: !binary |
  cGhw5Lit6LCD55So5Zu+5YOP5aSE55CG5Ye95pWw5bqTSW1hZ2VNYWdpY2s=

excerpt: !binary |
  PGEgaHJlZj0iaHR0cDovL3d3dy5pbWFnZW1hZ2ljay5vcmciPkltYWdlTWFn
  aWNrPC9hPuaYr+S4gOS4quW8gOa6kOeahOWbvuWDj+WkhOeQhuWHveaVsOW6
  k++8jOaUr+aMgeW+iOWkmuivreiogO+8m+WPr+iDveS6uuS7rOavlOi+g+eG
  n+aCiUdE5bqT77yMSW1hZ2VNYWdpY2vnmoTov5DooYzpgJ/luqbmr5RHROW/
  q++8jOW5tuS4lOaUr+aMgeabtOWkmueahOWbvuWDj+WkhOeQhuWKn+iDveOA
  guWcqGxpbnV45LiK5a6J6KOF5L2/55So77yM6K+35Y+C6ICD77yaPGEgaHJl
  Zj0iaHR0cDovL3dhcC5saXR0ei5jbi92aWV3bmV3cy5waHA/aXRlbWlkPTMz
  NiI+aHR0cDovL3dhcC5saXR0ei5jbi92aWV3bmV3cy5waHA/aXRlbWlkPTMz
  NjwvYT4NCg0KPHN0cm9uZz4xLiDkvb/nlKhJbWFnZU1hZ2lja+WOi+e8qWpw
  Zzwvc3Ryb25nPg0K5rOo5oSP5LiA5a6a6KaB5L2/55SoPHN0cm9uZz5zZXRJ
  bWFnZUNvbXByZXNzaW9u44CBc2V0SW1hZ2VDb21wcmVzc2lvblF1YWxpdHk8
  L3N0cm9uZz7vvIzkuI3og73kvb/nlKhzZXRDb21wcmVzc2lvbuOAgXNldENv
  bXByZXNzaW9uUXVhbGl0eeOAgueglOeptuS6huWNiuWkqei/meS4pOS4quWH
  veaVsO+8jOS4jeefpemBk+S4uuS7gOS5iOS4jeiDveeUqO+8jOWumOaWueaW
  h+aho+S5n+ayoeS4quivtOaYjuOAgg==

date: 2009-07-22 13:32:27 +08:00
---
<a href="http://www.imagemagick.org">ImageMagick</a>是一个开源的图像处理函数库，支持很多语言；可能人们比较熟悉GD库，ImageMagick的运行速度比GD快，并且支持更多的图像处理功能。在linux上安装使用，请参考：<a href="http://wap.littz.cn/viewnews.php?itemid=336">http://wap.littz.cn/viewnews.php?itemid=336</a>

<strong>1. 使用ImageMagick压缩jpg</strong>
注意一定要使用<strong>setImageCompression、setImageCompressionQuality</strong>，不能使用setCompression、setCompressionQuality。研究了半天这两个函数，不知道为什么不能用，官方文档也没个说明。
<pre class=php name=code>$img1 = new Imagick('test.jpg');
$img1->setImageCompression(Imagick::COMPRESSION_JPEG);
$img1->setImageCompressionQuality(40);
$img1->writeImage('1.jpg');</pre>
<!--more-->
<strong>2. 调整图像大小，生成缩略图</strong>
<pre class=php name=code>$thumb = new Imagick('test.jpg');
$thumb->thumbnailImage($ftow, $ftoh, true);
$thumb->writeImage('1.jpg');</pre>
<strong>3. 调整图像大小，保留EXIF信息</strong>
<pre class=php name=code>$thumb = new Imagick('test.jpg');
$thumb->scaleImage($ftow, $ftoh);
$thumb->writeImage('1.jpg');</pre>
<strong>4. 转换图片格式</strong>
format信息可以从这里查到：<a href="http://www.imagemagick.org/script/formats.php">http://www.imagemagick.org/script/formats.php</a>
<pre class=php name=code>$img = new Imagick('test.jpg');
$img->setImageFormat( "png" );
$img->writeImage('1.png');</pre>
<strong>5. 生成gif动画的缩略图</strong>
请参考：<a href="http://wxw850227.javaeye.com/blog/402085#comments">imagick 处理 gif 切割 或者是 缩放</a>
<strong>
附录：</strong>
EXIF（Exchangeable image file format）是可交换图像文件的缩写，是专门为数码相机的照片设定的，可以记录数码照片的属性信息和拍摄数据。EXIF最初由日本电子工业发展协会在1996年制定，版本为1.0。1998年，升级到2.1，增加了对音频文件的支持。2002年3月，发表了2.2版。EXIF可以附加于JPEG、TIFF、RIFF等文件之中，为其增加有关数码相机拍摄信息的内容和索引图或图像处理软件的版本信息。

EXIF中包含的图像方向信息：
 <a href="http://sylvana.net/jpegcrop/exif_orientation.html">http://sylvana.net/jpegcrop/exif_orientation.html</a>
 <a href="http://www.php.net/manual/en/imagick.constants.php#imagick.constants.orientation">http://www.php.net/manual/en/imagick.constants.php#imagick.constants.orientation</a>
 <a href="http://www.php.net/manual/en/function.imagick-getimageorientation.php">http://www.php.net/manual/en/function.imagick-getimageorientation.php</a>
