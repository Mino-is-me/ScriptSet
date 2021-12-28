# -*-coding: utf-8-*-
import os
import MaxPlus as mp
import pymxs
import utils.system as utils_system
import utils.ui as utils_ui
import utils.pymxsPlus as pm

# Pyside 처리
try:
    from PySide.QtGui import *
    from PySide import QtCore, QtUiTools
except ImportError:
    from PySide2.QtGui import *
    from PySide2.QtWidgets import *
    from PySide2 import QtCore, QtUiTools


def openWindow():
    baseWin = IKFKTrader()
    baseWin.show()



def get_NameHandleText_drvTar(drv, tar):
    drvText = get_NameHandleText(drv)
    tarText = get_NameHandleText(tar)
    text = '{} ---> {}'.format(drvText, tarText)
    return text


def get_PymxsPlus_DrvTarNode_ByNose(text):
    drvText, tarText = text.split(' ---> ')
    drv = get_PymxsPlusNode_ByText(drvText)
    tar = get_PymxsPlusNode_ByText(tarText)

    return [drv, tar]

def get_PymxsPlus_DrvTarNode_ByName(text):
    drvText, tarText = text.split(' ---> ')
    drv = drvText.split(':')[0]
    tar = tarText.split(':')[0]

    return [drv, tar]


def get_NameHandleText(PymxsNodePlus) :

    ctrlName = PymxsNodePlus.get_name()
    ctrlHandle = PymxsNodePlus.get_handle()
    text = '{}:{}'.format(ctrlName, ctrlHandle)
    return text

def get_PymxsPlusNode_ByText(text) :
    ctrlName, ctrlHandle = text.split(':')
    ctrlHandle = eval(ctrlHandle)

    Result_Node = pm.get_PyNodePlus_byName( ctrlName )
    return Result_Node


def get_infoDataDict(name, type, filePath = ''):
    return {'name':name,
            'type':type,
            'filePath' : filePath}

def get_targetList_worldMtx(  targetList ) :
    # 데이터 구하기
    targetList_worldMtx = []
    for tar in targetList:
        mtx = tar.get_world_matrix()
        targetList_worldMtx.append(mtx)

    return targetList_worldMtx

# ===================================
# 소스들
# ===================================

