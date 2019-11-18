/*------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Crude Biped Key Reducer
-- By ken turner
-- www.designimage.co.uk

09/12/2017	v1.10 3dsmax 2017 rollout bug fix
07/03/2013	v1.01 tweaked step size in loop 
05/03/2013	v1.00 first release
*/------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
		----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
if KenzorsCrudeKeyReducer != undefined then KenzorsCrudeKeyReducer.closeup()
KenzorsCrudeKeyReducer = undefined

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
fileIn ( "$userscripts/KenzorsScripts/Common/kenzorsRolloutManager.ms" )
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
rollout KenzorsCrudeKeyReducerRoll "Reduce Biped animation"
(
	Local isRolledOut = true --- required varible for kenzorsRolloutManager
	fn rolledUpEventFn = 
	( --- required undefined varible for kenzorsRolloutManager
	)
	on KenzorsCrudeKeyReducerRoll rolledUp val do ( isRolledOut = val ; rolledUpEventFn()) --- required function for kenzorsRolloutManager
	---------------------------------------------------------------------------------------------
	label lbl1 "Select the biped"
	label lbl2 "Set step interval"
	label lbl3 "Press Delete Keys"
	group "Animation Range" 
	(
		spinner SpnStart "Start" range:[-100000,100000,animationRange.start]  width:80 type:#integer  offset:[-10,0] across:2
		spinner SpnEnd "End" range:[-100000,100000,animationRange.end] width:80 type:#integer  offset:[-10,0] 
	)
	Spinner SpnDeleteStep "step"  width:50 range:[1,50,5] 	align:#left type:#integer 
	Button BtnDeleteFrames "Delete Keys" width:80 	align:#right offset:[0,-22]			toolTip:"deletes any keys on the limbs of the selected biped at current time"
	
	fn getRootBipFromSelection =
	(
		theBip = Undefined
		for obj in selection while  (theBip == Undefined) where (classof obj.baseobject == Biped_Object ) do ( theBip = Obj )
		-- puppet rigs may modify the biped with an edit mesh modifer so we need to find the base oject at the root of the stack
		if theBip != Undefined then theBip.controller.rootNode else undefined
	)	
	fn getBodyNodes theRoot =
	(
		nodeIndexList = #(#larm,#rArm,#lLeg,#rLeg,#spine,#head,#pelvis,#tail,#prop1,#prop2,#prop3) -- ,#vertical,#horizontal,#turn)
		obj = undefined
		for i in nodeIndexList where ( obj = ( biped.getNode theRoot i ) ) != undefined collect obj
	)
	fn getAllCtrlNodes theRoot =
	(
		objList = ( getBodyNodes theRoot ) + #( theRoot.controller.vertical,theRoot.controller.Horizontal,theRoot.controller.turning )
	)

	on BtnDeleteFrames Pressed do 
	(
		theRoot = getRootBipFromSelection()
		if theRoot != undefined do
		(
			theCtrlNodes = ( getAllCtrlNodes theRoot  )
			undo "Reduce bip keys" on
			(
				StartFrame = SpnStart.value +1
				
				do
				(
					currentEndFrame = StartFrame + SpnDeleteStep.value - 2
					for currentFrame = StartFrame to currentEndFrame do
					(
						print currentFrame
						for obj in theCtrlNodes do
						(
							i = getKeyIndex obj.controller currentFrame
							if i > 0 then deleteKey  obj.controller  i -- maybe faster to collect all the keys into an array then delete them all in one go
						)
					)
				)
				while ( StartFrame = currentEndFrame + 2 )<= SpnEnd.value
			)
		)
	)
)
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
KenzorsCrudeKeyReducer = KenzorsRolloutManagerStruct  "Crude Key Reducer" 200 #( KenzorsAboutMeRoll, KenzorsCrudeKeyReducerRoll )
KenzorsCrudeKeyReducer.Initalize()
KenzorsAboutMeRoll.wwwHelp = "http://www.designimage.co.uk/reduce-motion-capture-with-the-crude-biped-key-reduction-tool/"