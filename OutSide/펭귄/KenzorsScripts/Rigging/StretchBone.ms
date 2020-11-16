/*------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- version 0.5
-- Stretchy bone
-- By ken turner
-- www.designimage.co.uk
-- last changed 29 Dec 2013
-- dot net reference http://www.scriptspot.com/bobo/mxs9/dotNet/dotNetObject_System.Windows.Forms.TabControl.html

*/------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
if KenzorsStretchyBoneManager != undefined then KenzorsStretchyBoneManager.closeup()
KenzorsStretchyBoneManager = undefined

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
fileIn ( "$userscripts/KenzorsScripts/Common/kenzorsRolloutManager.ms" )
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
rollout CreateStretchyBoneRoll "Stretchy bone"
(
	Local isRolledOut = true
	fn rolledUpEventFn = 
	( --- required undefined varible for kenzorsRolloutManager
	)
	on CreateStretchyBoneRoll rolledUp val do ( isRolledOut = val ; rolledUpEventFn())
	------------------------------------------------
	Local boneList = #() , ObjArray = #()
	Local LastBone = Undefined
	Local NextBone = Undefined
	Local EndBone = Undefined
	
	
	label lbl1"Pick Targets in order, then right click to stop" 
	checkbutton chkBtn "Pick Targets" 
	
	spinner SpnWidth "width"  range:[0,100,0.1] fieldWidth:40  align:#left offset:[-8,15] 
	checkbutton chkBtnLockHeight "Height" align:#left offset:[73,-23] checked:true
	spinner SpnHeight ""  range:[0,100,0.1] fieldWidth:40 align:#left offset:[120,-24] enabled:false
	spinner SpnTaper "Taper"  range:[0,100,90] fieldWidth:40 align:#left offset:[180,-21] 
	
	radiobuttons RbtnUpNode "UpNode" labels:#("Root Axis","Target Axis","Pick Look at Object") offset:[10,0]  across:3
	
	radiobuttons RbtnUpNodeAxis "Axis" labels:#("x","y","z") 
	checkbox chkFlip "Flip" offset:[0,20] 
	
	Pickbutton PckBtnUpNode "Pick pick UpNode" Align:#right Offset:[0,-25] Enabled:false

	radiobuttons Rbtn labels:#("stretch","Squash") offset:[0,10] columns:1 across:3
	button btnResetScale "Reset Scale" offset:[0,20] 
	button btnResetStretch "Reset Stretch" offset:[0,20] 
	
	fn GetEndLength = 
	(
		if SpnWidth.value > SpnHeight.Value then SpnWidth.value else SpnHeight.Value 
	)
	
	fn GetScaleType =
	(
			case Rbtn.state of
			(
				1:#scale
				2:#squash
				3:#none
			)
	)
	
	fn CreateNewBone obj pos ScaleType =
	(
		NextBone  = BoneSys.createBone  obj.transform.position pos [0,0,1]
		if LastBone != undefined do NextBone.parent = LastBone
		NextBone.boneScaleType = ScaleType
		NextBone.boneAutoAlign = false
				
		NextBone.position.controller = position_constraint()
		NextBone.position.controller.appendTarget obj 100
		
		NextBone.width = SpnWidth.value
		NextBone.Height = SpnHeight.value
		NextBone.Taper = SpnTaper.value
	)

	fn SetUpNodeForBoneIndex i =
	(
		theUpNode = case RbtnUpNode.state of
		(
			1: ( ObjArray[i] )
			2: ( ObjArray[i+1] )
			3: ( PckBtnUpNode.object )
		)
		boneList[i].rotation.controller.pickUpNode = theUpNode
		boneList[i].rotation.controller.upnode_axis =  RbtnUpNodeAxis.state - 1
		boneList[i].rotation.controller.StoUP_axisFlip = chkFlip.state
		boneList[i].rotation.controller.upnode_ctrl = if RbtnUpNode.state == 3 then 0 else 1
	)
	
	fn SetAllUpNodes =
	(
		for i = 1 to (boneList.count - 1 ) do SetUpNodeForBoneIndex i 
	)
	
	on RbtnUpNode changed state do 
	(
		PckBtnUpNode.enabled = (state == 3)
		SetAllUpNodes()
	)
	on RbtnUpNodeAxis changed state do SetAllUpNodes()
	on chkFlip changed state do SetAllUpNodes()
	on PckBtnUpNode picked Obj do
	(
		if obj != undefined then SetAllUpNodes()
		
	)
	on chkbtn changed state  do
	(
		LastBone = Undefined
		NextBone = Undefined
		
		ObjArray = pickObject count:#multiple select:true

		if ObjArray != Undefined and ObjArray.count >1 then
		(
			ScaleType = GetScaleType()

			ObjCnt = ObjArray.count 
			boneList = for i = 2 to ObjCnt collect
			(
				CreateNewBone ObjArray[i-1] ObjArray[i].transform.position ScaleType
				
				NextBone.rotation.controller = lookAt_constraint()
				NextBone.rotation.controller.appendTarget ObjArray[i] 100
				NextBone.rotation.controller.lookAt_vector_length=0
				NextBone.rotation.controller.upNode_world = false
				NextBone.rotation.controller.pickUpNode = ObjArray[i-1]

				LastBone = nextbone
				nodeInvalRect LastBone  -- refresh the viewport
				LastBone
			)

			endLength = GetEndLength()
				
			v = (ObjArray[ObjCnt].transform.position - ObjArray[ObjCnt-1].transform.position) -- make a vector from the last two bone positions
			v *= (endLength/ (length v))
			
			CreateNewBone ObjArray[ObjCnt] (ObjArray[ObjCnt].transform.position + V ) ScaleType
				
			append boneList NextBone  --- cause its a globalish variable
			LastBone = NextBone
			nodeInvalRect LastBone -- refresh the viewport
		)
		chkbtn.state = false
	)
	
	fn setHeight val =
	(
		for obj in boneList do obj.Height = val
		if LastBone != undefined and ( IsValidNode LastBone ) then LastBone.length = GetEndLength()
	)
	fn setWidth val =
	(
		for obj in boneList do obj.width = val
		if LastBone != undefined and ( IsValidNode LastBone ) then LastBone.length = GetEndLength()
	)

	on SpnWidth changed arg do
	(
		setWidth arg
		if chkBtnLockHeight.state == true then setHeight ( SpnHeight.value = arg )
	)

	on SpnHeight changed arg do setHeight arg 

	on SpnTaper changed arg do 
	(
		for obj in boneList do obj.Taper = arg
	)
	on chkBtnLockHeight changed state do SpnHeight.enabled = not state
		
	on Rbtn changed state do 
	(
		ScaleType = GetScaleType()
		for obj in boneList do obj.boneScaleType = ScaleType		
	)
	
	On BtnResetScale Pressed do
	(
		for obj in boneList do ResetScale obj
	)
	On BtnResetStretch Pressed do
	(
		for obj in boneList do  obj.resetBoneStretch()
	)
)
try closerolloutfloater BoneFloater catch()


KenzorsStretchyBoneManager = KenzorsRolloutManagerStruct  "Kenzors Stretchy Bone" 300 #( KenzorsAboutMeRoll, CreateStretchyBoneRoll)
KenzorsStretchyBoneManager.Initalize()

