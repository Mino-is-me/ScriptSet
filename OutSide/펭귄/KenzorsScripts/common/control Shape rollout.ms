/*------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Control Shape rollout GUI
-- By ken turner
-- www.designimage.co.uk
*/------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
if controlShapeFloater != undefined do ( closerolloutfloater controlShapeFloater )
controlShapeFloater = NewRolloutFloater "" 400 260

fileIn ( "$userscripts/KenzorsScripts/Common/control shape.ms" )
fileIn ( "$userscripts/KenzorsScripts/Common/Standard Load Save rollout.ms" )


controlShapeRoll = undefined

tool createControlShapeTool
(
	on mousePoint clickno do
	(
		format "lbutton Down: % , click %\n" lButton clickno
		if clickno == 1 then 
		(
			tm = getCPTM() -- matrix3 1
			tm.position = worldPoint
			controlShapeRoll.testShape.createShape tm:tm size:0.1 colour:controlShapeRoll.clrPck.color
		)else #stop
	)
	
	on mouseMove clickno do
	(
		sizeval = length worldDist 
		controlShapeRoll.spnSize.value = sizeval * 10
		controlShapeRoll.testShape.setObjectSize ( sizeval /10.0)
	)
)

rollout controlShapeRoll "grab control shape"
(
	local testShape = ShapeStruct()
	fn filterShapes obj = ( isKindOf obj shape )
	label LblInfo "Click and drag in viewport to create."  
	pickButton pckShape "pick shape" filter:filterShapes across:4
	label lblShapeName ""
	button btnCreate "create"
	spinner spnSize "size" fieldWidth:40 range:[1.0,10000.0,100.0]
	checkbox chkDisplayInView "Display Mesh In View" across:2
	colorpicker clrPck ""
	
	group "Lock " 
	(
		
	checkbox chkApplyLocks "Apply Locks" checked:true
	Label lblM "------ Move ------"  across:3
	Label lblR "------ Rotate ------"
	Label lblS "------ Scale ------        "
	
	checkbox chkMoveX "x"  across:9
	checkbox chkMoveY "y"
	checkbox chkMoveZ "z"

	checkbox chkRotateX "x"
	checkbox chkRotateY "y"
	checkbox chkRotateZ "z"
	
	checkbox chkScaleX "x"
	checkbox chkScaleY "y"
	checkbox chkScaleZ "z"
	)
	---groupBox grpM "Lock Move" -- width:120 height:40 offset:[0,-40]
	
	fn setTmLockCheckboxes =
	(
		chkMoveX.checked = testShape.TransformLockBitArray[1]
		chkMoveY.checked = testShape.TransformLockBitArray[2]
		chkMoveZ.checked = testShape.TransformLockBitArray[3]
		
		chkRotateX.checked = testShape.TransformLockBitArray[4]
		chkRotateY.checked = testShape.TransformLockBitArray[5]
		chkRotateZ.checked = testShape.TransformLockBitArray[6]
		
		chkScaleX.checked = testShape.TransformLockBitArray[7]
		chkScaleY.checked = testShape.TransformLockBitArray[8]
		chkScaleZ.checked = testShape.TransformLockBitArray[9]
	)
	
	fn getTmLockBitArrayFromCheckboxes =
	(
		ba = #{}
		ba[1] = chkMoveX.checked 
		ba[2] = chkMoveY.checked 
		ba[3] = chkMoveZ.checked 
		ba[4] = chkRotateX.checked 
		ba[5] = chkRotateY.checked 
		ba[6] = chkRotateZ.checked 
		ba[7] = chkScaleX.checked 
		ba[8] = chkScaleY.checked
		ba[9] = chkScaleZ.checked 
		testShape.TransformLockBitArray = ba
	)
	
	fn writeMe fPath =
	(
		testShape.writeMeToFilePath fPath
	)
	
	fn readMe fPath =
	(
		testShape.readMeFromFilePath fPath
		chkDisplayInView.checked = testShape.displayInView
		setTmLockCheckboxes()
		lblShapeName.text = testShape.shapeName
	)		
	on pckShape picked obj do 
	(
		testShape.copyShapeDataFrom obj
		theObjectName = lblShapeName.text = obj.name as string
		StandardLoadSaveRoll.SetfileNameTo theObjectName 
		spnSize.value = 100
		setTmLockCheckboxes()
	)
	on btnCreate pressed do 
	(
		startTool createControlShapeTool
		-- testShape.createShape size:(spnSize.value / 100.0)
	)
	on spnSize changed val do testShape.setObjectSize ( val /100.0)
	on chkDisplayInView changed state do testShape.SetDisplayInViewBoolTo state 
	
	on chkApplyLocks changed isLockedBool do testShape.setHasLockedTransformBoolTo isLockedBool
	
	on chkMoveX changed arg do testShape.setTransformLockBitArrayTo ( getTmLockBitArrayFromCheckboxes() )
	on chkMoveY changed arg do testShape.setTransformLockBitArrayTo ( getTmLockBitArrayFromCheckboxes() )
	on chkMoveZ changed arg do testShape.setTransformLockBitArrayTo ( getTmLockBitArrayFromCheckboxes() )
	
	on chkRotateX changed arg do testShape.setTransformLockBitArrayTo ( getTmLockBitArrayFromCheckboxes() )
	on chkRotateY changed arg do testShape.setTransformLockBitArrayTo ( getTmLockBitArrayFromCheckboxes() )
	on chkRotateZ changed arg do testShape.setTransformLockBitArrayTo ( getTmLockBitArrayFromCheckboxes() )
	
	on chkScaleX changed arg do testShape.setTransformLockBitArrayTo ( getTmLockBitArrayFromCheckboxes() )
	on chkScaleY changed arg do testShape.setTransformLockBitArrayTo ( getTmLockBitArrayFromCheckboxes() )
	on chkScaleZ changed arg do testShape.setTransformLockBitArrayTo ( getTmLockBitArrayFromCheckboxes() )
)

addRollout controlShapeRoll controlShapeFloater
addRollout StandardLoadSaveRoll controlShapeFloater 

StandardLoadSaveRoll.LoadSaveWrapper.fnPtrSave = controlShapeRoll.WriteMe
StandardLoadSaveRoll.LoadSaveWrapper.fnPtrLoad = controlShapeRoll.ReadMe
StandardLoadSaveRoll.setFilePathTo "$userscripts/KenzorsScripts/common/control shapes/"