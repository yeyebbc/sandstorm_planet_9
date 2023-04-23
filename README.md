###sissm_plus说明

基于官方sissm扩展了一些功能，起名叫sissm_plus。
请在release下载相关文件。

官方sissm：https://github.com/schroeder-lvb/sissm

#1.头衔
可在sissm.cfg里配置：
pigreetings.connectedCustomUids[0] "76561198097876746"
pigreetings.connectedCustomWords[0] "[衝衝兵]"

pigreetings.connectedCustomUids[1] "76561199275670546 76561198846188569 76561198205775537 76561198112390529 76561198145254393 76561198406696183 76561198306360605 76561198009251911 76561198136333749"
pigreetings.connectedCustomWords[1] "[老兵]"


#2.投票换图
玩家聊天输入vote发起投票换图，玩家在聊天输入地图序号来投票。目前只支持PVE纯净服，换图时会清空变体。
// 投票插件开关
map_vote.pluginState               1
// 玩家少于这个数量需要全票通过才行
map_vote.lessPlayerCountNeedAllVote 3
// 允许此人重复投票,一般服主有这待遇
map_vote.allowDuplicateVoteUid "76561198097876746"


#3.socket通信插件
由于sissm使用C语言编写，开发成本大，所以开发了用于支持python和sissm通信的插件，这样就可以写python代码实现功能了。
详见py目录
// 开启socket通信插件
socket_plugin.pluginState 1


所有代码都开源了，如果想获取源码，或者想参与一起开发，请加QQ群：561191299，欢迎加入。