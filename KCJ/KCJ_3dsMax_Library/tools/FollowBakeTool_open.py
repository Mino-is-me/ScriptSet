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

import FollowBakeTool
reload( FollowBakeTool )
print dir(FollowBakeTool)

reload(FollowBakeTool.utils)
reload(FollowBakeTool.utils.ui)
reload(FollowBakeTool.utils.system)
reload(FollowBakeTool.utils.pymxsLib)

reload(FollowBakeTool.main)

FollowBakeTool.main.openWindow()