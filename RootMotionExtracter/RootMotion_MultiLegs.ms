undo on 
(


	if IdlePos == 1 do 
	(
		--Global InitialTransformSetting = "\\\\10.220.70.12\\eve\\ART_Backup\\Script\\RootMotionExtracter\\InitTransforms.ini"
		Global InitialTransform = getINISetting InitialTransformSetting ((RootMotionMaker.Species.selection) as string) "initTransform"
		--Global IdlePos = RootMotionMaker.TimingSlider.Value



		InitialTransform = execute InitialTransform
		SliderTime = AnimationRange.start 
		StartTM = $Root.Transform 
		$Bip001.parent = World 
		select $Root 
		max set key keys
		sliderTime = AnimationRange.End
		TM = $Bip001.transform 
		--biped.createLayer $Bip001.controller 1 "RMotionLayer01"
		$Bip001.transform = InitialTransform
		$Root.parent = $Bip001 
		$Bip001.transform = TM
		EndTM = $Root.transform
		$Root.parent = World 
		
		Set Animate On 
		
		SliderTIme= AnimationRange.start 
		
		$Root.transform = StartTM 
		
		SliderTIme = ANimationRange.End 
		
		$Root.transform = EndTM
		
		Set Animate Off 
		
		redrawViews()
		
		sleep 0.1
		--biped.collapseAtLayer $Bip001.controller 0
		
		$Root.parent = World 
		ar_COMRot = #()
		ar_COMPos = #()
		ar_RootPos= #()
		ar_originPos = #() 
		ar_reflectedRot = #() 

		distanceFromRoot = [0,0,0]
		cnt = 0 

		dm_reflectCOM = Dummy() 
		dm_RotationCOM = Dummy() 
		dm_reflectCOM.pos = $Root.pos
		
		
		AnimStart = AnimationRange.start as integer / 160 
		AnimEnd = AnimationRange.end as integer / 160

		FrameCount = AnimEnd-AnimStart + 1
		

		-------------------Position Controller-----------------------
		dm_reflectCOM.position.controller = Position_Constraint()
		dm_reflectCOM.position.controller.appendTarget $Bip001 50.0 
		dm_reflectCOM.position.controller.relative = on 
		-------------------Rotation Controller-----------------------
		dm_RotationCOM.rotation.controller = Orientation_Constraint() 
		dm_RotationCOM.rotation.controller.appendTarget $Bip001 50.0 
		dm_RotationCOM.rotation.controller.relative = on 
		-------------------Rotation Controller-----------------------
		
		redrawViews()
		sleep 0.1
		for i=AnimationRange.start to AnimationRange.end do 
		(
			sliderTime = i
			cnt = cnt + 1

			newVec = dm_reflectCOM.pos 
			newQuat = biped.getTransform $Bip001 #Rotation 
			
			comVec = biped.getTransform $Bip001 #Pos

		/*
			if i == 0f then 
			(
				append ar_RootPos $Root.pos 
			)
			else 
			(
				CoM_MovementVector = newVec - ar_COMPos[cnt-1]
				append ar_RootPos CoM_MovementVector
			)
		*/
			append ar_COMPos newVec -- reflected COM Pos 
			append ar_COMRot newQuat -- COM Rot 
			append ar_originPos comVec -- COM Pos 
			append ar_reflectedRot dm_RotationCOM.rotation 
		) 

		sliderTime = AnimationRange.End
        sleep 0.1
        redrawViews()
		for i=1 to ar_COMPos.count do 
		(
			ar_COMPos[i].z = 0 
		)

		$Bip001.parent = World 
        sleep 0.1
        redrawViews()
		Set Animate On 
		cnt1= 0
		for i=AnimationRange.start to AnimationRange.end do 
		(
			SliderTime = i 
			cnt1 = cnt1+1
			--print sliderTime 
			frCNT = ( (i as integer) / 160) + 1 
			--print frCNT 
			$Root.pos = ar_COMPos[cnt1]
			--print ar_COMPos[cnt1]
			$Root.pos.z = 0
			/*
			if sliderTIme == AnimationRange.end do 
			(
				$Root.transform = (matrix3 [0.916889,-0.399142,3.27826e-07] [0.399142,0.916889,0] [-3.57628e-07,0,1] [297.307,-281.175,1.52588e-05])
			)
			*/
			--print $Root.pos
			--$Root.rotation = ar_reflectedRot[frCNT]
			--$Root.rotation = ar_COMRot[frCNT]
		)
		Set Animate Off 
        sleep 0.1
        redrawViews()
		--
		set Animate on 
		sliderTIme = AnimationRange.end 
		Rotate $Root euRotateAngle
		set Animate Off 
		sliderTIme = AnimationRange.start 
		--
		$Bip001.parent=$Root

		set Animate on 
        sleep 0.1
        redrawViews()
		biped.createLayer $Bip001.controller 1 "RMotionLayer01"

		sliderTime = AnimationRange.End
		sliderTime = AnimationRange.Start
		--Biped Layer Bug ???? 
		cnt2 = 0
		for i=AnimationRange.start to AnimationRange.end do 
		(
			sliderTime = i
			cnt2=cnt2+1
			frCNT = ( (i as integer) / 160) + 1 
			
			biped.setTransform $Bip001 #pos ar_originPos[cnt2] true 
			biped.setTransform $Bip001 #Rotation ar_COMRot[cnt2] true 
		)
		Set Animate Off 

	)
)