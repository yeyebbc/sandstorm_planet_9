# !/usr/bin/env python
# -*- coding: utf-8 -*

class Logger:
    enableLog = False

    def __init__(self, enableLog):
        self.enableLog = enableLog

    def log(self, msg):
        if self.enableLog:
            print(msg)
