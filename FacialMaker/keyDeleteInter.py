
import MaxPlus as mp
# PyMAX by Cheoljin Kim 
# ======================================
# Tools
# ======================================
def set_FPS( num=30 ):
	command = """frameRate = {}""".format(num)
	mp.Core.EvalMAXScript(command)
	
def set_select_bySuffix(Suffix) : 
	command  = '''
	clearSelection()
	select $*{Suffix}
	'''.format( Suffix = Suffix )
	mp.Core.EvalMAXScript(command)
	
def set_selectKeys_bySelected( startFrame = 0, endFrame = 100) :
	command = """
	for o in selection do
	(
		selectKeys o.pos.controller {startFrame}f {endFrame}ff
	)
	""".format(startFrame=startFrame, endFrame=endFrame)
	mp.Core.EvalMAXScript(command)
	
set_selectKeys_bySelected( startFrame = 4200, endFrame = 4500)

def get_interFrame(startFrame = 0, endFrame = 100, per = 1, num = 0.01 ) :
	frameList = []
	startNum = startFrame

	# 기준 값 구하기
	while( startNum <= endFrame ) :
		frameList.append( startNum )
		startNum +=per

	# get_range 
	resultRangeList = []
	for i, curF in enumerate(frameList) :
		startFrame = frameList[i]
		if startFrame == frameList[-1] : break
		endFrame = frameList[i+1]
		result = (startFrame+num, endFrame-num)
		resultRangeList.append( result )

	return resultRangeList
	
def set_selectKeys_bySelected( startFrame = 0, endFrame = 100) :
	command = """
	for o in selection do
	(
		selectKeys o.pos.controller {startFrame}f {endFrame}f
	)
	""".format(startFrame=startFrame, endFrame=endFrame)
	mp.Core.EvalMAXScript(command)
	
def set_deleteKeys_bySelected() :
	command = """
	for o in selection do
	(
		deleteKeys o.pos.controller #selection
	)
	""".format(startFrame=startFrame, endFrame=endFrame)
	mp.Core.EvalMAXScript(command)
	
def get_animationRange_start():
    command = """int(animationRange.start)"""
    result = mp.Core.EvalMAXScript(command).Get()
    return result


def get_animationRange_end():
    command = """int(animationRange.end)"""
    result = mp.Core.EvalMAXScript(command).Get()
    return result


# ======================================
# main
# ======================================

# input

# Vars
startFrame = get_animationRange_start()
endFrame = get_animationRange_end()
Suffix = 'CTRL'
changeFPS = 30

# get_info
set_FPS( num=changeFPS)

interFrameList = get_interFrame(startFrame = startFrame, endFrame = endFrame,  per = 1, num = 0.01 )
										
# run
# select : objects

set_select_bySuffix(Suffix=Suffix)
# select : keys
for startFrame, endFrame  in interFrameList :
	set_selectKeys_bySelected( startFrame = startFrame, endFrame = endFrame) 
	
# delete keys
set_deleteKeys_bySelected()