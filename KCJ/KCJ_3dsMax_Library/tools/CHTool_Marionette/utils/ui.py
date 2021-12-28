#-*-coding: utf-8-*-
import MaxPlus as mp

try:
    from PySide.QtGui import *
    from PySide import QtCore, QtUiTools

except ImportError:
    from PySide2.QtGui import *
    from PySide2.QtWidgets import *
    from PySide2 import QtCore, QtUiTools


def get_QMaxMainWindow():
    # 맥스 버전마다 다르기 때문에 아래와 같이 실행

    try:
        result = mp.GetQMaxWindow()
    except AttributeError:
        result = mp.GetQMaxMainWindow()

    return result

def loadUiWidget(uifilename, parent=None):
    """Properly Loads and returns UI files - by BarryPye on stackOverflow"""
    loader = QtUiTools.QUiLoader()
    uifile = QtCore.QFile(uifilename)
    # pm.PyNode('pCube1') py
    uifile.open(QtCore.QFile.ReadOnly)
    ui = loader.load(uifile, parent)
    uifile.close()
    return ui

class MaxBaseWidget_byUI():
    # 이 페런트가 있어야 글자 입력, 핫키로 부터 자유로워진다.
    # 이유는 차후 알아보기로...
    cur_opend_windowDict = {}

    def __init__(self, uiPath, title = 'TitleName', parent = None):
        # 19.0402 /  QWidget(parent) 이 max2019에서는 제대로 작동안되서 QDialog로 변경
        if parent != None :
            self.parent = parent
        else :
            self.parent = get_QMaxMainWindow()
        self.win = loadUiWidget(uiPath, self.parent)
        self.win.setWindowTitle(title)
        self.title = title
        # self.win = QDialog(self.parent)
        # self.win.resize(width, height)
        # self.win.setWindowTitle(title)

    def get_parent(self):
        return self.parent

    def get_windowTitle(self):
        return self.title

    def get_window(self):
        return self.win

    def show(self):
        # 이미 열려있다면 닫기

        if MaxBaseWidget_byUI.cur_opend_windowDict.has_key(self.title) :
            oldWin = MaxBaseWidget_byUI.cur_opend_windowDict[self.title]
            if oldWin : oldWin.close()
            MaxBaseWidget_byUI.cur_opend_windowDict[self.title] = None

        # open
        self.win.show()
        MaxBaseWidget_byUI.cur_opend_windowDict[self.title] = self.win