# ==================================
# add path Tool
# ==================================
#-*-coding: utf-8-*-
import os
import sys

myPath =  "Z:/ART_Backup/EVE_ANI/KCJ_Script"
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

import KCJ_3dsMax_Library
reload( KCJ_3dsMax_Library)

reload(KCJ_3dsMax_Library.utils)
reload(KCJ_3dsMax_Library.main)

KCJ_3dsMax_Library.main.openWindow()