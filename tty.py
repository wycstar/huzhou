#!/usr/bin/env python
# -*-coding:utf-8-*-

import serial
from time import sleep
import json
import threading
import tools

class CustomSerial(threading.Thread):
    '''自定义串口类'''
    def __init__(self, com, baud, root, context):
        threading.Thread.__init__(self)
        self.s = serial.Serial(com, baud)
        self.root = root
        self.context = context
        self.pointData = {}
        self.seriesData = {}
        self._hyPower = []
        self._liPower = []
        self._allPower = []
        self._hyTemp = []
        self._hyPress = []
        self._liVolt = []
        self._hyVolt = []
        self._totalCurrent = []
        self.x = []
        self.isRun = True
        self._x = 0
        self.op = {'HyTe':self.getHyTemp,
                   'HyPr':self.getHyPress,
                   'HyVo':self.getHyVolt,
                   'DCVo':self.getLiVolt,
                   'IBus':self.getTotalCurrent}

    def run(self):
        while(self.isRun):
            try:
                '''
                j = json.loads(self.s.readline().decode('utf-8'))
                power = j["LiVolt"] * j["TotalCurrent"]
                hyPower = fakeData(j["HyVolt"])
                self.pointData = {"HyTemp":j["HyTemp"],
                                  "HyPress":j["HyPress"],
                                  "LiVolt":j["LiVolt"],
                                  "HyVolt":j["HyVolt"],
                                  "LiPower":power - hyPower,
                                  "HyPower":hyPower}
                print(self.root.property('isGraphPause'))
                if self.root.property('isGraphPaint') and not self.root.property('isGraphPause'):
                    self._x += 1                  
                    self._hyPower.append(hyPower)
                    self._liPower.append(power - hyPower)
                    self._allPower.append(power)
                    self.seriesData = {"HyPower":self._hyPower[:300],
                                       "LiPower":self._liPower[:300],
                                       "AllPower":self._allPower[:300],
                                       "x":list(range(self._x))[:300]}
                '''
                string = self.s.readline().decode('utf-8')
                self.op.get(string[:4])(string)
                # sleep(1)
                liVolt = self._liVolt.pop()               
                hyVolt = self._hyVolt.pop()               
                hyTemp = self._hyTemp.pop()    
                hyPress = self._hyPress.pop()
                totalCurrent = self._totalCurrent.pop()
                power = liVolt * totalCurrent
                hyPower = fakeData(hyVolt)
                liPower = 0
                if(power > hyPower):
                    liPower = power - hyPower
                self.pointData = {"HyTemp":hyTemp,
                                  "HyPress":hyPress,
                                  "LiVolt":liVolt,
                                  "HyVolt":hyVolt,
                                  "LiPower":liPower,
                                  "HyPower":hyPower}
                if self.root.property('isGraphPaint') and not self.root.property('isGraphPause'):
                    self._x += 1                  
                    self._hyPower.append(hyPower)
                    self._liPower.append(power - hyPower)
                    self._allPower.append(power)
                    self.seriesData = {"HyPower":self._hyPower[:300],
                                       "LiPower":self._liPower[:300],
                                       "AllPower":self._allPower[:300],
                                       "x":list(range(self._x))[:300]}
                                       
            except:
                # print("Serial Read ERROR!")
                pass

    def getHyTemp(self, string):
        # print(float(string[7:]))
        self._hyTemp.append(float(string[7:]))
        # print(self._hyTemp.pop())

    def getHyPress(self, string):
        # print(float(string[7:]))
        self._hyPress.append(float(string[8:]))

    def getHyVolt(self, string):
        # print(float(string[7:]))
        self._hyVolt.append(float(string[7:]))

    def getTotalCurrent(self, string):
        # print(float(string[5:]))
        self._totalCurrent.append(float(string[5:]))

    def getLiVolt(self, string):
        # print(float(string[7:]))
        self._liVolt.append(float(string[7:]))


def fakeData(volt):
    if volt > 33.0:
        volt = 33.0
    elif volt < 19.0:
        volt = 19.0
    return 4 * ((volt - 33) ** 2)

if __name__ == "__main__":
    s = CustomSerial("COM4", 115200)
    s.start()
    while(True):
        print(s.seriesData)
        print(s.pointData)
        sleep(1)
        s.s.close()
