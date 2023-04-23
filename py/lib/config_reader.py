# !/usr/bin/env python
# -*- coding: utf-8 -*

import json
import traceback


class ConfigReader:
    commonConfig = None

    def read(self, configFileName):
        try:
            with open("./config/" + configFileName, "r") as f:
                return json.load(f)
        except Exception as e:
            traceback.print_exc()
            print("config目录下没找到" + configFileName + "文件")

    def getCommonConfig(self):
        if self.commonConfig is None:
            self.commonConfig = self.read("common_config.json")
        return self.commonConfig
