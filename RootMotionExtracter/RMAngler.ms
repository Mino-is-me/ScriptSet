global arAngles = #() 
global arAnglesDisplayName = #() 
global origin = ""
fn makeRotateAngle yaw = 
(
    local rotateAngle = EulerAngles 0 0 Yaw 
    return rotateAngle 
)
fn angleToClockwise iAngle =
(
    local clockwiseAngle = 360 - iAngle 
    return clockwiseAngle 
)
fn TempFn iAngle = 
(
	rotateAngle = makeRotateAngle iAngle  
	$Bip001.parent = world 

	$Bip001.controller.moveAllMode = true 

	rotate $Bip001 rotateAngle 

	biped.collapseMoveAllMode $Bip001.controller 
	
	$Bip001.controller.moveAllMode = false
	$Bip001.parent = $Root 
	
)

--try(destroyDialog LocoMocapRotator) Catch() 

Rollout LocoMocapRotator "Mocap Locomotion Rotator" 
(
	Spinner sp_AngleSelector "select Angle Here"	range:[0,360,0] type:#integer fieldWidth:50
	--button btn_newAngle "select Angle"
	multiListBox mlb_angleList "Angle Lists"
	button btn_makeAngularMaxFile "Make Rotated MAX File" across:2
	button btn_makeAngularBipFile "Make Rotated BIP File"
	on sp_AngleSelector entered do 
	(
		append arAngles sp_AngleSelector.value 
		arAnglesDisplayName = #() 
		for i in arAngles do append arAnglesDisplayName ( (i as string) + " Degree") 
		mlb_angleList.items = #() 
		mlb_angleList.items  = arAnglesDisplayName

    )
    
    on btn_makeAngularMaxFile pressed do 
    (
        origin = MaxFilePath + MaxFileName 

        for i=1 to arAngles.count do 
        (
            if i != 1 do 
            (
                loadMaxFile Origin quiet:true
            )
            local iAngle = angleToClockwise arAngles[i]

            TempFn iAngle
            newMaxFileName = (getFileNameFile MaxFileName) + arAnglesDisplayName[i] + ".max"
            saveMaxFile  (MaxFilePath + newMaxFileName) 
        )

	)
	on btn_makeAngularBipFile pressed do 
	(
		origin = MaxFilePath + MaxFileName 

		for i=1 to arAngles.count do 
		(
			if i != 1 do 
			(
				loadMaxFile Origin quiet:true
			)
			local iAngle = angleToClockwise arAngles[i]

			TempFn iAngle
			newBipFileName = (getFileNameFile MaxFileName) + arAnglesDisplayName[i] + ".bip"
			biped.saveBipFile $Bip001.controller (MaxFilePath+newBipFileName)
		)

	)

)--createDialog LocoMocapRotator
