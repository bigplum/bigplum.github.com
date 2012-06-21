--- 
layout: post
title: !binary |
  Z2l0aHVi5L2/55So56yU6K6w

date: 2011-04-27 20:07:36 +08:00
---
1. 在github上建立一个项目，将代码 push 到 github
{% highlight bash%}
git config --global user.email your_email@youremail.com
cd ~/.ssh
ssh-keygen -t rsa -C "your_email@youremail.com"
cat id_rsa.pub  #add ssh key to github website
ssh git@github.com
mkdir -p ~/workspace/Nginx-limit-traffic-rate-module/
cd ~/workspace/Nginx-limit-traffic-rate-module/
cp ~/limit-rate/* .
git init
git add .
git commit -m "init"
git remote add origin git@github.com:bigplum/Nginx-limit-traffic-rate-module.git
git push origin master
touch README
git add README
git commit -m "add readme"
git push
{% endhighlight %}

2. 将项目从 github 拖回本地的另一台机器
{% highlight bash%}
cd rm id_rsa*
rm id_rsa*
ssh-keygen -t rsa -C "your_email@youremail.com"
ssh-add ~/.ssh/id_rsa  #ubuntu系统需要执行这个命令，否则ssh时会提示Agent admitted failure to sign using the key.
ssh git@github.com
cd ~/work
git clone git@github.com:bigplum/Nginx-limit-traffic-rate-module.git
{% endhighlight %}

3. Pull Request
Github 支持 Pull Request ，可以很方便的为开源项目贡献代码。
首先将项目 fork 一份到自己的空间，修改测试之后将代码 commit，push ；
然后在页面上点击Pull Request按钮，选择相应的分支版本，提交给原作者就可以了。
