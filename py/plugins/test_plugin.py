# !/usr/bin/env python
# -*- coding: utf-8 -*
from lib.event_callback import EventCallback


class TestPlugin(EventCallback):
    def roundStateChange(self, log, data):
        print("TestPlugin roundStateChange 接收" + str(data))
