# -*-coding: utf-8-*-
import os
import MaxPlus as mp
import pymxs
import utils.system as utils_system
import utils.ui as utils_ui
import utils.pymxsLib as pymxsLib

# Pyside 처리
try:
    from PySide.QtGui import *
    from PySide import QtCore, QtUiTools
except ImportError:
    from PySide2.QtGui import *
    from PySide2.QtWidgets import *
    from PySide2 import QtCore, QtUiTools


def openWindow():
    baseWin = FollowBakeTool()
    baseWin.show()


class FollowBakeTool():

    def __init__(self):
        uiPath = utils_system.get_ui_main()
        self.curObjects = []
        self.BaseWin = utils_ui.MaxBaseWidget_byUI(uiPath, title='FollowBakeTool').get_window()


        # 버튼들 연결
        self.BaseWin.CustomBakeFrame_CheckBox.stateChanged.connect(lambda evt=None : self.command_CustomBakeFrame_CheckBox() )

        self.BaseWin.AutoCheck_Btn.clicked.connect(lambda evt=None : self.command_AutoCheck_Attr() )
        self.BaseWin.Bake_Btn.clicked.connect(lambda evt=None : self.command_Bake() )


    # ===============================
    # 기본 기능들
    # ===============================

    def get_baseWin(self):
        return self.BaseWin

    def show(self):
        self.get_baseWin().show()

    # ===============================
    # UI 관련 기능들
    # ===============================
    def command_AutoCheck_Attr(self):
        # ============================
        # inputs
        # =============================
        checkAttrName = 'Follow'
        selList = pymxsLib.get_selected()
        if len(selList) == 0 : return
        sel = selList[-1]

        # ============================
        # process
        # =============================
        # name Check
        cur_name = pymxsLib.get_INode_name(sel)
        self.BaseWin.Ctrl_LineEdit.setText(cur_name )

        # attr Check
        cur_attrList = pymxsLib.get_INode_AttrList(sel, attrOrigName=True)
        detachedAttr = ''
        for cur_at in cur_attrList :
            cur_at_orig = cur_at.split('.')[-1]
            result = cur_at_orig.startswith( checkAttrName )
            if result : detachedAttr = cur_at

        self.BaseWin.Attr_LineEdit.setText(detachedAttr)


    def command_Bake(self):
        msg = ''

        # get controller
        cur_CtrlName = self.BaseWin.Ctrl_LineEdit.text()
        cur_Ctrl = None
        try :

            cur_Ctrl = pymxsLib.get_INode_ByName( cur_CtrlName )
        except :
            msg += 'Wrong Ctrl Name. Please Check.\n'

        # get Attr
        cur_AttrName = self.BaseWin.Attr_LineEdit.text()
        try :
            cur_attrList = pymxsLib.get_INode_AttrList(cur_Ctrl, attrOrigName=True)
            if cur_AttrName not in cur_attrList :
                msg += 'Wrong Attr Name. Please Check.\n'
        except :
            msg += 'Wrong Attr Name. Please Check.\n'

        cur_AttrName = self.BaseWin.Attr_LineEdit.text()

        # get Before Value
        cur_beforeValue = eval( self.BaseWin.Before_AttrValue_LineEdit.text() )
        cur_afterValue = eval( self.BaseWin.After_AttrValue_LineEdit.text() )

        if self.BaseWin.CustomBakeFrame_CheckBox.isChecked():
            cur_startFrame = eval(self.BaseWin.StartFrame_LineEdit.text())
            cur_endFrame = eval(self.BaseWin.EndFrame_LineEdit.text())

        else :
            cur_startFrame = pymxsLib.get_startFrame()
            cur_endFrame = pymxsLib.get_endFrame()

        # 에러 체크
        if msg :
            raise Exception(msg)

        # ====================================
        # bake
        # ====================================
        cur_ModifierList = list(cur_Ctrl.modifiers) + [cur_Ctrl.baseObject]
        topModifiter = cur_ModifierList[0]
        frameDict = {}
        frameList = range(cur_startFrame, cur_endFrame + 1, 1)

        # get Datas
        for f in frameList:
            pymxsLib.set_sliderTime(f)
            frameDict[str(f)] = pymxsLib.get_INode_world_matrix3( cur_Ctrl )

        # set Datas
        # bake
        for f in frameList:
            pymxsLib.set_sliderTime(f)
            frameData = frameDict[str(f)]

            # set Pose
            with pymxs.animate(True):
                # for debug
                # print 'cur_Ctrl'
                # print cur_Ctrl
                # print 'cur_AttrName'
                # print cur_AttrName
                # print 'cur_afterValue'
                # print cur_afterValue

                setattr(topModifiter, cur_AttrName, cur_afterValue)
                pymxsLib.set_INode_world_matrix3(cur_Ctrl, frameData)

        # redraw
        pymxsLib.set_redrawViews()


        # checkBox가 켜져있다면
        # get startFrame
        # get end frame

        #print 'command_Bake'

    def command_CustomBakeFrame_CheckBox(self):
        checkBox = self.BaseWin.CustomBakeFrame_CheckBox

        if checkBox.isChecked() == True :
            self.BaseWin.StartFrame_LineEdit.setEnabled(True)
            self.BaseWin.EndFrame_LineEdit.setEnabled(True)
        else :
            self.BaseWin.StartFrame_LineEdit.setEnabled(False)
            self.BaseWin.EndFrame_LineEdit.setEnabled(False)