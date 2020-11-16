/*------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- bake animation
-- By ken turner
-- www.designimage.co.uk

-- dot net reference http://www.scriptspot.com/bobo/mxs9/dotNet/dotNetObject_System.Windows.Forms.TabControl.html
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- versions
-- 09/12/2017	v1.10 3dsmax 2017 rollout bug fix
-- 11 mar 2015 -- added help link , allowed user to delete keyframes in current time range as well as globally
*/------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
if KenzorsBakeAnim != undefined then KenzorsBakeAnim.closeup()
KenzorsBakeAnim = undefined

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
fileIn ( "$userscripts/KenzorsScripts/Common/kenzorsRolloutManager.ms" )
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------BakeAnimRoll
rollout BakeAnimRoll "bake animation"
(
	Local isRolledOut = true --- required varible for kenzorsRolloutManager
	fn rolledUpEventFn = 
	( --- required undefined varible for kenzorsRolloutManager
	)
	on BakeAnimRoll rolledUp val do ( isRolledOut = val ; rolledUpEventFn()) --- required function for kenzorsRolloutManager
	---------------------------------------------------------------------------------------------
	local fromObj = undefined
	local toObj = undefined
	Local OffsetTm = matrix3 1
	------------------------------------------------------------------------------------------
	group "pick objects"
	(
	PickButton BtnFrom "From" width:40 align:#left offset:[-5,0]
	Button btnFromObj ""	width:129 align:#left offset:[37,-26]
	PickButton BtnTo "onto" width:40  align:#left  offset:[-5,0]
	Button btnToObj "" width:129  align:#left offset:[37,-26]
	Label Lbl_flippedAxis
	)
	group ""
	(
	checkBox chkKeepOffset "KeepOffset" checked:false --enabled:false 
	checkBox chkPosition "Pos" checked:true across:3
	checkBox chkRotation "Rot" checked:true 
	checkBox chkScale "Scale" checked:false --enabled:false 
	checkbox chkUnreal "rotate for unreal Hack (z-up)" checked:false
	)
	Button btnBakeCurrentFrame "Bake Current Frame" enabled:false
	group ""
	(
	checkBox chkRemoveKeysBeforeBaking "Remove Keys Before Baking" checked:true --enabled:false 
	radiobuttons rBtnRange "" labels: #("All Keys", "Current time Range")

	Button BtnBake "Bake" width:80 across:2 enabled:false
	Spinner SpnStep "Step" range:[1,100,1] type:#integer fieldwidth:30 offset:[0,2]
	)
	------------------------------------------------------------------------------------------------
	fn checkAndSelect theObj =
	(
		( if theObj !=undefined and (not isDeleted theObj) do select theObj )
	)
	fn checkNodesOK =
	(
		checkOK = fromObj !=undefined and (not isDeleted fromObj) and toObj !=undefined and (not isDeleted toObj) and fromObj != toObj
		if checkOK then OffsetTm = toObj.transform * inverse fromObj.transform 
		btnBakeCurrentFrame.enabled = BtnBake.enabled = checkOK
		checkOK
	)
	fn checkObjectsHaveTheSameAxisOrder = 
	(
		theCheck = if checkNodesOK() then
		(
			fromObj.transform.determinantsign == toObj.transform.determinantsign 
		)else undefined
		Lbl_flippedAxis.text = (if theCheck == false then "warning: mirrored axis" else "" )
	)

	local mirrorTm =  (matrix3 [1,0,0] [0,1,0] [0,0,1] [0,0,0])
	fn setMirrorTmWithAxisID i =
	(
		mirrorTm = case i of
		(
			0:(matrix3 [1,0,0] [0,1,0] [0,0,1] [0,0,0])
			1:(matrix3 [-1,0,0] [0,1,0] [0,0,1] [0,0,0])
			2:(matrix3 [1,0,0] [0,-1,0] [0,0,1] [0,0,0])
			3:(matrix3 [1,0,0] [0,1,0] [0,0,-1] [0,0,0])
		)
	)
	fn getTargetObjectTmWithOffset = ( OffsetTm * fromObj.transform)
	fn getTargetObjectTm = ( fromObj.transform )
	fn getMirroredTargetObjectTm = ( mirrorTm  * fromObj.transform )

	local ptrGetTargetObjectTm =  getTargetObjectTm
		
	On BtnFrom picked obj do ( btnFromObj.text = obj.name ; fromObj = obj ; checkNodesOK() ; checkObjectsHaveTheSameAxisOrder() )
	On BtnTo picked obj do ( btnToObj.text = obj.name ; toObj = obj ; checkNodesOK() ; checkObjectsHaveTheSameAxisOrder() )
	on btnFromObj pressed do checkAndSelect fromObj
	on btnToObj pressed do checkAndSelect toObj
	fn CollectKeysIndicesFrom theCtrl InTheRange:AnimationRange =  --- not used
	(
		n = theCtrl.keys.count
		for i = 1 to n where ( AnimationRange.start < theCtrl.keys.time ) and ( theCtrl.keys.time < AnimationRange.end ) collect i
	)
	fn RemoveKeysFromThisController theCtrl =
	(
		if rBtnRange.state == 1 then 
		( 
			deleteKeys theCtrl #allKeys  -- .keys
		)else
		(
			deleteTime theCtrl AnimationRange #noslide
		)
	)
	fn RemoveKeysFromTarget =
	(
		if chkRotation.checked then ( RemoveKeysFromThisController toObj.Rotation.controller )
		if chkPosition.checked then ( RemoveKeysFromThisController toObj.Position.controller )
		if chkScale.checked then ( RemoveKeysFromThisController toObj.scale.controller )
	)
	fn bakeAnimAtTime t UnrealTransform =
	(
		at time t 
			(
				tm = ptrGetTargetObjectTm() * UnrealTransform
				if chkRotation.checked then ( with animate on ( toObj.Rotation = inverse tm.rotation ) )
				if chkPosition.checked then ( with animate on ( toObj.position = tm.position ) )
				if chkScale.checked then ( with animate on ( toObj.scale = tm.scale ) )
			)
	)
	fn getUnrealTm = 
	(
		if chkUnreal.checked then  (( eulerangles 0 0 -90  ) as matrix3 ) else ( matrix3 1 )
	)
	fn BakeTheAnim =
	(
		-- UnrealTransform = if chkUnreal.checked then  (( eulerangles 0 0 -90  ) as matrix3 ) else ( matrix3 1 )
		UnrealTransform = getUnrealTm()
		for t = animationrange.start to animationrange.end by SpnStep.value do
		(
			bakeAnimAtTime t UnrealTransform 
/* 			at time t 
* 			(
* 				tm = ptrGetTargetObjectTm() * UnrealTransform
* 				if chkRotation.checked then ( with animate on ( toObj.Rotation = inverse tm.rotation ) )
* 				if chkPosition.checked then ( with animate on ( toObj.position = tm.position ) )
* 				if chkScale.checked then ( with animate on ( toObj.scale = tm.scale ) )
* 			)
*/
		)
	)
	on chkKeepOffset changed KeepOffsetTrue do 
	(
		ptrGetTargetObjectTm = if KeepOffsetTrue then getTargetObjectTmWithOffset else getTargetObjectTm
	)
	on chkRemoveKeysBeforeBaking changed state do rBtnRange.enabled = state
	on BtnBake pressed do 
	(
		if checkNodesOK() do
		(
			if chkRemoveKeysBeforeBaking.checked do RemoveKeysFromTarget()
			BakeTheAnim()
		)
	)
	on btnBakeCurrentFrame pressed do
	(
		if checkNodesOK() do
		(
			bakeAnimAtTime (currentTime.frame)  (getUnrealTm())
		)
	)
)
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------------- END OF: BakeAnimRoll

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- 
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

KenzorsBakeAnim = KenzorsRolloutManagerStruct  "Bake Animation" 200 #( KenzorsAboutMeRoll, BakeAnimRoll )
KenzorsBakeAnim.Initalize()
KenzorsAboutMeRoll.wwwHelp = "http://www.designimage.co.uk/kenzors-maxscripts-bake-anim/"