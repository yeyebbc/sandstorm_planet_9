class EventCallback:
    requester = None
    configReader = None
    logger = None
    callbacks = []

    def init(self, requester, configReader, logger):
        self.requester = requester
        self.configReader = configReader
        self.logger = logger

    def setCallbackList(self, callbacks):
        self.callbacks = callbacks

    def clientAdd(self, log, data):
        for callback in self.callbacks:
            callback.clientAdd(log, data)

    def clientDel(self, log, data):
        for callback in self.callbacks:
            callback.clientDel(log, data)

    def restart(self, log, data):
        for callback in self.callbacks:
            callback.restart(log, data)

    def mapChange(self, log, data):
        for callback in self.callbacks:
            callback.mapChange(log, data)

    def gameStart(self, log, data):
        for callback in self.callbacks:
            callback.gameStart(log, data)

    def gameEnd(self, log, data):
        for callback in self.callbacks:
            callback.gameEnd(log, data)

    def roundStart(self, log, data):
        for callback in self.callbacks:
            callback.roundStart(log, data)

    def roundStateChange(self, log, data):
        for callback in self.callbacks:
            callback.roundStateChange(log, data)

    def takeObject(self, log, data):
        for callback in self.callbacks:
            callback.takeObject(log, data)

    def killed(self, log, data):
        for callback in self.callbacks:
            callback.killed(log, data)

    def roundEnd(self, log, data):
        for callback in self.callbacks:
            callback.roundEnd(log, data)

    def captured(self, log, data):
        for callback in self.callbacks:
            callback.captured(log, data)

    def shutdown(self, log, data):
        for callback in self.callbacks:
            callback.shutdown(log, data)

    def clientSynthDel(self, log, data):
        for callback in self.callbacks:
            callback.clientSynthDel(log, data)

    def clientSynthAdd(self, log, data):
        for callback in self.callbacks:
            callback.clientSynthAdd(log, data)

    def chat(self, log, data):
        for callback in self.callbacks:
            callback.chat(log, data)

    def sigterm(self, log, data):
        for callback in self.callbacks:
            callback.sigterm(log, data)

    def winLose(self, log, data):
        for callback in self.callbacks:
            callback.winLose(log, data)

    def travel(self, log, data):
        for callback in self.callbacks:
            callback.travel(log, data)

    def sessionLog(self, log, data):
        for callback in self.callbacks:
            callback.sessionLog(log, data)

    def objectSynth(self, log, data):
        for callback in self.callbacks:
            callback.objectSynth(log, data)

    def everyLog(self, log, data):
        for callback in self.callbacks:
            callback.everyLog(log, data)

    def event(self, data):
        for callback in self.callbacks:
            callback.event(data)
