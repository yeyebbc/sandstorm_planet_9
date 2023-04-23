###no code意思是，不需要写代码，也能写插件

步骤如下：
#1.下载sissm_plus
修改sissm.cfg配置，增加一句：
socket_plugin.pluginState 1

#2.修改配置文件config/no_code_config.json，具体如何修改，看后面。

#3.执行./sissm sissm.cfg

#4.执行python main.py



下面主要介绍如何修改配置文件config/no_code_config.json
【config/no_code_config.json文件格式如下】：
{
  "events": [
    {
      "事件名1": "条件1",
      "事件名2": "条件2",
      。。。。
      "cmds": [
        "rcon命令1"   ,
        "rcon命令2"
      ]
    }
  ]
}
events是一个集合，每个元素都是由条件+cmd组成，简单理解就是，当事件发生时，且满足条件，就执行对应的cmd。
条件支持python表达式

【举个例子例如】
{
  "events": [
    {
      "anyEvent": "log.find(\"kill\")>0",
      "roundStart": "playerCount>-2",
      "cmds": [
        "say hello",
        "gamemodeproperty MinimumEnemies 4",
        "gamemodeproperty MaximumEnemies 40"
      ]
    }
  ]
}

【每个事件都包含的变量】
event_type  事件类型
log   sissm日志


【支持的事件】：
anyEvent：任何事件都会执行

clientAdd：玩家加入，变量：playerName、playerGUID、playerIP
clientDel：玩家退出，变量：playerName、playerGUID、playerIP
restart：sissm重启
mapChange:换图
gameStart:游戏开始
gameEnd:游戏结束
roundStart:本局开始
roundEnd:本局结束
roundStateChange:本局开始或结束。变量：roundIndex（第几局）、isStart（true本局开始,false本局结束）
takeObject：占点完成。变量:point(哪个点，是序号，不是ABC)、players(哪些玩家站点了)
killed：玩家击杀AI,或AI击杀玩家。变量：killer（杀手，包含playerName、playerGUID）、died（死去的玩家，包含playerName、playerGUID）、所用武器：weapon
captured:占点成功
shutdown:sissm关闭
clientSynthDel:玩家退出，变量：playerName、playerGUID、playerIP
clientSynthAdd:玩家加入，变量：playerName、playerGUID、playerIP
chat:玩家发送的聊天。变量：playerName、playerGUID、content（聊天内容）
sigterm:sissm意外退出
winLose:本局结束，并告诉输赢。mapSide、mode、reason
travel:换图事件
sessionLog:未知
objectSynth:未知

everyLog：除了上述事件，并且匹配上了设置的关键字对应的事件socket_plugin.matchEventString[0]

【条件里支持的全局变量】
playerCount 当前玩家数据
AIDeadCountForGame 整个游戏AI死亡次数
AIDeadCountForCurrRound 当前局AI死亡次数
AIDeadCountForCurrPoint 当前点AI死亡次数
PlayerDeadCountForGame 整个游戏玩家死亡次数
PlayerDeadCountForCurrRound 当前局玩家死亡次数
PlayerDeadCountForCurrPoint 当前点AI死亡次数
roundIndex 当前是第几局



通用配置：
config/common_config.json
enableLog用来开启或关闭日志


【cmds支持的命令】
cmds支持所有rcon命令，具体名参考：
https://insurgencysandstorm.mod.io/guides/server-admin-guide#read14

#help
Displays a list of commands.

#listplayers
Lists players currently connected to the server.

#kick
<id/netid/name> [reason]
Kicks a player from the server.

#ban
<id/netid/name> [duration in minutes] [reason]
Bans a player from the server.
banid [duration in minutes] [reason]  Bans a player (by net ID) from the server. Does not require the player to be on the server.

#permban
<id/netid/name> [reason]
Permanently bans a player from the server.

#unban
Lifts a ban for a user.

#listbans
Shows the ban list for the server.

#say
Shows a message to all players in the chatbox.

#restartround
[0 = no team switch, 1 = swap teams]
Restarts the current round.

#maps
[level filter]
Lists available maps.

#scenarios
[level filter]
Lists available scenarios.

#travelscenario
Change level to given scenario.

#travel
Transitions the server to a different level.

#gamemodeproperty
[new value]
Gets or sets a gamemode property for the length of the scenario.

#listgamemodeproperties  [property filter] Lists all properties available for the currently loaded gamemode.