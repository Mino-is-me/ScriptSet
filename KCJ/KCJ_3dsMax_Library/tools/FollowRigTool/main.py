# -*-coding: utf-8-*-
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
    baseWin = FollowRigTool()
    baseWin.show()


class FollowRigTool():

    def __init__(self):
        uiPath = utils_system.get_ui_main()
        self.curObjects = []
        self.BaseWin = utils_ui.MaxBaseWidget_byUI(uiPath, title='FollowRigTool').get_window()


        # # 버튼들 연결
        self.BaseWin.AutoParent_CheckBox.stateChanged.connect(lambda evt=None : self.command_AutoParent_CheckBox() )

        self.BaseWin.SpaceA_NodeParent_Btn.clicked.connect(lambda evt=None: self.command_SpaceA_NodeParent_Btn())
        self.BaseWin.SpaceB_NodeParent_Btn.clicked.connect(lambda evt=None: self.command_SpaceB_NodeParent_Btn())

        self.BaseWin.Set_Btn.clicked.connect(lambda evt=None : self.command_Set_Btn() )

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
    def command_SpaceA_NodeParent_Btn(self):
        # check
        selList = pymxsLib.get_selected()
        if len(selList) == 0 : return
        
        # get datas
        sel = selList[-1]
        cur_name = pymxsLib.get_INode_name(sel)
        cur_handle = pymxsLib.get_INode_handle(sel)

        # set data
        dataText = '{},{}'.format( cur_name, cur_handle)
        self.BaseWin.SpaceA_NodeParent_LineEdit.setText( dataText )

    def command_SpaceB_NodeParent_Btn(self):
        # check
        selList = pymxsLib.get_selected()
        if len(selList) == 0: return

        # get datas
        sel = selList[-1]
        cur_name = pymxsLib.get_INode_name(sel)
        cur_handle = pymxsLib.get_INode_handle(sel)

        # set data
        dataText = '{},{}'.format(cur_name, cur_handle)
        self.BaseWin.SpaceB_NodeParent_LineEdit.setText(dataText)

    def command_AutoParent_CheckBox(self):
        checkBox = self.BaseWin.AutoParent_CheckBox

        if checkBox.isChecked() == True :
            self.BaseWin.SpaceA_NodeParent_Label.setEnabled(True)
            self.BaseWin.SpaceA_NodeParent_LineEdit.setEnabled(True)
            self.BaseWin.SpaceA_NodeParent_Btn.setEnabled(True)

            self.BaseWin.SpaceB_NodeParent_Label.setEnabled(True)
            self.BaseWin.SpaceB_NodeParent_LineEdit.setEnabled(True)
            self.BaseWin.SpaceB_NodeParent_Btn.setEnabled(True)

        else :
            self.BaseWin.SpaceA_NodeParent_Label.setEnabled(False)
            self.BaseWin.SpaceA_NodeParent_LineEdit.setEnabled(False)
            self.BaseWin.SpaceA_NodeParent_Btn.setEnabled(False)

            self.BaseWin.SpaceB_NodeParent_Label.setEnabled(False)
            self.BaseWin.SpaceB_NodeParent_LineEdit.setEnabled(False)
            self.BaseWin.SpaceB_NodeParent_Btn.setEnabled(False)

    def command_Set_Btn(self):

        # input Data
        SpaceAName = self.BaseWin.FollowA_LineEdit.text()
        SpaceBName = self.BaseWin.FollowB_LineEdit.text()
        # print 'check1'
        AttrName = 'Follow_{}_{}'.format(SpaceAName.replace(' ', '_'), SpaceBName.replace(' ', '_') )
        # SpaceAParent = NodeName, 4(HandelNum)
        SpaceAParentDataText = self.BaseWin.SpaceA_NodeParent_LineEdit.text()
        SpaceBParentDataText = self.BaseWin.SpaceB_NodeParent_LineEdit.text()
        # print 'check2'

        ConstraintedType = self.BaseWin.ConstraintedTarget_ComboBox.currentText()
        # ================================================
        # check Part
        # ================================================
        errorMessage = ''
        if not SpaceAName :
            errorMessage += 'Input SpaceA Name. CurName {}'.format(SpaceAName)
        if not SpaceBName :
            errorMessage += 'Input SpaceA Name. CurName {}'.format(SpaceBName)
        if self.BaseWin.AutoParent_CheckBox.isChecked() :
            if not SpaceAParentDataText :
                errorMessage += 'SpaceAParent is not Input.'
            if not SpaceBParentDataText :
                errorMessage += 'SpaceBParent is not Input.'

        # check Parent
        if ConstraintedType == 'Parent_Of_Selected' :
            for sel in pymxsLib.get_selected():
                if pymxsLib.get_INode_parent(sel) == None:
                    errorMessage += 'Do Not Have Parent : curObj : {}'.format(sel.name)

        if errorMessage != '':
            raise Exception(errorMessage)



        # 데이터 정의
        if self.BaseWin.AutoParent_CheckBox.isChecked():
            SpaceAParent = pymxsLib.get_INode_ByHandleNum( eval( SpaceAParentDataText.split(',')[1] ) )
            SpaceBParent = pymxsLib.get_INode_ByHandleNum( eval( SpaceBParentDataText.split(',')[1] ) )
        else :
            SpaceAParent = None
            SpaceBParent = None
        # print 'check3'


        # ================================================
        # Process
        # ================================================

        # audo를 넣으면 오류가 떠서 비활성화 시켜놓음.
        with pymxs.undo(True, 'command_SetUp_FollowRigTool'):
            for sel in pymxsLib.get_selected() :
                #sel =  pymxsLib.get_selected()[0]
                if ConstraintedType == 'Parent_Of_Selected' :
                    constTarget = pymxsLib.get_INode_parent( sel )
                else :
                    constTarget = sel

                # print 'check4'
                # ==============================================
                # node 생성
                # ==============================================
                targetMtx = pymxsLib.get_INode_world_matrix3( constTarget )

                name = '{}_Follow_{}'.format(pymxsLib.get_INode_name( constTarget), SpaceAName )
                point_SpaceA = pymxsLib.create_point(name=name, cross=0, box=0, axisTripod=0, centerMarker=0)
                pymxsLib.set_INode_world_matrix3(point_SpaceA, targetMtx )

                name = '{}_Follow_{}'.format(pymxsLib.get_INode_name( constTarget), SpaceBName )
                point_SpaceB = pymxsLib.create_point(name=name, cross=0, box=0, axisTripod=0, centerMarker=0)
                pymxsLib.set_INode_world_matrix3(point_SpaceB, targetMtx )
                # print 'check5'
                # ==============================================
                # Attr만들기
                # ==============================================
                pymxsLib.create_floatAttr_slider(sel, attrName = AttrName, minVal=0, maxVal=100, defaultVal=0)
                # print 'check6'
                # ==============================================
                # const
                # ==============================================
                # reset
                pymxsLib.set_reset_TransformController( constTarget )

                # point
                pymxsLib.set_Position_Constraint_Blend(DrvA = point_SpaceA,
                                                          DrvB = point_SpaceB,
                                                          OutNode = constTarget,
                                                          AdjustCtrl = sel,
                                                          BlendAttrName = AttrName)
                # rotate
                pymxsLib.set_Orientation_Constraint_Blend(DrvA = point_SpaceA,
                                                          DrvB = point_SpaceB,
                                                          OutNode = constTarget,
                                                          AdjustCtrl = sel,
                                                          BlendAttrName = AttrName)
                # print 'check7'
                # ==============================================
                # Auto Parent
                # ==============================================
                if self.BaseWin.AutoParent_CheckBox.isChecked():
                    pymxsLib.set_INode_parent(point_SpaceA, SpaceAParent)
                    pymxsLib.set_INode_parent(point_SpaceB, SpaceBParent)



