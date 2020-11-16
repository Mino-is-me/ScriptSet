global arAngles = #() 
global arAnglesDisplayName = #() 
fn makeRotateAngle yaw = 
(
    local rotateAngle = EulerAngles 0 0 Yaw 
    return rotateAngle 
)
fn TempFn = 
(
	dmForLayer = dummy() 
	rotateAngle = makeRotateAngle 30 
	$Bip001.parent = dmForLayer
	rotate dmForLayer rotateAngle 

	COMExposer = dummy()

	Animate on 
	(
		for i=AnimationRange.start to AnimationRange.end do 
		(
			sliderTime = i 
			COMExposer.transform = $Bip001.transform 
		)
	)
	sliderTIme = 0	
	$Bip001.parent = $root
)

try(destroyDialog LocoMocapRotator) Catch() 

Rollout LocoMocapRotator "Mocap Locomotion Rotator" 
(
	Spinner sp_AngleSelector "select Angle Here"	range:[0,360,0] type:#integer fieldWidth:50
	--button btn_newAngle "select Angle"
	multiListBox mlb_angleList "Angle Lists"
	
	on sp_AngleSelector entered do 
	(
		if sp_AngleSelector.value <= 360 then 
		(
			append arAngles sp_AngleSelector.value 
			arAnglesDisplayName = #() 
			for i in arAngles do append arAnglesDisplayName ( (i as string) + " Degree") 
			mlb_angleList.items = #() 
			mlb_angleList.items  = arAnglesDisplayName
		)
		else
		(
			print "out of range"
		)
	)

)createDialog LocoMocapRotator
