#!/usr/bin/env python
# -*- coding: utf-8 -*
from lib.config_reader import ConfigReader
from lib.test import Test
from plugins.no_code_plugin import NoCodePlugin
from lib.event_dispatcher import *
from lib.requester import Requester
from lib.socket_bridge import SocketWorker
from register import Register

socketWorker = None

if __name__ == "__main__":
    socketWorker = SocketWorker()
    requester = Requester(socketWorker)
    register = Register()
    pluginList = []
    register.getPluginList(pluginList)
    for plugin in pluginList:
        eventDispatcher.register(plugin)
    configReader = ConfigReader()
    logger = Logger(configReader.getCommonConfig().get("enableLog"))
    eventDispatcher.init(requester, configReader, logger)
    # test = Test(eventDispatcher)
    # test.testEvent()
    socketWorker.socketLoop()
