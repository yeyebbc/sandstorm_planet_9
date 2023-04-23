###sissm_python说明

的python版插件，

##一.为什么做做sissm_python？
因为sissm是C语言编写的，开发成本特别大，而python开发成本大。
原理是用python和sissm建立通信，这样用户就可以使用python写代码了。

##二.如何使用？
#1、首先下载sissm_plus（从release目录下载），替换掉官方的sissm。

#2、 然后在sissm.cfg开启插件：
socket_plugin.pluginState 1

#(1)如果你会python
    那么你可以继承EventCallback，并且在Register注册插件。
    使用requester对象可以获取你想要的数据，以及执行rcon命令。
    具体可以参考NoCodePlugin。

#(2)如你不会python
    那么你只能使用NoCodePlugin插件实现功能了。
    接下来介绍NoCodePlugin使用方法。
    你只需要修改文件config/no_code_config.json即可。


