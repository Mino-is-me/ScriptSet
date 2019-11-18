A = getFiles "Z:\\ART_Backup\\TA_TestFolder\\MotionMatching_Part2\\*.max"

for i in A do 
(

	loadMaxFile i quiet:true 

	Try ( $Root001.name = "Root")
	Catch()
	if $Bip001.parent != $Root do 
		(
			$Bip001.parent = $Root 
		)

		isRootSubHere = isValidNode $Root_Sub

		if isRootSubHere == false do 
		(
			A = Dummy()
			A.name = "Root_Sub"
			A.parent = $Root
			$Bip001.parent = $Root_Sub 	
		)

		setInheritanceFlags $Root_sub #{7..9}

		sleep 1 

		sobj = $Root
		tobj = $Bip001

		select $Root_Sub
		setInheritanceFlags $Root_sub #{7..9}

		redrawViews() 	 

		astart = animationrange.start
		aend = animationrange.end

		stepCount = 1 

		Exposer = Dummy() 
		animate on
		(
			for i =astart to aend do
			(
				slidertime = i
				sobj.transform = tobj.transform
				Exposer.transform = $Bip001.transform 

				if IsKindOf sobj Biped_Object then
				(
					biped.setTransform sobj #pos tobj.transform.position true
					biped.setTransform sobj #rotation tobj.transform.rotation true
				)
			)
		)
		SliderTime = 0f 
		
		$Root.transform = $Root_Sub.transform 
		DeleteKeys $Root.position.controller.Z_Position.controller #allKeys
		DeleteKeys $Root.rotation.controller.X_Rotation.controller #allKeys
		DeleteKeys $Root.rotation.controller.Y_Rotation.controller #allKeys

		delete $Root_Sub 
		biped.createLayer $Bip001.controller 1 "RMotionLayer01"
		
		$Bip001.parent = $Root 
		set Animate on 
		for i = AnimationRange.start to AnimationRange.end do 
		(
			SliderTime = i 
			$Bip001.transform = Exposer.transform 
			
		)

		sliderTime = 0f
		delete Exposer 

		saveMaxFile i quiet:true 
)