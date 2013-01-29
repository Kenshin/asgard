AsGard -- 基于Node.js的小型、多人日志系统
======

## 应用说明：  
* 可以用于搭建CMS系统；多人/单人Blog；小型团队日志系统等。

## 搭建环境（技术选型）：  
* Node.js
* MongoDB
* Coffee
* express
* ejs
* mongoose
* bootstrap（用于后台管理界面模板）

## 特点：  
* 全自动部署（具有setup功能，只要将源代码push到cloudfoundry后即可完成搭建）
* 代码采用MVC框架
* 后台管理系统与前台文章浏览系统单独分开，因此一个后台可以“挂”多个前台系统
* 权限分离。（目前只有管理员与操作员两种角色，互不干扰）

## 测试地址：  
* [http://asgard.cloudfoundry.com/](http://asgard.cloudfoundry.com/)

## 测试账户：  
* 登录地址：[http://asgard.cloudfoundry.com/asgard-signin](http://asgard.cloudfoundry.com/asgard-signin)
* 用户名：demo    密码：demo1

## 安装说明（以AppFog为例）：  
* 需要操作系统用于Ruby与Gem环境。
* 如gem版本过低，请使用gem update --system升级gem版本
* 安装AF - gem install af
* 登录AF - af login（appfog的帐号）
* push xxx -runtime=node08
* 控制台会打印并且需要录入如下内容：（以asgard为例，具体情况视你实际情况为准）
<pre>
Would you like to deploy from the current directory? [Yn]: y
Detected a Node.js Application, is this correct? [Yn]: y
1: AWS US East - Virginia
2: AWS EU West - Ireland
3: AWS Asia SE - Singapore
4: Rackspace AZ 1 - Dallas
5: HP AZ 2 - Las Vegas
Select Infrastructure: 1
Application Deployed URL [asgard.aws.af.cm]:
Memory reservation (128M, 256M, 512M, 1G, 2G) [64M]: 128
How many instances? [1]: 1
Create services to bind to 'asgard'? [yN]: y
1: mongodb
2: mysql
3: postgresql
4: rabbitmq
5: redis
What kind of service?: 1
Specify the name of the service [mongodb-10054]: agdb
Create another? [yN]: n
Would you like to save this configuration? [yN]: y
Manifest written to manifest.yml.
Creating Application: OK
Creating Service [agdb]: OK
Binding Service [agdb]: OK
Uploading Application:
  Checking for available resources: OK
  Processing resources: OK
  Packing application: OK
  Uploading (206K): OK
Push Status: OK
Staging Application 'asgard': OK
Starting Application 'asgard': OK
</pre>

## 使用说明（以AppFog为例）：  
* 进入[http://asgard.aws.af.cm/setup](http://asgard.aws.af.cm/setup)
* 录入管理员的信息。
* 录入完毕会后跳转到[http://asgard.aws.af.cm/asgard-signin](http://asgard.aws.af.cm/asgard-signin)
* 使用刚才录入的管理员信息进行登录操作（注意：权限选择管理员）
* 登录后，需要分别创建【操作员】与【分类】
* 创建成功后，就可以用操作员账户登录（注意：权限选择操作员）然后进行日志的录入。

## 更新日志：  

###前台：

version 1.1.4 [2013-01-29]
* 升级到expres 3.1.0，ejs 0.8.3  

version 1.0.4 [2013-01-26]
* fixed bugs

version 1.0.3 [2013-01-21]
* 增加了favicon
* 去掉了前端页面的jquery

version 1.0.2 [2013-01-19]
* release

###后台：

version 0.7.2 [2013-01-29]
* 升级到expres 3.1.0，ejs 0.8.3  

version 0.6.2 [2013-01-26]
* fixed bugs  

version 0.6.0 [2013-01-18]
* release

## 联系方式：
* 博客：[k-zone.cn](http://www.k-zone.cn/zblog)
* 微博：[新浪微博](http://weibo.com/23784148)
* 联络：kenshin[AT]ksria.com

## 版权和许可：
Copyright 2012 [k-zone.cn](http://www.k-zone.cn/zblog)  
Licensed under MIT or GPL Version 2 licenses