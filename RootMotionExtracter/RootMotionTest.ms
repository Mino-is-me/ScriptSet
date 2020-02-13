ar_COMRot = #()
ar_COMPos = #()
ar_RootPos= #()
ar_originPos = #() 
ar_reflectedRot = #() 

distanceFromRoot = [0,0,0]
cnt = 0 

dm_reflectCOM = Dummy() 
dm_RotationCOM = Dummy() 


fn objToVector object =
(
	startPos = object.pos
	in coordsys object (tempPoint = point pos:[0,0,1])
	endPos = tempPoint.pos
	delete tempPoint
	
	vector = endPos - startPos
	
	print ( object.name + ": " +  vector as string )
	return vector
)

-------------------Position Controller-----------------------
/*
dm_reflectCOM.pos.controller = position_Constraint() 

dm_reflectCOM.pos.controller.appendTarget $Bip001 50.0
dm_reflectCOM.pos.controller.appendTarget $Bip001_Head 50.0 
dm_reflectCOM.pos.controller.relative = on 
*/
dm_reflectCOM.parent = $Bip001 
-------------------Position Controller-----------------------
-------------------Rotation Controller-----------------------
dm_RotationCOM.rotation.controller = Orientation_Constraint() 
dm_RotationCOM.rotation.controller.appendTarget $Bip001 50.0 
dm_RotationCOM.rotation.controller.relative = on 
-------------------Rotation Controller-----------------------
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

sliderTime = 0f 

for i=1 to ar_COMPos.count do 
(
	ar_COMPos[i].z = 0 
)

$Bip001.parent = World 

Set Animate On 

for i=AnimationRange.start to AnimationRange.end do 
(
    SliderTime = i 
	frCNT = ( (i as integer) / 160) + 1 
    $Root.pos = ar_COMPos[frCNT]
    $Root.pos.z = 0
    --$Root.rotation = ar_reflectedRot[frCNT]
	--$Root.rotation = ar_COMRot[frCNT]
)
Set Animate Off 

--
set Animate on 
sliderTIme = AnimationRange.end 
Rotate $Root euRotateAngle
set Animate Off 
sliderTIme = AnimationRange.start 
--
$Bip001.parent=$Root

set Animate on 

biped.createLayer $Bip001.controller 1 "RMotionLayer01"

for i=AnimationRange.start to AnimationRange.end do 
(
	sliderTime = i
	frCNT = ( (i as integer) / 160) + 1 
	
	biped.setTransform $Bip001 #pos ar_originPos[frCNT] true 
	biped.setTransform $Bip001 #Rotation ar_COMRot[frCNT] true 
)
Set Animate Off 

--DeleteKeys $Root.rotation.controller.Z_Rotation.controller #allKeys