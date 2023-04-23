# !/usr/bin/env python
# -*- coding: utf-8 -*
import json
import os
import traceback

from lib.event_dispatcher import EventCallback


# 根据配置来执行命令的插件
class NoCodePlugin(EventCallback):
    config = None
    globalsData = {"playerCount": -1,
                   "AIDeadCountForGame": 0,
                   "AIDeadCountForCurrRound": 0,
                   "AIDeadCountForCurrPoint": 0,
                   "PlayerDeadCountForGame": 0,
                   "PlayerDeadCountForCurrRound": 0,
                   "PlayerDeadCountForCurrPoint": 0,
                   "roundIndex": 0,
                   }

    def init(self, requester, configReader, logger):
        EventCallback.init(self, requester, configReader, logger)
        self.loadConfig()

    def gameStart(self, log, data):
        self.globalsData["AIDeadCountForGame"] = 0
        self.globalsData["PlayerDeadCountForGame"] = 0

    def gameEnd(self, log, data):
        pass

    def roundStart(self, log, data):
        self.globalsData["AIDeadCountForCurrRound"] = 0
        self.globalsData["PlayerDeadCountForCurrRound"] = 0

    def roundStateChange(self, log, data):
        if data is None:
            return
        if data.get("isStart"):
            self.globalsData["roundIndex"] = data.get("roundIndex")

    def takeObject(self, log, data):
        self.globalsData["AIDeadCountForCurrPoint"] = 0
        self.globalsData["PlayerDeadCountForCurrPoint"] = 0

    def killed(self, log, data):
        if data is None:
            return
        died = data.get("died")
        if died is None or len(died) == 0:
            return
        uid = died[0].get("playerGUID")
        if uid is None or len(uid) < 15:
            self.globalsData["AIDeadCountForGame"] += 1
            self.globalsData["AIDeadCountForCurrRound"] += 1
            self.globalsData["AIDeadCountForCurrPoint"] += 1
        else:
            self.globalsData["PlayerDeadCountForGame"] += 1
            self.globalsData["PlayerDeadCountForCurrRound"] += 1
            self.globalsData["PlayerDeadCountForCurrPoint"] += 1

    def roundEnd(self, log, data):
        pass

    def clientSynthDel(self, log, data):
        self.syncPlayerCount()

    def clientSynthAdd(self, log, data):
        self.syncPlayerCount()

    def syncPlayerCount(self):
        result = self.requester.apiPlayersGetCount()
        try:
            if result is not None:
                resultData = str(result.get("resultData"))
                if resultData.isalnum():
                    self.globalsData["playerCount"] = int(resultData)
        except Exception as e:
            traceback.print_exc()
            print("syncPlayerCount error result=" + str(result))

    def loadConfig(self):
        self.config = self.configReader.read("no_code_config.json")

    # data = {"event_type": "mapChange", "log": "abc123"}
    # self.event(data)

    def event(self, data):
        if data is None or self.config is None:
            return
        eventType = data.get("event_type")
        events = self.config.get("events")
        if events is None:
            print("【配置错误】数据里缺少events节点")
        for event in events:
            if "anyEvent" in event.keys():
                eventType = "anyEvent"
            if eventType in event.keys():
                params = event.get(eventType)
                cmds = event.get("cmds")
                self.execEvent(eventType, params, cmds, data)

    def execEvent(self, eventType, params, cmds, data):
        if cmds is None:
            print("【配置错误】缺少cmds节点")
        result = None
        try:
            # eval值负责表达式，没有赋值功能
            result = eval(params, self.getGlobalData(), data)
        except Exception as e:
            traceback.print_exc()
            print("事件" + eventType + "后面的值" + str(params) + "有误，你需要重新写条件")
        self.logger.log(
            "eval eventType=" + eventType + "; params=(" + str(params) + "); result=" + str(result))
        if result is True and cmds is not None:
            self.executeCmds(cmds)

    def executeCmds(self, cmds):
        for cmd in cmds:
            if cmd.find("\"") == 0:
                # 引号开头，说明是拼接的字符串
                tempExecData = self.getGlobalData().copy()
                tempExecData['finalCmd'] = ""
                try:
                    exec("finalCmd = " + cmd, tempExecData)
                except Exception as e:
                    traceback.print_exc()
                    print("拼接cmd写法是错误的cmd=" + cmd)
                cmd = tempExecData.get("finalCmd")
            if cmd is None or len(str(cmd)) == 0:
                return
            result = self.requester.requestRconCmd(cmd)
            print("Rcon cmd=" + cmd + " result=" + str(result))

    def getGlobalData(self):
        return self.globalsData

# plugin = ConfigPlugin()
# plugin.main()
