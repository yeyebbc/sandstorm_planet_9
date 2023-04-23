# !/usr/bin/env python
# -*- coding: utf-8 -*
from lib.config_reader import ConfigReader
from lib.event_callback import EventCallback
from lib.logger import Logger


# todo 基于sissm，后面有必要再自己track

class EventDispatcher:
    callbackList = []
    requester = None
    configReader = None
    playerMap = {}
    eachCallback = None
    logger = None

    def register(self, callback):
        self.callbackList.append(callback)

    def init(self, requester, configReader, logger):
        self.requester = requester
        self.eachCallback = EventCallback()
        self.configReader = configReader
        self.logger = logger

        if self.callbackList is not None:
            for callback in self.callbackList:
                callback.init(requester, self.configReader, self.logger)
            self.eachCallback.setCallbackList(self.callbackList)

    def dispatch(self, jsonObject):
        cb = self.eachCallback
        log = jsonObject["log"]
        eventType = jsonObject["event_type"]
        if eventType == "clientAdd":
            cb.clientAdd(log, self.parseClientAdd(log, jsonObject))
        elif eventType == "clientDel":
            cb.clientDel(log, self.parseClientDel(log, jsonObject))
        elif eventType == "restart":
            cb.restart(log, self.parseRestart(log, jsonObject))
        elif eventType == "mapChange":
            cb.mapChange(log, self.parseMapChange(log, jsonObject))
        elif eventType == "gameStart":
            cb.gameStart(log, self.parseGameStart(log, jsonObject))
        elif eventType == "gameEnd":
            cb.gameEnd(log, self.parseGameEnd(log, jsonObject))
        elif eventType == "roundStart":
            cb.roundStart(log, self.parseRoundStart(log, jsonObject))
        elif eventType == "roundEnd":
            cb.roundEnd(log, self.parseRoundEnd(log, jsonObject))
        elif eventType == "roundStateChange":
            cb.roundStateChange(log, self.parseRoundStateChange(log, jsonObject))
        elif eventType == "takeObject":
            cb.takeObject(log, self.parseTakeObject(log, jsonObject))
        elif eventType == "killed":
            cb.killed(log, self.parseKilled(log, jsonObject))
        elif eventType == "captured":
            cb.captured(log, self.parseCaptured(log, jsonObject))
        elif eventType == "shutdown":
            cb.shutdown(log, self.parseShutdown(log, jsonObject))
        elif eventType == "clientSynthDel":
            cb.clientSynthDel(log, self.parseClientSynthDel(log, jsonObject))
        elif eventType == "clientSynthAdd":
            cb.clientSynthAdd(log, self.parseClientSynthAdd(log, jsonObject))
        elif eventType == "chat":
            cb.chat(log, self.parseChat(log, jsonObject))
        elif eventType == "sigterm":
            cb.sigterm(log, self.parseSigterm(log, jsonObject))
        elif eventType == "winLose":
            cb.winLose(log, self.parseWinLose(log, jsonObject))
        elif eventType == "travel":
            cb.travel(log, self.parseTravel(log, jsonObject))
        elif eventType == "sessionLog":
            cb.sessionLog(log, self.parseSessionLog(log, jsonObject))
        elif eventType == "objectSynth":
            cb.objectSynth(log, self.parseObjectSynth(log, jsonObject))
        elif eventType == "everyLog":
            cb.everyLog(log, self.parseEveryLog(log, jsonObject))
        cb.event(jsonObject)

    def processResult(self, log, data, result):
        data["parsed"] = result
        self.logger.log("[event]:origin:" + str(data) + "======result:" + str(result))

    def _getMid(self, strData, key1, key2):
        if strData is None or key1 is None or key2 is None:
            return None
        index1 = strData.find(key1)
        index2 = strData.find(key2)
        if index1 > 0 and index2 > 0 and index2 > index1:
            return strData[index1 + len(key1): index2].strip()
        return None

    def _getLeft(self, strData, key1):
        if strData is None or key1 is None:
            return None
        index1 = strData.find(key1)
        if index1 > 0:
            return strData[0:index1].strip()
        return None

    def _getRight(self, strData, key1):
        if strData is None or key1 is None:
            return None
        index1 = strData.find(key1)
        if index1 > 0:
            return strData[index1 + len(key1):].strip()
        return None

    def parseClientAdd(self, log, data):
        result = {}
        result["playerName"] = data.get("playerName")
        result["playerGUID"] = data.get("playerGUID")
        result["playerIP"] = data.get("playerIP")
        self.playerMap[result["playerGUID"]] = result
        self.processResult(log, data, result)
        return result

    def parseClientDel(self, log, data):
        result = None
        steamId = self._getRight(log, "SteamNWI:")
        if steamId is not None and steamId in self.playerMap:
            result = self.playerMap.pop(steamId)
        self.processResult(log, data, result)
        return result

    def parseRestart(self, log, data):
        self.processResult(log, data, None)
        return None

    def parseMapChange(self, log, data):
        self.processResult(log, data, None)
        return None

    def parseGameStart(self, log, data):
        self.processResult(log, data, None)
        return None

    def parseGameEnd(self, log, data):
        self.processResult(log, data, None)
        return None

    def parseRoundStart(self, log, data):
        self.processResult(log, data, None)
        return None

    def parseRoundEnd(self, log, data):
        self.processResult(log, data, None)
        return None

    def parseRoundStateChange(self, log, data):
        result = None
        roundIndex = self._getMid(log, "Round", "started")
        if roundIndex is not None:
            result = {"roundIndex": int(str(roundIndex)), "isStart": True}
        else:
            roundIndex = self._getMid(log, "Round", "Over")
            if roundIndex is not None:
                result = {"roundIndex": int(str(roundIndex)), "isStart": False}
        self.processResult(log, data, result)
        return result

    def _parsePlayer(self, playerStr):
        if playerStr is None:
            return None
        playerName = self._getLeft(playerStr, "[")
        playerUid = self._getMid(playerStr, "[", "]")
        playerTeam = None
        if playerUid is not None and "," in playerUid:
            playerTeam = self._getRight(playerUid, ",")
            playerUid = self._getLeft(playerUid, ",")

        if playerName is not None and playerUid is not None:
            return {"playerName": playerName, "playerGUID": playerUid, "playerTeam": playerTeam}
        return None

    def _parsePlayersArray(self, arrayStr):
        if arrayStr is None:
            return None
        playerStrArray = arrayStr.split("], ")
        playerArray = []
        for playerStr in playerStrArray:
            if "]" not in playerStr:
                playerStr = playerStr + "]"
            playerItem = self._parsePlayer(playerStr)
            playerArray.append(playerItem)
        return playerArray

    def parseTakeObject(self, log, data):
        destroyedStr = " was destroyed for team "
        capturedStr = " was captured for team "
        point = None
        rightPlayersStr = None
        if destroyedStr in log:
            point = self._getMid(log, "Display: Objective ", " owned by team ")
            rightPlayersStr = self._getRight(log, destroyedStr)
        if capturedStr in log:
            point = self._getMid(log, "Display: Objective ", " was captured for team ")
            rightPlayersStr = self._getRight(log, " was captured for team ")
        if rightPlayersStr is None:
            return None
        arrayStr = self._getRight(rightPlayersStr, " by ")
        result = {}
        result["point"] = point
        result["players"] = self._parsePlayersArray(arrayStr)
        self.processResult(log, data, result)
        return result

    def parseKilled(self, log, data):
        result = {}
        killerStr = self._getMid(log, " Display:", " killed ")
        result["killer"] = self._parsePlayersArray(killerStr)

        diedStr = self._getMid(log, " killed ", " with ")
        result["died"] = self._parsePlayersArray(diedStr)

        result["weapon"] = self._getRight(log, " with ")
        self.processResult(log, data, result)
        return result

    def parseCaptured(self, log, data):
        self.processResult(log, data, None)
        return None

    def parseShutdown(self, log, data):
        self.processResult(log, data, None)
        return None

    def parseClientSynthDel(self, log, data):
        result = {}
        result["playerName"] = data.get("playerName")
        result["playerGUID"] = data.get("playerGUID")
        result["playerIP"] = data.get("playerIP")
        self.playerMap[result["playerGUID"]] = result
        self.processResult(log, data, result)
        return result

    def parseClientSynthAdd(self, log, data):
        result = {}
        result["playerName"] = data.get("playerName")
        result["playerGUID"] = data.get("playerGUID")
        result["playerIP"] = data.get("playerIP")
        self.playerMap[result["playerGUID"]] = result
        self.processResult(log, data, result)
        return result

    def parseChat(self, log, data):
        content = self._getRight(log, " Chat:")
        playerName = self._getMid(log, " Display:", "(")
        playerUid = self._getMid(log, "(", ")")
        result = {"playerName": playerName, "playerGUID": playerUid, "content": content}
        self.processResult(log, data, result)
        return result

    def parseSigterm(self, log, data):
        self.processResult(log, data, None)
        return None

    def parseWinLose(self, log, data):
        result = {}
        # humanSide：-1=unknown or PvP, 0=Security, 1=Insurgents
        humanSide = data.get("humanSide")
        if humanSide == 1:
            result["mapSide"] = "Checkpoint_Insurgents"
            # 地图是叛军
            if "Team 0" in log:
                result["mode"] = "PVE"
                result["result"] = "lose"
        elif humanSide == 0:
            result["mapSide"] = "Checkpoint_Security"
            # 地图是政府军
            result["mode"] = "PVE"
            if "Team 0" not in log:
                result["result"] = "win"
        else:
            result["mode"] = "PVP"
        reason = self._getMid(log, "(win reason:", ")")
        if reason is not None:
            result["reason"] = reason
        self.processResult(log, data, result)
        return result

    def parseTravel(self, log, data):
        self.processResult(log, data, None)
        return None

    def parseSessionLog(self, log, data):
        self.processResult(log, data, None)
        return None

    def parseObjectSynth(self, log, data):
        self.processResult(log, data, None)
        return None

    def parseEveryLog(self, log, data):
        self.processResult(log, data, None)
        return None


eventDispatcher = EventDispatcher()
