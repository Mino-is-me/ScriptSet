/*------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- version 1.2
-- keyBiped GUI
-- By ken turner
-- www.designimage.co.uk
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
toDo:
- change buttons to the 3dsMax bip button images. Add fucntions to for sliding keys and planted keys.
- add rollout manager etc
- add align foot to ground tool.
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
16/03/2013	v1.2  changed to radiobuttons for TCB settings
12/03/2013	v1.1  added button images for TCB settings
13/01/2012	v1.0 first release
*/------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
try ( destroyDialog KenzorsBipedKeyAllRoll ) catch ()


------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
rollout KenzorsBipedKeyAllRoll "Key all Biped limbs"
(
	--Button btnSelectAllNodes "Select All Nodes" width:95 align:#center
	local KenzorsTCBsBmp = openBitmap "$userscripts/KenzorsScripts/Common/Images/TCB_Buttons.bmp"
	
	Button btnSelectKeyNodes "Select Key Nodes" width:95 align:#center
	Button btnKey "Key" width:40 Across:2 	toolTip:"keys all the limbs of the selected biped at current time"
	Button btnDel "Delete" width:40 			toolTip:"deletes any keys on the limbs of the selected biped at current time"
	
	CheckButton btnDefault "" width:34 height:40 toolTip:"adjust spinners to Smooth" images:#(KenzorsTCBsBmp, undefined, 4,4,4,4,4 ) align:#left offset:[-13,0] checked:true
	CheckButton btnLinear "" width:34 height:40  toolTip:"adjust spinners to Linear"  images:#(KenzorsTCBsBmp, undefined, 4,3,3,3,3 ) align:#left offset:[22,-45]
	CheckButton btnBias0 "" width:34 height:40  toolTip:"adjust spinners to Linear OUT"  images:#(KenzorsTCBsBmp, undefined, 4,2,2,2,2 ) align:#left offset:[57,-45]
	CheckButton btnBias50 "" width:34 height:40  toolTip:"adjust spinners to Linear IN"  images:#(KenzorsTCBsBmp, undefined, 4,1,1,1,1  ) align:#left offset:[92,-45]

	Spinner SpnEaseTo ""  width:50 range:[0,50,0] align:#right offset:[0,5]
	button BtnEaseTo "Ease To" width:60 align:#left offset:[0,-24]			toolTip:"click to toggle through default spinner settings" 
	
	Spinner SpnEaseFrom ""  width:50 range:[0,50,0] align:#right offset:[0,0]
	button BtnEaseFrom "Ease From" width:60 align:#left offset:[0,-24]		toolTip:"click to toggle through default spinner settings" 
	
	Spinner SpnTension ""  width:50 range:[0,50,25] align:#right offset:[0,0]
	button BtnTension "Tension" width:60 align:#left offset:[0,-24]			toolTip:"click to toggle through default spinner settings" 
	
	Spinner SpnContinuity ""  width:50 range:[0,50,25] align:#right offset:[0,0]
	button BtnContinuity "Continuity" width:60 align:#left offset:[0,-24]	toolTip:"click to toggle through default spinner settings" 
	
	Spinner SpnBias ""  width:50 range:[0,50,25] align:#right offset:[0,0]
	Button BtnBais "Bias" width:60 align:#left offset:[0,-24]						toolTip:"click to toggle through default spinner settings" 
	
	hyperlink wwwDesignimage "www.designimage.co.uk" color:[64,128,255] address:"www.designimage.co.uk" align:#center


	------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	fn stepUp val  =
	(
		val  = ( floor (val / 25.0) ) * 25
		val  += 25 
		if val > 50 do val = 0
		val
	)
	fn stepDown val =
	(
		val  = ( floor (val / 25) ) * 25
		val -= 25 
		if val <0 do val = 50
		val
	)

	fn setTcb k =
	(
		k.EaseTo = SpnEaseTo.value
		k.EaseFrom = SpnEaseFrom.value
		k.Tension = SpnTension.value
		k.Continuity = SpnContinuity.value
		k.Bias = SpnBias.value
	)
	fn findControllerKeyAtTime ctrl t =
	(
		theKey = undefined 
		count = ctrl.controller.keys.count
		k = undefined
		for i = 1 to count while theKey == undefined where (k = biped.getKey ctrl i).time == t do theKey = k
		theKey
	)
	fn getBodyNodes theRoot =
	(
		nodeIndexList = #(#larm,#rArm,#lLeg,#rLeg,#spine,#head,#pelvis,#tail,#prop1,#prop2,#prop3,#pony1,#pony2) -- ,#vertical,#horizontal,#turn)
		obj = undefined
		for i in nodeIndexList where ( obj = ( biped.getNode theRoot i ) ) != undefined collect obj
	)
	fn getMainNodes theRoot =
	(
		objList = getBodyNodes theRoot
		 --- objList + theRoot --- gets everything from the root upwards for some reason ..
		objList + #(theRoot) -- the correct method -- or could use -- append objList theRoot
	)
	fn getAllCtrlNodes theRoot =
	(
		objList = ( getBodyNodes theRoot ) + #( theRoot.controller.vertical,theRoot.controller.Horizontal,theRoot.controller.turning )
	)
	fn getRootBipFromSelection =
	(
		theBip = Undefined
		for obj in selection while  (theBip == Undefined) where (classof obj.baseobject == Biped_Object ) do ( theBip = Obj )
		-- puppet rigs may modify the biped with an edit mesh modifer so we need to find the base oject at the root of the stack
		if theBip != Undefined then theBip.controller.rootNode else undefined
	)
	------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	fn setSpinners easeTo easeFrom Tension cont Bias =
	(
		SpnEaseTo.value = easeTo
		SpnEaseFrom.value = easeFrom
		SpnTension.value = Tension
		SpnContinuity.value = cont
		SpnBias.value = Bias
	)
	
	fn setButtonState id =
	(
		theButtons = #( btnLinear, btnDefault, btnBias0, btnBias50)
		tensionVal = #(0,25,25,25)
		BiasVal = #(25,25,0,50)
		for i = 1 to 4 do
		(
			if i == id then ( setSpinners 0 0 25 tensionVal[i] BiasVal[i] ) else
			(
				theButtons[i].checked = false
			)
		)
	)
	------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	on btnLinear changed arg do ( if arg then setButtonState 1 else setButtonState 0 ) --setSpinners 0 0 25 0 25
	on btnDefault changed arg do ( if arg then setButtonState 2 else setButtonState 0 ) --setSpinners 0 0 25 25 25
	on btnBias0 changed arg do ( if arg then setButtonState 3 else setButtonState 0 )  --setSpinners 0 0 25 25 0
	on btnBias50 changed arg do ( if arg then setButtonState 4 else setButtonState 0 )  --setSpinners 0 0 25 25 50
		
	on BtnEaseTo Pressed do SpnEaseTo.value = StepUp SpnEaseTo.value
	on BtnEaseFrom Pressed do SpnEaseFrom.value = StepUp SpnEaseFrom.value
	on BtnContinuity Pressed do SpnContinuity.value = StepUp SpnContinuity.value
	on BtnTension Pressed do SpnTension.value = StepUp SpnTension.value
	on BtnBais Pressed do SpnBias.value = StepUp SpnBias.value

		
	on btnKey Pressed do 
	(
		theRoot = getRootBipFromSelection()
		if theRoot != undefined do
		(
			for obj in ( getAllCtrlNodes theRoot  ) do
			(
				--print obj
				k = biped.addNewKey obj.controller sliderTime
				setTcb k
			)
		)
	)
	
	on btnDel Pressed do 
	(
		theRoot = getRootBipFromSelection()
		if theRoot != undefined do
		(
			undo "delete bip keys" on
			(
				for obj in ( getAllCtrlNodes theRoot  ) do
				(
					i = getKeyIndex obj.controller sliderTime
					if i > 0 then deleteKey  obj.controller  i 
					--k = biped.addNewKey obj.controller sliderTime
					--setTcb k
				)
			)
		)
	)
	------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	on btnSelectKeyNodes Pressed do 
	(
		theRoot = getRootBipFromSelection()
		if theRoot != undefined then 
		(
			objList = ( getMainNodes theRoot )
			--print ObjList
			select objList
		)
	)
)
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
createDialog KenzorsBipedKeyAllRoll  140 245