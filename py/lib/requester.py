# !/usr/bin/env python
# -*- coding: utf-8 -*


class Requester:
    socketWorker = None

    def __init__(self, socketWorker):
        self.socketWorker = socketWorker

    def apiGameModePropertySet(self, name, value):
        return self.requestApi("apiGameModePropertySet", [name, value])

    def apiGameModePropertyGet(self, name):
        return self.requestApi("apiGameModePropertyGet", [name])

    def apiSay(self, text):
        return self.requestApi("apiSay", [text])

    def apiSaySys(self, text):
        return self.requestApi("apiSaySys", [text])

    def apiKickOrBan(self, isBan, playerGUID, reason):
        return self.requestApi("apiKickOrBan", [isBan, playerGUID, reason])

    def apiKick(self, playerNameOrGUID, reason):
        return self.requestApi("apiKick", [playerNameOrGUID, reason])

    def apiKickAll(self, reason):
        return self.requestApi("apiKickOrBan", [reason])

    def apiPlayersGetCount(self):
        return self.requestApi("apiPlayersGetCount", None)

    def apiPlayersRoster(self, infoDepth, delimiter):
        return self.requestApi("apiPlayersRoster", [infoDepth, delimiter])

    def apiGetServerName(self):
        return self.requestApi("apiGetServerName", None)

    def apiGetServerNameRCON(self, forceCacheRefresh):
        return self.requestApi("apiGetServerNameRCON", [forceCacheRefresh])

    def apiGetServerMode(self):
        return self.requestApi("apiGetServerMode", None)

    def apiGetMapName(self):
        return self.requestApi("apiGetMapName", None)

    def apiGetSessionID(self):
        return self.requestApi("apiGetSessionID", None)

    def apiGetLastRosterTime(self):
        return self.requestApi("apiGetLastRosterTime", None)

    def apiBadNameCheck(self, nameIn, exactMatch):
        return self.requestApi("apiBadNameCheck", [nameIn, exactMatch])

    def apiMapcycleRead(self):
        return self.requestApi("apiMapcycleRead", None)

    def apiMapChange(self, mapName, gameMode, secIns, dayNight, mutatorsList):
        return self.requestApi("apiMapChange", [mapName, gameMode, secIns, dayNight, mutatorsList])

    def apiMapList(self):
        return self.requestApi("apiMapList", None)

    def apiIsSupportedGameMode(self, candidateMode):
        return self.requestApi("apiIsSupportedGameMode", [candidateMode])

    def apiIsAdmin(self, connectID):
        return self.requestApi("apiIsAdmin", [connectID])

    def apiNameToCharacter(self, playerName):
        return self.requestApi("apiNameToCharacter", [playerName])

    def apiCharacterToName(self, characterID):
        return self.requestApi("apiCharacterToName", [characterID])

    def apiIsPlayerAliveByName(self, playerName):
        return self.requestApi("apiIsPlayerAliveByName", [playerName])

    def apiIsPlayerAliveByGUID(self, playerGUID):
        return self.requestApi("apiIsPlayerAliveByGUID", [playerGUID])

    def apiLookupObjectiveLetterFromCache(self, objectiveName):
        return self.requestApi("apiLookupObjectiveLetterFromCache", [objectiveName])

    def apiLookupLastObjectiveLetterFromCache(self):
        return self.requestApi("apiLookupLastObjectiveLetterFromCache", None)

    def requestApi(self, requestName, requestParam):
        data = {}
        data["requestName"] = requestName
        data["requestType"] = "request"
        if requestParam is not None:
            data["requestParams"] = "|".join(requestParam)

        return self.socketWorker.send(data)

    def requestRconCmd(self, rconCmd):
        data = {}
        data["requestName"] = "apiRcon"
        data["requestType"] = "request"
        data["requestParams"] = rconCmd
        return self.socketWorker.send(data)
