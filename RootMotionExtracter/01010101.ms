# ============================================
# API ? ??? ???.
# ============================================
import pymxs
rt = pymxs.runtime

# ============================================
# inputs
# ============================================
target_node = 'RightAx_Base_Ctrl'
cur_startFrame = 0
cur_endFrame = 143


# ============================================
# get infomation
# ============================================
# ??? ??? ??? ??
# ??? ???? ??? ???? ?????.
target_node = rt.getNodeByName(target_node)

frameList = range(cur_startFrame, cur_endFrame + 1, 1)
# range(0, 5+1, 1)
# frameList = [0, 1, 2, 3, 4, 5]

# ============================================
# set Datas
# ============================================
# bake
mtxList = []

for f in frameList:
 # ?? ???? ?????.
 rt.sliderTime = f

 # set Pose
 with pymxs.animate(True):
  # ??? ??? ?????.
  target_mtx = target_node.transform
  mtxList.append( target_mtx )

# set

for i, f in enumerate(frameList):
 rt.sliderTime = f
 
 # ??? ??? ?????.
 target_node.baseObject.Custom_Attributes.Follow_InitPos_PropPos = 100
 target_node.transform = mtxList[i]