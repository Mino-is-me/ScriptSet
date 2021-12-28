# ==================================
# add path Tool
# ==================================
#
import sys

# Add My Path

myPath = 'Z:/ART_Backup/EVE_ANI/KCJ_Script'
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

import IKFKTrader
reload(IKFKTrader.utils)
reload(IKFKTrader.utils.ui)
reload(IKFKTrader.utils.system)
reload(IKFKTrader.utils.pymxsPlus)

reload(IKFKTrader.main)

IKFKTrader.main.openWindow()