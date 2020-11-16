filein "\\\\10.220.70.12\\eve\\ART_Backup\\Script\\Library\\stella.ms"


Global CreatedNodes = #() 
Global SpineNode --Pick the Lowest Spine Node in Heirachy
Global NoUse = #("Dm L ForeArm","Dm R ForeArm","Dm R Calf","Dm L Calf")
Global TwistFriends = #("Ab L UpperArm Twist", "Ab R UpperArm Twist")
Global COMHeight = $bip001.controller.height
Try ( DestroyDialog ARH_UI ) Catch()
rollout ARH_UI "Auto Rig Humanoid" width:440 height:800
(
	checkBox 'chk_isFemale' "is Female?" pos:[45,28]
	checkButton 'chk_head' "Head && Neck" pos:[152,28] width:118 height:135 align:#left checked:true
	Button 'make' "Make Rig" pos:[300,28] width:100 height:70 align:#left
	checkButton 'ckb_LArm' "Left Arm" pos:[75,184] width:53 height:209 align:#left
	checkButton 'ckb_RArm' "Right Arm" pos:[291,184] width:57 height:205 align:#left
	checkButton 'ckb_Spine' "Spine" pos:[169,176] width:81 height:255 align:#left checked:true
	checkButton 'ckb_LLeg' "Left Leg" pos:[110,430] width:50 height:248 align:#left
	checkButton 'ckb_RLeg' "Right Leg" pos:[260,430] width:50 height:248 align:#left
	checkButton 'ckb_LFoot' "Left Foot" pos:[41,689] width:116 height:60 align:#left
	checkButton 'ckb_RFoot' "Right Foot" pos:[260,688] width:116 height:60 align:#left
	label 'lbl1' "Auto Rig Humanoid @ Script By Minomi" pos:[112,758] width:239 height:34 align:#left



	on make pressed do 
	(
		format "Make AutoRig... \n"

		filein "\\\\10.220.70.12\\eve\\ART_Backup\\Script\\Library\\stella.ms"
		--stella Library Include--
		Global arBoneSets = #(2,2,2,2)
		Global arStates = #(true,true,true)

		undo on 
		(
			TBSetFunction arBoneSets arStates 
		) 
		select $Bone* 

		for i=1 to selection.count do 
		(
			selection[i].name = substituteString selection[i].name "Bone" "Ab"
		)


		deselect $*

		select $Joint*
		for i=1 to selection.count do 
		(
			selection[i].name = substituteString selection[i].name "Joint" "Dm" 
		)
		deselect $* 

		-- obj = $
		-- arProperties = getPropNames obj
		-- for i=1 to arPropValues.count do 
		-- (
		-- 	setProperty obj arProperties[i] arPropValues[i] 
		-- )

		if ckb_Spine.checked == true do 
		(		
			( --Dm Clavicle Point
				SpineCount = ($Bip001.controller.SpineLinks)-1
				SpineNodeName = "$'Bip001 Spine" + (SpineCount as string) + "'"
				SpineNode = Execute SpineNodeName
				ClaviclePoint = point()
				ClaviclePoint.name = "Dm Clavicle Point"
				for i=1 to (getPropNames ClaviclePoint).count do
				(
					setProperty ClaviclePoint (getPropNames ClaviclePoint)[i] #(5.0, false, false, false, true, false, false)[i]
				)
				ClaviclePoint.parent = SpineNode
				ClaviclePoint.transform = (matrix3 [1,0,0] [0,1,-2.32645e-05] [0,2.32837e-05,1] [11.8261,5.0438,1.29681e-05]) * ClaviclePoint.parent.transform
			)
			------ClaviclePoint------------
			
			-----------Hip------------
			Hip = Point() 
			Hip.name = "Dm Hip Point"
			Hip.parent = $'Bip001 Pelvis'
			Hip.transform = (matrix3 [-1,-5.60284e-06,0] [-5.60284e-06,1,0] [0,0,-1] [-5.99918e-06,0.00750041,209.099]) * Hip.parent.transform 

			Hip.pos.controller = Position_Constraint()
			Hip.pos.controller.appendTarget $'Bip001 Spine' 50.0

			Hip.rotation.controller = rotation_script()

		)
		if chk_head.checked == true do 
		(
			(-- Ab NeckSub
				NeckSub = bonesys.createBone [0,0,1] [0,0,0] [1,0,0]
				NeckSub.name = "Ab NeckSub"
				for i=1 to (getPropNames NeckSub).count do
				(
					setProperty NeckSub (getPropNames NeckSub)[i] #(2.0, 2.0, 10.0, 5.94479, true, 2.0, 10.0, 10.0, true, 5.0, 10.0, 10.0, false, 4.0, 10.0, 10.0, false)[i]
				)
				NeckSub.parent = $'Bip001 Neck' 
				NeckSub.transform = (matrix3 [0.999976,0.00683945,-0.00117663] [-0.00684363,0.99997,-0.00359495] [0.0011521,0.00360295,0.999993] [-0.334976,-0.159534,0.392288]) * NeckSub.parent.transform 
				NeckSub.pos.controller = Position_Constraint()
				NeckSub.pos.controller.appendTarget $'Bip001 Neck' 50.0 
				
				
				NeckSub.rotation.controller = rotation_script()
				NeckSub.rotation.controller.addConstant "OBJ_A" $'Bip001 Head'
				NeckSub.rotation.controller.script = "A_Rot = ( ( (OBJ_A.transform * (inverse OBJ_A.parent.transform) ).rotation ) as eulerAngles)
			
			( EulerAngles (A_Rot.x) (0) (0) )"
				--NeckSub.length = ( distance NeckSub.parent.min NeckSub.parent.max ) * 0.5
			)
			---------Neck-------------
		)
		if ckb_LArm.checked == true do 
		(
			fileIn "\\\\10.220.70.12\\eve\\ART_Backup\\Script\\AutoRigHumanoid\\ARH_LeftLimb.ms"
		)
		if ckb_RArm.checked == true do 
		(
			fileIn "\\\\10.220.70.12\\eve\\ART_Backup\\Script\\AutoRigHumanoid\\ARH_RightLimb.ms"
		)
		if ckb_LLeg.checked == true do 
		(
			fileIn "\\\\10.220.70.12\\eve\\ART_Backup\\Script\\AutoRigHumanoid\\ARH_LeftLeg.ms"
		)
		if ckb_RLeg.checked == true do 
		(
			fileIn "\\\\10.220.70.12\\eve\\ART_Backup\\Script\\AutoRigHumanoid\\ARH_RightLeg.ms"
		)
		if ckb_LFoot.checked == true do 
		(
			fileIn "\\\\10.220.70.12\\eve\\ART_Backup\\Script\\AutoRigHumanoid\\ARH_LeftFoot.ms"
		)

		if ckb_RFoot.checked == true do 
		(
			fileIn "\\\\10.220.70.12\\eve\\ART_Backup\\Script\\AutoRigHumanoid\\ARH_RightFoot.ms"
		)
		
		if chk_isFemale.checked == true do 
		(
			fileIn "\\\\10.220.70.12\\eve\ART_Backup\\Script\\AutoRigHumanoid\\ARH_Breast.ms"
		)
		

		for i in nouse do 
		(
			delete (getNodeByName i)
		)

		Select $Ab* 
		deselect $*Twist*

		for i in selection do 
		(
			i.Length = i.Length * ( COMHeight / 170.0 )
		)

		for i in selection do 
		(
			i.resetBoneStretch()
		)

		for i in TwistFriends do 
		(
			(getNodeByName i).resetBoneStretch()
		)


		format "Auto Rig Process End.\n"
	)
)CreateDialog ARH_UI



---------Neck-------------




