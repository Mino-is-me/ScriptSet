global isXAxisChecked = false 
global isYAxisChecked = false 
global isYawChecked = false 
global isKeepingDistance = false 
global euRotateAngle = (eulerAngles 0 0 0)

Global InitialTransformSetting = "\\\\10.220.70.12\\eve\\ART_Backup\\Script\\RootMotionExtracter\\InitTransforms.ini"
--Global InitialTransform = getINISetting InitialTransformSetting ((RootMotionMaker.Species.selection) as string) "initTransform"
Global IdlePos = 0
Global exportWithRootMotion = false
 
fn makeRootMotion SpeciesSelection = -- bool bool bool 
(
	if SpeciesSelection == 1 then 
	(
		--print "1"
		fileIn "\\\\10.220.70.12\\eve\\ART_Backup\\Script\\RootMotionExtracter\\RootMotionTest.ms"
	)

	else 
	(
		--print "2"
		fileIn "\\\\10.220.70.12\\eve\\ART_Backup\\Script\\RootMotionExtracter\\RootMotion_MultiLegs.ms"
	)
)

fn getDistanceVector3 =
(
	RootPos = $Root.pos 
	COMPos = $Bip001.transform.pos 
	distanceV = [0,0,0]

	distanceV.x = RootPos.x - COMPos.x 
	distanceV.y = RootPos.y - COMPos.y 
	distanceV.z = ROotPos.z - COMPos.z 

	return distanceV 
)



Rollout RootMotionMaker "Extract Root Motion"
(

	--checkBox extractRootMotion "Extract Root Motion"
	/*
	Group "Extract Position"
	(
		checkBox extractFront "Extract Front / Back" across:2 tooltip:"Front -> Right -> Yaw 순으로 활성화됩니다."
		checkBox extractRight "Extract Right / Left" enabled:false 
	)
	Group "Extract Rotation"
	(
		checkBox extractYaw "Extract Yaw Rotation" enabled:false 
	)
	*/
	Group "Extract"
	(
		--label Warning "*Mino is Fixing this Stuff, Thanks for your excuse*"
		checkBox withRootMotion "Export with Root Motion" across:2
		checkBox FrontBackOnly "Front and Back Only"
		--checkBox keepOffset "Keep Offset Between Root and COM" enabled:false
		/*
		checkBox ManualRotation "Use Manual Rotation" enabled:false across:2
		spinner rotateAngles "Rotate Angle" range:[-360,360,0] type:#integer Across:2 enabled:false
		*/
		button extractOnly "Extract Root Motion non export" enabled:true align:#Left
		DropDownList Species "Species" items:#("Basic","M_Lion","M_Grub","M_Gorilla")
		slider TimingSlider "where is Idle Pos" range:[0,1,0] type:#integer
		--button debug "Do not use this except who can handle this"
	)

	--rotateAngles.enabled = false 
	--checkButton chkRMWithRotationValue "Extract with Rotation"
	--Button btnMake "Make RootMotion"
/*
	on debug pressed do
	(
		fileIn "\\\\10.220.70.12\\eve\\ART_Backup\\Script\\RootMotionExtracter\\RootMotion_MultiLegs.ms"
	)
*/	
	on FrontBackOnly Changed val do 
	(
		isXAxisChecked = val 
	)
	on TimingSlider Changed val do 
	(
		IdlePos = val 
	)
	on withRootMotion changed val do 
	(
		if val == true then 
		(
			exportWithRootMotion = true 

			--keepOffset.enabled = true 
			--ManualRotation.enabled = true 

		)
		else 
		(
			exportWithRootMotion = false 
			--keepOffset.enabled = false
			--ManualRotation.enabled = false

				
		)
	)

	on ManualRotation changed val do 
	(
		if val then  
		(
			rotateAngles.enabled = true 

		)
		else if not val then 
		(
			rotateAngles.enabled = false 
				
		)
	)
	
	on extractFront changed val do 
	( 
		if val == true then 
		(
			isXAxisChecked = true 

			extractRight.enabled = true 
		)
		else 
		(
			isXAxisChecked = false 
			extractRight.enabled = false 
		)

	)

	on extractRight changed val do 
	(
		if val == true then 
		(
			isYAxisChecked = true 
			extractYaw.enabled = true  
		)
		else 
		(
			isYAxisChecked = false
			extractYaw.enabled = false  
		)

	)

	on extractYaw changed val do 
	(
		if val == true then 
		(
			isYawChecked = true 
		)
		else 
		(
			isYawChecked = false 
		)
	)

	on rotateAngles changed val do 
	(
		euRotateAngle = (eulerAngles 0 0 val)
	)

	on extractOnly pressed do 
	(

		makeRootMotion RootMotionMaker.Species.Selection
	)

)--createDialog RootMotionMaker 505 200

