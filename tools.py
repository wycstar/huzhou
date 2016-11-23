#!/usr/bin/env python
# -*-coding:utf-8-*-

import sys
from PyQt5.QtCore import QObject, pyqtSlot

class Tools(QObject):
    def __init__(self, root, context, port):
        QObject.__init__(self)
        self.root = root
        self.context = context
        self.port = port

    @pyqtSlot()
    def closeApplication(self):
        self.port.serialHandle.isRun = False
        self.port.serialHandle.s.close()
        self.port.t.stop()
        sys.exit() 