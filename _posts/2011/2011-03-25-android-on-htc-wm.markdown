--- 
layout: post
title: !binary |
  5ZyoSFRD55qEV03miYvmnLrkuIrlronoo4VBbmRyb2lk

date: 2011-03-25 11:29:17 +08:00
---
=====3.31更新=====
增加2.2更新：FRX06_Full_Bundle_25.3.2011.zip  （未分区版，可以直接解压拷贝到sd卡根目录使用，不用分区格式化。）

这两天又在touch pro上体验了一下android系统，感觉比3个月前有了挺大的进步，支持摄像头，操作也相对流畅了一些，但是电源管理还没有改进，gprs也不太稳定。

把几个需要的包上传到dbank，方便国内的朋友下载。
支持下列手机使用：
HTC Diamond（S910W、P3700、S900）
HTC Raphael（Touch Pro、Fuze、T7272、T7278）
HTC Blackstone（Touch HD、T8282、T8288）
HTC Topaz（Diamond 2、T5353、T5358）
HTC Rhodium（Touch Pro 2、VX6875、T7373、T7378）

目前android只是以虚拟机的形式跑在上述手机上的，还没有直刷的版本，因此使用上会有点麻烦，需要先进入WM，然后执行haret进入android。也有双启动的程序，在启动时候可以选择引导WM或者android。

注：当前版本不稳定，仅供体验使用。

下载地址：<a href="http://dl.dbank.com/c0u12jdj8q">http://dl.dbank.com/c0u12jdj8q</a>

1. 下载MiniTool Partition Wizard Home Edition 5.2.rar，给sd卡划分出一个500M左右的分区，最小应该256M就够了，格式化成ext格式。具体使用方法请到百度google。

2.  下载XDANDROID.2.2.1.AOSP.FRX03.21.11.10.FULL_PACKAGE.zip，解压到sd卡根目录，从STARTUP文件夹里找到适合自己机型的startup.txt文件，亚太版的touch pro是raph 100（可以拆下电池这个型号），复制到sd卡根目录。

3. 拔掉usb，在WM下找到haret文件，运行就能看到linux的启动画面了。第一次运行会等比较长时间。

FRX03不支持摄像头，用下面步骤升级到最新版本。

参考：<a href="http://forum.xda-developers.com/showthread.php?t=951981">http://forum.xda-developers.com/showthread.php?t=951981</a>

1. Download the full bundle (zip).

If instead you just want the system.ext2 (zip) file by itself...

下载压缩包 FRX05_Full_Bundle_3.3.2011 或者 GBX0A_Full_Bundle_11.3.2011.zip

2. Extract it. You’ll see a folder, FRX05, copy its contents to the root of your SD card.

解压，拷贝FRX05内容到SD卡的根目录。

3. Go into the STARTUPS folder. Grab the appropriate startup.txt for your device, and move it to the root of the card (or where you run haret.exe from. If you want to change the location of the build, put a rel_path= statement in the cmdline section of the startup.txt. Mine is located two folders deep on the SD, so my rel_path=Androids/TP2Ref)

找到STARTUPS目录，根据手机型号找到对应的startup.txt文件，拷贝到sd卡的根目录。

4. Either download the ts-calibration file from this post and rename it to ts-calibration (remove the .txt extension) or follow the directions below to create your own. Place this file where you run haret.exe from - typically the root or 'base' folder of the SD card. Not within any folders, unless you run haret.exe from a folder!

下载ts-calibration.zip，解压得到ts-calibration文件，拷贝到sd卡根目录。

参考资料：<a href="http://www.peuol.com/blog/read.php/354.htm">http://www.peuol.com/blog/read.php/354.htm</a>
