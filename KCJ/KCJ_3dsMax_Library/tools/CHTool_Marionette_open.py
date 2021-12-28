# ==================================
# add path Tool
# ==================================
#-*-coding: utf-8-*-
import os

# Add My Path
def stringChange_Escape_BackSlash(string):
    partList = [part for part in repr(string).split("\\") if part]
    resultStr = eval( "/".join(partList) )
    return resultStr

def get_curDir() :
    # 이스케이프 문을 피하기 위해 raw문으로 변환합니다.
    path = os.path.dirname(__file__)
    path = stringChange_Escape_BackSlash(path)
    return path

myPath = get_curDir()
allpath = sys.path

isInstalled_myPath = myPath in allpath
if isInstalled_myPath == False:
     sys.path.append(myPath)

print '================================='
print 'Comp Add Your Path.'
print myPath
print '================================='

# ==================================
# run
# ==================================

import CHTool_Marionette
reload( CHTool_Marionette )
print dir(CHTool_Marionette)

reload(CHTool_Marionette.utils)
reload(CHTool_Marionette.utils.ui)
reload(CHTool_Marionette.utils.system)
reload(CHTool_Marionette.utils.pymxsLib)
reload(CHTool_Marionette.marionetteData)

reload(CHTool_Marionette.main)

CHTool_Marionette.main.openWindow()