class IKFKTrader():

    def __init__(self):
        uiPath = utils_system.get_ui_main()
        self.curObjects = []
        self.BaseWin = utils_ui.MaxBaseWidget_byUI(uiPath, title='IKFKTrader').get_window()
        self.curJsonFileList = []

        # update / Json 파일이 존재하다면.
        self.LoadDataList = []
        curJsonFileList = utils_system.get_cur_JsonDataList(fullPath = True)

        for jsonFilePath in curJsonFileList :
            fileName = os.path.basename(jsonFilePath ).split('.')[0]
            dataDict = get_infoDataDict( name = fileName, type = 'json', filePath = jsonFilePath)
            self.LoadDataList.append( dataDict )

        # Data가 존재하다면 UI 업데이트
        # Data ComboBox 업데이트
        self.updataUI_CurData_ComboBox( self.LoadDataList )

        # Data IKFK 업데이트
        if self.LoadDataList :
            if self.LoadDataList[0]['type'] =='json' :
                self.updataUI_byJson(filePath= self.LoadDataList[0]['filePath'] )

            # todo : node 버전 처리
            # 차후




        # self.set_addFuntion()

        # 기본 기능들

        self.BaseWin.CustomBakeFrame_CheckBox.stateChanged.connect(lambda evt=None : self.command_CustomBakeFrame_CheckBox() )
        self.BaseWin.IKInfo_Add_Button.clicked.connect(lambda evt=None : self.command_IKInfo_Add_Button() )
        self.BaseWin.FKInfo_Add_Button.clicked.connect(lambda evt=None : self.command_FKInfo_Add_Button() )
        self.BaseWin.IKInfo_ItemUp_Btn.clicked.connect(lambda evt=None : self.command_IKInfo_ItemUp_Btn() )
        self.BaseWin.IKInfo_ItemDn_Btn.clicked.connect(lambda evt=None : self.command_IKInfo_ItemDn_Btn() )
        self.BaseWin.FKInfo_ItemUp_Btn.clicked.connect(lambda evt=None : self.command_FKInfo_ItemUp_Btn() )
        self.BaseWin.FKInfo_ItemDn_Btn.clicked.connect(lambda evt=None : self.command_FKInfo_ItemDn_Btn() )

        self.BaseWin.IKInfo_Del_Button.clicked.connect(lambda evt=None : self.set_IKInfo_listWidget_removeSel() )
        self.BaseWin.FKInfo_Del_Button.clicked.connect(lambda evt=None : self.set_FKInfo_listWidget_removeSel() )

        self.BaseWin.Ctrl_Add_Button.clicked.connect(lambda evt=None : self.command_Ctrl_Add_Button() )

        self.BaseWin.Save_json_Btn.clicked.connect(lambda evt=None : self.command_Save_json_Btn() )
        self.BaseWin.CurData_ComboBox.currentIndexChanged.connect(lambda evt=None : self.command_CurData_ComboBox() )

        self.BaseWin.Mode_IK_Btn.clicked.connect(lambda evt=None : self.command_Mode_IK_Btn() )
        self.BaseWin.Mode_FK_Btn.clicked.connect(lambda evt=None : self.command_Mode_FK_Btn() )
        self.BaseWin.Bake_IK_Btn.clicked.connect(lambda evt=None : self.command_Bake_IK_Btn() )
        self.BaseWin.Bake_FK_Btn.clicked.connect(lambda evt=None : self.command_Bake_FK_Btn() )

        # extra
        self.BaseWin.Reset_IK_Btn.clicked.connect(lambda evt=None : self.command_Reset_IK_Btn() )
        self.BaseWin.Reset_FK_Btn.clicked.connect(lambda evt=None : self.command_Reset_FK_Btn() )
        self.BaseWin.Select_IK_Btn.clicked.connect(lambda evt=None : self.command_Select_IK_Btn() )
        self.BaseWin.Select_FK_Btn.clicked.connect(lambda evt=None : self.command_Select_FK_Btn() )
        self.BaseWin.VisToggle_IK_Btn.clicked.connect(lambda evt=None : self.command_VisToggle_IK_Btn() )
        self.BaseWin.VisToggle_FK_Btn.clicked.connect(lambda evt=None : self.command_VisToggle_FK_Btn() )




    # ===============================
    # 기본 기능들
    # ===============================

    def get_baseWin(self):
        return self.BaseWin

    def show(self):
        self.get_baseWin().show()

    # =================================
    # UI 커맨더들
    # =================================
    def command_Reset_IK_Btn(self):
        # cur IKNodes
        # [ PymxsNodeA, pymxsNodeB] 이렇게 얻고 있다.
        try :
            CtrlList = [ CtrlTarList[0] for CtrlTarList in self.get_IKInfo_listWidget_Items_WithNode() ]
            for Ctrl in CtrlList:
                BaseMtx = pm.get_matrixPlus()
                Ctrl.set_local_matrix( BaseMtx )
            pm.redrawViews()

        except :
            print "Can't Find Nodes Plese Check Ctrl Name! "

    def command_Reset_FK_Btn(self):
        # cur IKNodes
        # [ PymxsNodeA, pymxsNodeB] 이렇게 얻고 있다.
        try:
            CtrlList = [CtrlTarList[0] for CtrlTarList in self.get_FKInfo_listWidget_Items_WithNode()]
            for Ctrl in CtrlList:
                BaseMtx = pm.get_matrixPlus()
                Ctrl.set_local_matrix(BaseMtx)
            pm.redrawViews()

        except:
            print "Can't Find Nodes Plese Check Ctrl Name! "


    def command_Select_IK_Btn(self):
        # cur IKNodes
        # [ PymxsNodeA, pymxsNodeB] 이렇게 얻고 있다.
        try :
            CtrlList = [ CtrlTarList[0] for CtrlTarList in self.get_IKInfo_listWidget_Items_WithNode() ]
            pm.set_select( CtrlList )
            pm.redrawViews()
        except :
            print "Can't Find Nodes Plese Check Ctrl Name! "

    def command_Select_FK_Btn(self):
        try :
            CtrlList = [ CtrlTarList[0] for CtrlTarList in self.get_FKInfo_listWidget_Items_WithNode() ]
            pm.set_select( CtrlList )
            pm.redrawViews()
        except :
            print "Can't Find Nodes Plese Check Ctrl Name! "

    def command_VisToggle_IK_Btn(self):
        try :
            # input
            CtrlList = [ CtrlTarList[0] for CtrlTarList in self.get_IKInfo_listWidget_Items_WithNode() ]

            # process
            curVal = CtrlList[0].get_visibility()
            for Ctrl in CtrlList:
                if curVal == True:
                    Ctrl.set_visibility(False)
                else:
                    Ctrl.set_visibility(True)

            pm.redrawViews()

        except :
            print "Can't Find Nodes Plese Check Ctrl Name! "


    def command_VisToggle_FK_Btn(self):

        try:
            # input
            CtrlList = [CtrlTarList[0] for CtrlTarList in self.get_FKInfo_listWidget_Items_WithNode()]

            # process
            curVal = CtrlList[0].get_visibility()
            for Ctrl in CtrlList:
                if curVal == True:
                    Ctrl.set_visibility(False)
                else:
                    Ctrl.set_visibility(True)
            pm.redrawViews()

        except:
            print "Can't Find Nodes Plese Check Ctrl Name! "

    def command_Bake_IK_Btn(self):
        with pymxs.undo(True, 'command_Bake_IK_Btn'):
            # 정보 구하기
            DataDict = self.get_cur_data_withCheck()

            nodeList = DataDict['IKNodeList']
            nodeList_opp = DataDict['FKNodeList']
            targetList = DataDict['IKTarList']
            IKFKSet_Ctrl = DataDict['ctrl']
            IKFKAttr = self.get_curInfo_CtrlAttr()
            AttrVal = self.get_IKVal()



            # key 프레임 변경하면서 데이터 얻기
            frameDict = {}
            startFrame, EndFrame = self.get_cur_minMaxFrame()
            frameList = range( startFrame, EndFrame+1, 1)
            for f in frameList :
                pm.set_sliderTime(f)
                frameDict[str(f)] = get_targetList_worldMtx( targetList )

            # bake
            for f in frameList :
                pm.set_sliderTime(f)
                frameData = frameDict[str(f)]
                # set Pose
                for _node, Mtx in zip(nodeList, frameData) :
                   with pymxs.animate(True):
                        _node.set_world_matrix( Mtx )
                        setattr(IKFKSet_Ctrl.get_INode(), IKFKAttr, AttrVal)


            # redraw
            pm.redrawViews()

    def command_Bake_FK_Btn(self):
        with pymxs.undo(True, 'command_Bake_FK_Btn'):
            # 정보 구하기
            DataDict = self.get_cur_data_withCheck()

            nodeList = DataDict['FKNodeList']
            nodeList_opp = DataDict['IKNodeList']
            targetList = DataDict['FKTarList']
            IKFKSet_Ctrl = DataDict['ctrl']
            IKFKAttr = self.get_curInfo_CtrlAttr()
            AttrVal = self.get_FKVal()



            # key 프레임 변경하면서 데이터 얻기
            frameDict = {}
            startFrame, EndFrame = self.get_cur_minMaxFrame()
            frameList = range( startFrame, EndFrame+1, 1)
            for f in frameList :
                pm.set_sliderTime(f)
                frameDict[str(f)] = get_targetList_worldMtx( targetList )

            # bake
            for f in frameList :
                pm.set_sliderTime(f)
                frameData = frameDict[str(f)]
                # set Pose
                for _node, Mtx in zip(nodeList, frameData) :
                   with pymxs.animate(True):
                        _node.set_world_matrix( Mtx )
                        setattr(IKFKSet_Ctrl.get_INode(), IKFKAttr, AttrVal)


            # redraw
            pm.redrawViews()



    def command_CurData_ComboBox(self):
        dataName, dataType = self.get_CurData_ComboBox_text().split(':')
        if dataType == 'json':
            jsonDataList = [ data for data in self.LoadDataList if data['type'] == 'json' ]
            for jsonData in jsonDataList :
                if jsonData['name'] == dataName :
                    self.updataUI_byJson( filePath= jsonData['filePath'] )
        # 노드 타입은 차후 하기로



    def command_Save_json_Btn(self):
        ctrlInfo = self.get_cur_Ctrl_Info()
        ctrlAttr = self.get_curInfo_CtrlAttr()
        IKValue = self.get_IKVal()
        FKValue = self.get_FKVal()

        IKInfoList = self.get_IKInfo_listWidget_Items()
        FKInfoList = self.get_FKInfo_listWidget_Items()


        dataDict = {'ctrlInfo' : ctrlInfo,
                    'ctrlAttr': ctrlAttr,
                    'IKValue': IKValue,
                    'FKValue': FKValue,
                    'IKInfoList': IKInfoList,
                    'FKInfoList': FKInfoList
                    }

        filePath  = QFileDialog.getSaveFileName(self.BaseWin,
                                                "Save file",
                                                utils_system.get_dataDir(),
                                                "Json Files(*.json)" )[0]

        utils_system.save_dataJson( dataDict=dataDict, filePath = filePath )

    def command_Mode_IK_Btn(self):
        with pymxs.undo(True, 'command_Mode_IK_Btn') :
            # 정보 구하기
            DataDict = self.get_cur_data_withCheck()

            nodeList = DataDict['IKNodeList']
            nodeList_opp = DataDict['FKNodeList']
            targetList = DataDict['IKTarList']
            IKFKSet_Ctrl = DataDict['ctrl']
            IKFKAttr = self.get_curInfo_CtrlAttr()
            AttrVal = self.get_IKVal()

            # 데이터 구하기
            targetList_worldMtx = []
            for tar  in targetList :
                mtx = tar.get_world_matrix()
                targetList_worldMtx.append( mtx )

            # 데이터 변경
            for i, _node in enumerate(nodeList) :
                _node.set_world_matrix( targetList_worldMtx[i] )

            # set Value, Hide
            setattr(IKFKSet_Ctrl.get_INode(), IKFKAttr, AttrVal)

            # redraw
            pm.redrawViews()

    def command_Mode_FK_Btn(self):
        with pymxs.undo(True, 'command_Mode_FK_Btn'):
            # 정보 구하기
            DataDict = self.get_cur_data_withCheck()

            nodeList = DataDict['FKNodeList']
            nodeList_opp = DataDict['IKNodeList']
            targetList = DataDict['FKTarList']
            IKFKSet_Ctrl = DataDict['ctrl']
            IKFKAttr = self.get_curInfo_CtrlAttr()
            AttrVal = self.get_FKVal()

            # 데이터 구하기
            targetList_worldMtx = []
            for tar  in targetList :
                mtx = tar.get_world_matrix()
                targetList_worldMtx.append( mtx )

            # 데이터 변경
            for i, _node in enumerate(nodeList) :
                _node.set_world_matrix( targetList_worldMtx[i] )

            # set Value, Hide
            setattr(IKFKSet_Ctrl.get_INode(), IKFKAttr, AttrVal)

            # redraw
            pm.redrawViews()


    def command_CustomBakeFrame_CheckBox(self):
        if self.get_customBakeFrame() == True :
            self.BaseWin.StartFrame_LineEdit.setEnabled(True)
            self.BaseWin.EndFrame_LineEdit.setEnabled(True)
        else :
            self.BaseWin.StartFrame_LineEdit.setEnabled(False)
            self.BaseWin.EndFrame_LineEdit.setEnabled(False)

    def command_IKInfo_Add_Button(self):

        items = []
        selList = pm.get_currentSelection()
        if len(selList) != 2 : return
        drv, tar = selList

        itme = get_NameHandleText_drvTar(drv, tar)

        # update
        self.BaseWin.IKInfo_listWidget.addItem(itme)

    def command_IKInfo_ItemUp_Btn(self):

        # ==========================================
        # inputs
        # ==========================================
        # debug
        #print 'command_IKInfo_ItemUp_Btn'
        listWidget = self.BaseWin.IKInfo_listWidget
        # up, down에 따라 item 순서가 달라집니다.
        moveType = 'up'

        # ==========================================
        # process
        # ==========================================

        # # 현재의 선택된 아이템을 얻는다.
        curSelectedItems = listWidget.selectedItems()
        if curSelectedItems == []: return

        curSelItem = curSelectedItems[0]
        curSelItem_text = curSelItem.text()

        # 순서를 변경한다.
        if moveType == 'up' :
            curIndex = listWidget.indexFromItem(curSelItem).row()
            newIndex = curIndex - 1 if curIndex > 0 else 0
        else :
            maxCount = listWidget.count()
            curIndex = listWidget.indexFromItem(curSelItem).row()
            newIndex = curIndex + 1 if curIndex > maxCount else maxCount

        # debug
        # print 'curIndex'
        # print curIndex
        # print 'newIndex'
        # print newIndex

        # UI 변경
        self.setChangeNumItemByText(listWidget, newIndex, curSelItem_text)

        # 선택 (보기편하게)
        curItem = listWidget.findItems(curSelItem_text, QtCore.Qt.MatchExactly)[0]
        listWidget.setCurrentItem( curItem )



    def command_IKInfo_ItemDn_Btn(self):
        # ==========================================
        # inputs
        # ==========================================
        # debug
        # print 'command_IKInfo_ItemUp_Btn'
        listWidget = self.BaseWin.IKInfo_listWidget
        # up, down에 따라 item 순서가 달라집니다.
        moveType = 'down'

        # ==========================================
        # process
        # ==========================================

        # # 현재의 선택된 아이템을 얻는다.
        curSelectedItems = listWidget.selectedItems()
        if curSelectedItems == []: return

        curSelItem = curSelectedItems[0]
        curSelItem_text = curSelItem.text()

        # 순서를 변경한다.
        if moveType == 'up':
            curIndex = listWidget.indexFromItem(curSelItem).row()
            newIndex = curIndex - 1 if curIndex > 0 else 0
        else:
            maxCount = listWidget.count()
            curIndex = listWidget.indexFromItem(curSelItem).row()
            newIndex = curIndex + 1 if curIndex < maxCount else maxCount

        # debug
        # print 'curIndex'
        # print curIndex
        # print 'newIndex'
        # print newIndex

        # UI 변경
        self.setChangeNumItemByText(listWidget, newIndex, curSelItem_text)

        # 선택 (보기편하게)
        curItem = listWidget.findItems(curSelItem_text, QtCore.Qt.MatchExactly)[0]
        listWidget.setCurrentItem(curItem)


    def command_FKInfo_ItemUp_Btn(self):

        # ==========================================
        # inputs
        # ==========================================
        # debug
        #print 'command_FKInfo_ItemUp_Btn'
        listWidget = self.BaseWin.FKInfo_listWidget
        # up, down에 따라 item 순서가 달라집니다.
        moveType = 'up'

        # ==========================================
        # process
        # ==========================================

        # # 현재의 선택된 아이템을 얻는다.
        curSelectedItems = listWidget.selectedItems()
        if curSelectedItems == []: return

        curSelItem = curSelectedItems[0]
        curSelItem_text = curSelItem.text()

        # 순서를 변경한다.
        if moveType == 'up' :
            curIndex = listWidget.indexFromItem(curSelItem).row()
            newIndex = curIndex - 1 if curIndex > 0 else 0
        else :
            maxCount = listWidget.count()
            curIndex = listWidget.indexFromItem(curSelItem).row()
            newIndex = curIndex + 1 if curIndex > maxCount else maxCount

        # debug
        # print 'curIndex'
        # print curIndex
        # print 'newIndex'
        # print newIndex

        # UI 변경
        self.setChangeNumItemByText(listWidget, newIndex, curSelItem_text)

        # 선택 (보기편하게)
        curItem = listWidget.findItems(curSelItem_text, QtCore.Qt.MatchExactly)[0]
        listWidget.setCurrentItem( curItem )


    def command_FKInfo_ItemDn_Btn(self):
        # ==========================================
        # inputs
        # ==========================================
        # debug
        # print 'command_FKInfo_ItemDn_Btn'
        listWidget = self.BaseWin.FKInfo_listWidget
        # up, down에 따라 item 순서가 달라집니다.
        moveType = 'down'

        # ==========================================
        # process
        # ==========================================

        # # 현재의 선택된 아이템을 얻는다.
        curSelectedItems = listWidget.selectedItems()
        if curSelectedItems == []: return

        curSelItem = curSelectedItems[0]
        curSelItem_text = curSelItem.text()

        # 순서를 변경한다.
        if moveType == 'up':
            curIndex = listWidget.indexFromItem(curSelItem).row()
            newIndex = curIndex - 1 if curIndex > 0 else 0
        else:
            maxCount = listWidget.count()
            curIndex = listWidget.indexFromItem(curSelItem).row()
            newIndex = curIndex + 1 if curIndex < maxCount else maxCount

        # debug
        # print 'curIndex'
        # print curIndex
        # print 'newIndex'
        # print newIndex

        # UI 변경
        self.setChangeNumItemByText(listWidget, newIndex, curSelItem_text)

        # 선택 (보기편하게)
        curItem = listWidget.findItems(curSelItem_text, QtCore.Qt.MatchExactly)[0]
        listWidget.setCurrentItem(curItem)

    def setChangeNumItemByText(self, listWidget, index, itemText):
        '''
        :param index: int
        :param itemText: str
        '''

        # 데이터 얻기
        all_itemText = []
        for i in range(listWidget.count()):
            all_itemText.append(listWidget.item(i).text() )
        # # debug
        # print 'all_itemText'
        # print all_itemText

        # 검사 만약 데이터가 있는지 검사
        if itemText not in all_itemText:
            raise Exception('not in widget items. please check! \ncheckItem :{} \ncurItems : {}'.format(itemText, all_itemText))

        # 새로운 데이터 생성 제거
        #all_itemText.remove( all_itemText.index(itemText) )
        all_itemText.remove( itemText )


        # 해당되는 텍스쳐 제거
        all_itemText.insert(index, itemText)

        # debug
        # print 'all_itemText'
        # print all_itemText
        # print 'index'
        # print index
        # print 'itemText'
        # print itemText

        # 리셋후 재 정의
        listWidget.clear()
        listWidget.addItems( all_itemText )


    def command_FKInfo_Add_Button(self):
        items = []
        selList = pm.get_currentSelection()
        if len(selList) != 2 : return
        drv, tar = selList

        itme = get_NameHandleText_drvTar(drv, tar)

        # Update
        self.BaseWin.FKInfo_listWidget.addItem(itme)

    def command_Ctrl_Add_Button(self):
        selList = pm.get_currentSelection()
        if selList == [] : return
        sel = selList[0]
        text = get_NameHandleText( sel )
        self.set_IKFKSetCtrl(text=text)

    # =================================
    # Update : UI
    # =================================
    def updataUI_CurData_ComboBox(self, LoadDataList):
        ComboBox = self.BaseWin.CurData_ComboBox

        for dataDict in LoadDataList:
            curType = dataDict['type']
            if curType =='json':
                fileName = os.path.basename( dataDict['filePath'] ).split('.')[0]
                item = '{}:{}'.format( fileName, 'json' )
                ComboBox.addItem( item )

            elif curType == 'node':
                # 차후 작업
                pass



    def updataUI_byJson(self, filePath):
        # dataDict = {'ctrlInfo' : ctrlInfo,
        #                     'ctrlAttr': ctrlAttr,
        #                     'IKValue': IKValue,
        #                     'FKValue': FKValue,
        #                     'IKInfoList': IKInfoList,
        #                     'FKInfoList': FKInfoList
        #             }
        DataDict = utils_system.load_dataJson(filePath)
        self.clearUI()

        self.set_IKFKSetCtrl( DataDict['ctrlInfo'] )
        self.set_CtrlAttr( DataDict['ctrlAttr'] )
        self.set_IKVal( DataDict['IKValue'] )
        self.set_FKVal( DataDict['FKValue'] )
        self.BaseWin.IKInfo_listWidget.addItems( DataDict['IKInfoList'] )
        self.BaseWin.FKInfo_listWidget.addItems( DataDict['FKInfoList'] )


    def clearUI(self):
        self.set_IKFKSetCtrl( '' )
        self.set_CtrlAttr( '' )
        self.BaseWin.IKInfo_listWidget.clear()
        self.BaseWin.FKInfo_listWidget.clear()

    def check_data(self):
        cur_ctrl = self.get_cur_Ctrl_Info()
        # 에러메세지

    # =================================
    # setter
    # =================================

    def set_IKFKSetCtrl(self, text):
        self.BaseWin.Ctrl_LineEidt.setText(text)

    def set_CtrlAttr(self, text):
        self.BaseWin.CtrlAttr_LineEidt.setText(text)

    def set_FKInfo_listWidget_removeSel(self):
        curListWidget = self.BaseWin.FKInfo_listWidget

        listItems = curListWidget.selectedItems()
        if not listItems: return
        for item in listItems:
            curListWidget.takeItem(curListWidget.row(item))

    def set_IKInfo_listWidget_removeSel(self):
        curListWidget = self.BaseWin.IKInfo_listWidget

        listItems = curListWidget.selectedItems()
        if not listItems: return
        for item in listItems:
            curListWidget.takeItem(curListWidget.row(item))

    def set_customBakeFrame(self, value = True ):
        # set : True or False
        self.BaseWin.CustomBakeFrame_CheckBox.setChecked( value )

    def set_IKVal(self, value =0.0):
        lineEidt = self.BaseWin.IKVal_LineEdit
        lineEidt.setText( str(value) )

    def set_FKVal(self, value =0.0):
        lineEidt = self.BaseWin.FKVal_LineEdit
        lineEidt.setText( str(value) )

    # =================================
    # getter
    # =================================
    def get_cur_data_withCheck(self):
        allObjects = pm.get_allObjects_byName()
        errorList = []
        ctrlName, ctrlHandle = self.get_cur_Ctrl_Info().split(':')
        ctrl = None
        IKNodeList = []
        IKTarList = []
        FKNodeList = []
        FKTarList = []

        # IK Node
        for infoText in self.get_IKInfo_listWidget_Items() :
            IKNode, IKTar = get_PymxsPlus_DrvTarNode_ByName( infoText )
            IKNodeList.append( IKNode)
            IKTarList.append( IKTar )
        # FK Node
        for infoText in self.get_FKInfo_listWidget_Items() :
            FKNode, FKTar = get_PymxsPlus_DrvTarNode_ByName( infoText )
            FKNodeList.append( FKNode)
            FKTarList.append( FKTar )

        # ==============================================
        # check
        # ==============================================

        for nodeName in [ctrlName] + IKNodeList + IKTarList + FKNodeList + FKTarList :
            if pm.is_unique(name=nodeName, checkInList=allObjects) :
                continue
            else :
                errorList.append(nodeName)
        errorList = list(set(errorList))

        if errorList :
            msg = 'Detected Same NameList. please Check Below'
            msg += '============================================='
            for name in errorList : msg+= name+'\n'
            msg += '============================================='

            print msg
            raise ValueError

        # ==============================================
        # return
        # ==============================================
        resultDict = {}
        resultDict['ctrl'] = pm.get_PyNodePlus_byName( ctrlName)
        resultDict['IKNodeList'] = [ pm.get_PyNodePlus_byName( nodeName ) for nodeName in IKNodeList  ]
        resultDict['IKTarList'] = [ pm.get_PyNodePlus_byName( nodeName ) for nodeName in IKTarList  ]
        resultDict['FKNodeList'] = [ pm.get_PyNodePlus_byName( nodeName ) for nodeName in FKNodeList  ]
        resultDict['FKTarList'] = [ pm.get_PyNodePlus_byName( nodeName ) for nodeName in FKTarList  ]

        return resultDict


    def get_cur_minMaxFrame(self):
        customMode = self.BaseWin.CustomBakeFrame_CheckBox.isChecked()

        if  customMode :
            startFrame = eval( self.BaseWin.StartFrame_LineEdit.text() )
            endFrame = eval( self.BaseWin.EndFrame_LineEdit.text() )

        else :
            startFrame =  pm.get_startFrame()
            endFrame = pm.get_endFrame()

        return [int(startFrame), int(endFrame) ]





    def get_CurData_ComboBox_text(self):
        return self.BaseWin.CurData_ComboBox.currentText()

    def get_cur_Ctrl_Info(self):
        return self.BaseWin.Ctrl_LineEidt.text()

    def get_curInfo_CtrlAttr(self):
        return self.BaseWin.CtrlAttr_LineEidt.text()

    def get_customBakeFrame(self ):
        # return : True or False
        return self.BaseWin.CustomBakeFrame_CheckBox.isChecked()

    def get_FKInfo_listWidget_Items_WithNode(self):
        items = self.get_FKInfo_listWidget_Items()
        resultList = []
        # itemText == Box001:2 --> Cone001:3

        for itemText in items:
            result = get_PymxsPlus_DrvTarNode_ByNose(itemText)
            resultList.append( result )

        return resultList

    def get_IKInfo_listWidget_Items_WithNode(self):
        items = self.get_IKInfo_listWidget_Items()
        resultList = []
        # itemText == Box001:2 --> Cone001:3

        for itemText in items:
            result = get_PymxsPlus_DrvTarNode_ByNose(itemText)
            resultList.append(result)

        return resultList

    def get_FKInfo_listWidget_Items(self):
        curListWidget = self.BaseWin.FKInfo_listWidget
        # itemText == Box001:2 --> Cone001:3
        items = [str(curListWidget.item(i).text()) for i in range(curListWidget.count())]
        return items

    def get_IKInfo_listWidget_Items(self):
        curListWidget = self.BaseWin.IKInfo_listWidget
        # itemText == Box001:2 --> Cone001:3
        items = [str(curListWidget.item(i).text()) for i in range(curListWidget.count())]
        return items

    def get_IKVal(self):
        lineEidt = self.BaseWin.IKVal_LineEdit
        val = eval( lineEidt.text() )
        return val

    def get_FKVal(self):
        lineEidt = self.BaseWin.FKVal_LineEdit
        val = eval( lineEidt.text() )
        return val





