# -*-coding: utf-8-*-
import os
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
    baseWin = MaxLibrary()
    baseWin.show()


class MaxLibrary():

    NoImagePath = '{}/{}.{}'.format(utils_system.get_imageDir(), 'NoImage', 'jpg')

    def __init__(self):
        uiPath = utils_system.get_ui_main()
        self.curObjects = []
        self.BaseWin = utils_ui.MaxBaseWidget_byUI(uiPath, title='KCJ_3dsMax_Library').get_window()

        # update UI
        self.update_listWidget_byCurPythonFiles()
        self.set_image(self.NoImagePath)

        # 버튼들 연결
        # self.BaseWin.CustomBakeFrame_CheckBox.stateChanged.connect(lambda evt=None : self.command_CustomBakeFrame_CheckBox() )
        #

        self.BaseWin.RunTool_Btn.clicked.connect(lambda evt=None : self.command_RunTool_Btn() )
        self.BaseWin.Folder_Btn.clicked.connect(lambda evt=None : self.command_Folder_Btn() )
        self.BaseWin.Document_Btn.clicked.connect(lambda evt=None : self.command_Document_Btn() )
        self.BaseWin.Video_Btn.clicked.connect(lambda evt=None: self.command_Video_Btn())
        # self.BaseWin.Bake_Btn.clicked.connect(lambda evt=None : self.command_Bake() )
        self.BaseWin.Tool_ListWidget.itemSelectionChanged.connect( lambda evt=None: self.command_Tool_ListWidget_ChangedItem() )



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

    def update_listWidget_byCurPythonFiles(self):

        toolsDir = utils_system.get_toolsDir()
        pythonFiles = utils_system.get_python_files( toolsDir )

        self.BaseWin.Tool_ListWidget.clear()
        self.BaseWin.Tool_ListWidget.addItems( pythonFiles )

    def get_cur_item(self):
        selectedItems = self.BaseWin.Tool_ListWidget.selectedItems()
        if not selectedItems : return None
        cur_item = selectedItems[-1]
        return cur_item

    def set_image(self, imagePath):
        _image = QPixmap(imagePath)
        self.BaseWin.Image_Label.setPixmap(_image)

    # ===============================
    # 버튼 전용 기능들
    # ===============================
    def command_RunTool_Btn(self):
        for selected_pyFile in self.BaseWin.Tool_ListWidget.selectedItems():
            selected_pyFile = selected_pyFile.text()
            # for Debug
            # print 'selected_pyFile'
            # print selected_pyFile

            toolDirPath = utils_system.get_toolsDir()
            filePath = '{}//{}'.format(toolDirPath, selected_pyFile)
            # for debug
            # print 'filePath'
            # print filePath

            # run
            pymxsLib.run_pythonFile_in3dsMax( filePath )

    def command_Folder_Btn(self):
        os.startfile( utils_system.get_toolsDir() )

    def command_Document_Btn(self):
        # 선택된게 없다면 리턴
        cur_item = self.get_cur_item()
        ext = 'pdf'
        folderDir = utils_system.get_documentDir()
        if not cur_item : return

        cur_item_text = cur_item.text()
        cur_item_origName = cur_item_text.split('.')[0]

        cur_filePath = '{}/{}.{}'.format(folderDir, cur_item_origName, ext)
        has_file = os.path.isfile(cur_filePath)
        # 파일 열기
        if has_file :
            os.startfile(cur_filePath)
        else :
            print 'is wrong Path! plase Check!! \npath:{}'.format(cur_filePath)


    def command_Video_Btn(self):
        # 선택된게 없다면 리턴
        cur_item = self.get_cur_item()
        ext = 'mp4'
        folderDir = utils_system.get_videoDir()
        if not cur_item: return

        cur_item_text = cur_item.text()
        cur_item_origName = cur_item_text.split('.')[0]

        cur_filePath = '{}/{}.{}'.format(folderDir, cur_item_origName, ext)
        has_file = os.path.isfile(cur_filePath)
        # 파일 열기
        if has_file:
            os.startfile(cur_filePath)
        else:
            print 'is wrong Path! plase Check!! \npath:{}'.format(cur_filePath)

    def command_Tool_ListWidget_ChangedItem(self):
        # for debug
        # print 'command_Tool_ListWidget_ChangedItem'

        selectedItems = self.BaseWin.Tool_ListWidget.selectedItems()
        if not selectedItems : return
        cur_item = selectedItems[0]
        cur_item_text = cur_item.text()
        cur_item_origName = cur_item_text.split('.')[0]

        # for debug
        # print 'cur_item_text'
        # print cur_item_text

        cur_documentPath = '{}/{}.{}'.format( utils_system.get_documentDir(), cur_item_origName, 'pdf')
        cur_imagePath = '{}/{}.{}'.format( utils_system.get_imageDir(), cur_item_origName, 'jpg')
        cur_videoPath = '{}/{}.{}'.format( utils_system.get_videoDir(), cur_item_origName, 'mp4')

        has_document = os.path.isfile(cur_documentPath)
        has_image = os.path.isfile(cur_imagePath)
        has_video = os.path.isfile(cur_videoPath)


        # for debug
        # print cur_documentPath
        # print cur_imagePath
        # print cur_videoPath
        #
        # print 'has_document'
        # print has_document
        # print 'has_image'
        # print has_image
        # print 'has_video'
        # print has_video

        # 파일 존재에 따른 처리
        if has_document :
            self.BaseWin.Document_Btn.setEnabled(True)
        else :
            self.BaseWin.Document_Btn.setEnabled(False)

        if has_video :
            self.BaseWin.Video_Btn.setEnabled(True)
        else :
            self.BaseWin.Video_Btn.setEnabled(False)

        if has_image :
            self.set_image(cur_imagePath)
        else :
            self.set_image(self.NoImagePath)


        # print 'test'










