# -*-coding: utf-8-*-
import os
import MaxPlus as mp
import pymxs
import utils.system as utils_system
import utils.ui as utils_ui
import utils.pymxsLib as pymxsLib
import marionetteData

# Pyside 처리
try:
    from PySide.QtGui import *
    from PySide import QtCore, QtUiTools
except ImportError:
    from PySide2.QtGui import *
    from PySide2.QtWidgets import *
    from PySide2 import QtCore, QtUiTools


def openWindow():
    baseWin = MainUI()
    baseWin.show()


class MainUI():

    def __init__(self):
        uiPath = utils_system.get_ui_main()
        self.curObjects = []
        self.BaseWin = utils_ui.MaxBaseWidget_byUI(uiPath, title='CHTool_Marionette').get_window()

        # UI 구성
        imagePath = '{}/{}'.format(utils_system.get_imageDir(), 'CHFace.jpg')
        _image = QPixmap(imagePath)
        self.BaseWin.Image_Label.setPixmap(_image)

        # 버튼들 연결
        self.BaseWin.AllFK_FrameCustom_CheckBox.stateChanged.connect(lambda evt=None : self.command_AllFK_FrameCustom_CheckBox() )
        self.BaseWin.AllFKBake_Btn.clicked.connect(lambda evt=None : self.command_AllFKBake_Btn() )
        # self.BaseWin.AutoCheck_Btn.clicked.connect(lambda evt=None : self.command_AutoCheck_Attr() )
        # self.BaseWin.Bake_Btn.clicked.connect(lambda evt=None : self.command_Bake() )


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
    #
    # def command_Bake(self):
    #     msg = ''
    #
    #     # get controller
    #     cur_CtrlName = self.BaseWin.Ctrl_LineEdit.text()
    #     cur_Ctrl = None
    #     try :
    #
    #         cur_Ctrl = pymxsLib.get_INode_ByName( cur_CtrlName )
    #     except :
    #         msg += 'Wrong Ctrl Name. Please Check.\n'
    #
    #     # get Attr
    #     cur_AttrName = self.BaseWin.Attr_LineEdit.text()
    #     try :
    #         cur_attrList = pymxsLib.get_INode_AttrList(cur_Ctrl, attrOrigName=True)
    #         if cur_AttrName not in cur_attrList :
    #             msg += 'Wrong Attr Name. Please Check.\n'
    #     except :
    #         msg += 'Wrong Attr Name. Please Check.\n'
    #
    #     cur_AttrName = self.BaseWin.Attr_LineEdit.text()
    #
    #     # get Before Value
    #     cur_beforeValue = eval( self.BaseWin.Before_AttrValue_LineEdit.text() )
    #     cur_afterValue = eval( self.BaseWin.After_AttrValue_LineEdit.text() )
    #
    #     if self.BaseWin.AllFK_FrameCustom_CheckBox.isChecked():
    #         cur_startFrame = eval(self.BaseWin.AllFK_StartFrame_LineEdit.text())
    #         cur_endFrame = eval(self.BaseWin.AllFK_EndFrame_LineEdit.text())
    #
    #     else :
    #         cur_startFrame = pymxsLib.get_startFrame()
    #         cur_endFrame = pymxsLib.get_endFrame()
    #
    #     # 에러 체크
    #     if msg :
    #         raise Exception(msg)
    #
    #     # ====================================
    #     # bake
    #     # ====================================
    #     cur_ModifierList = list(cur_Ctrl.modifiers) + [cur_Ctrl.baseObject]
    #     topModifiter = cur_ModifierList[0]
    #     frameDict = {}
    #     frameList = range(cur_startFrame, cur_endFrame + 1, 1)
    #
    #     # get Datas
    #     for f in frameList:
    #         pymxsLib.set_sliderTime(f)
    #         frameDict[str(f)] = pymxsLib.get_INode_world_matrix3( cur_Ctrl )
    #
    #     # set Datas
    #     # bake
    #     for f in frameList:
    #         pymxsLib.set_sliderTime(f)
    #         frameData = frameDict[str(f)]
    #
    #         # set Pose
    #         with pymxs.animate(True):
    #             # for debug
    #             print 'cur_Ctrl'
    #             print cur_Ctrl
    #             print 'cur_AttrName'
    #             print cur_AttrName
    #             print 'cur_afterValue'
    #             print cur_afterValue
    #
    #             setattr(topModifiter, cur_AttrName, cur_afterValue)
    #             pymxsLib.set_INode_world_matrix3(cur_Ctrl, frameData)
    #
    #     # redraw
    #     pymxsLib.set_redrawViews()
    #
    #
    #     # checkBox가 켜져있다면
    #     # get startFrame
    #     # get end frame
    #
    #
    #
    #     print 'command_Bake'

    def command_AllFK_FrameCustom_CheckBox(self):
        checkBox = self.BaseWin.AllFK_FrameCustom_CheckBox

        if checkBox.isChecked() == True :
            self.BaseWin.AllFK_StartFrame_LineEdit.setEnabled(True)
            self.BaseWin.AllFK_EndFrame_LineEdit.setEnabled(True)
        else :
            self.BaseWin.AllFK_StartFrame_LineEdit.setEnabled(False)
            self.BaseWin.AllFK_EndFrame_LineEdit.setEnabled(False)

    def command_AllFKBake_Btn(self):
        checkBox = self.BaseWin.AllFK_FrameCustom_CheckBox

        if checkBox.isChecked() == True :
            startFrame = eval( self.BaseWin.AllFK_StartFrame_LineEdit.text() )
            endFrame = eval( self.BaseWin.AllFK_EndFrame_LineEdit.text() )

        else :
            startFrame = pymxsLib.get_startFrame()
            endFrame = pymxsLib.get_endFrame()

        # frame cycle
        frameList = range(startFrame, endFrame + 1, 1)

        # =========================================
        # get Data
        # =========================================
        # MatrixDataSet (['1'] == [ (CtrlA, CtrlA_Mtx) ...()..] )
        mtxData = {}
        for f in frameList:
            # move frame
            pymxsLib.set_sliderTime(f)
            CtrlList = [ pymxsLib.get_INode_ByName(ctrl) for ctrl, tar in  marionetteData.Data_MatchingList ]
            mtxList = [ pymxsLib.get_INode_world_matrix3( pymxsLib.get_INode_ByName(tar) )
                            for ctrl, tar in marionetteData.Data_MatchingList]
            mtxData[str(f)] = zip(CtrlList, mtxList)

        # =========================================
        # set Data
        # =========================================
        for f in frameList:
            # move frame
            pymxsLib.set_sliderTime(f)
            curMtxData = mtxData[str(f)]
            # for debug
            # print 'curMtxData'
            # print curMtxData

            with pymxs.animate(True):
                # set All FK Mode ==========================
                for ctrlName, AttrName, val in marionetteData.Data_SetList:
                    Ctrl = pymxsLib.get_INode_ByName(ctrlName)
                    # setattr(Ctrl, AttrName, val)
                    pymxsLib.set_INode_Attr(Ctrl, AttrName, val)
                # ==========================================

                # set Matrix by mtxData ==========================
                # mtxData[str(f)] = (CtrlList, mtxList)
                for ctrl, mtx in curMtxData :
                    pymxsLib.set_INode_world_matrix3(ctrl, mtx)

                # print 'curMtxData[0]'
                # _ctrlList = curMtxData[0]
                # print 'curMtxData[1]'
                # _mtxList = curMtxData[1]
                # for i, ctrl in enumerate(_ctrlList):
                #     mtx = _mtxList[i]
                #     pymxsLib.set_INode_world_matrix3(ctrl, mtx)


                # for CtrlList, mtxList  in zip(curMtxData[0], curMtxData[1]) :
                #     # print 'DataTuple'
                #     # print DataTuple
                #     # CtrlList = DataTuple[0]
                #     # mtxList = DataTuple[1]
                #     for ctrl, mtx in zip(CtrlList, mtxList) :
                #         print 'ctrl'
                #         print ctrl
                #         print 'mtx'
                #         print mtx
                #         pymxsLib.set_INode_world_matrix3(ctrl, mtx)
                # ==========================================

        print 'check'






