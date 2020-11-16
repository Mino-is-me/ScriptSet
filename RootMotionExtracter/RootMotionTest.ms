ar_COMRot = #()
ar_COMPos = #()
ar_RootPos= #()
ar_originPos = #() 
ar_reflectedRot = #() 

distanceFromRoot = [0,0,0]
cnt = 0 

dm_reflectCOM = Dummy() 
dm_RotationCOM = Dummy() 

AnimStart = AnimationRange.start as integer / 160 
AnimEnd = AnimationRange.end as integer / 160


FrameCount = AnimEnd-AnimStart + 1
/*
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
*/

-------------------Position Controller-----------------------
/*
dm_reflectCOM.pos.controller = position_Constraint() 

dm_reflectCOM.pos.controller.appendTarget $Bip001 50.0
dm_reflectCOM.pos.controller.appendTarget $Bip001_Head 50.0 
dm_reflectCOM.pos.controller.relative = on 
*/
--dm_reflectCOM.parent = $Bip001 
sliderTime = AnimationRange.Start 

-------------------Position Controller-----------------------
dm_reflectCOM.position.controller = Position_Constraint()
dm_reflectCOM.position.controller.appendTarget $Bip001 50.0 
dm_reflectCOM.position.controller.relative = on 
-------------------Rotation Controller-----------------------
dm_RotationCOM.rotation.controller = Orientation_Constraint() 
dm_RotationCOM.rotation.controller.appendTarget $Bip001 50.0 
dm_RotationCOM.rotation.controller.relative = on 
-------------------Rotation Controller-----------------------
for i=AnimationRange.start to AnimationRange.end do 
(
    sliderTime = i
	cnt = cnt + 1
	if isXAxisChecked then
	(
		newVec = [0,dm_reflectCOM.pos.y,dm_reflectCOM.pos.z]
	)
	else 
	(
		newVec = dm_reflectCOM.pos 
	)
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

sliderTime = AnimationRange.start
 
for i=1 to ar_COMPos.count do 
(
	ar_COMPos[i].z = 0 
)

$Bip001.parent = World 

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

sliderTime = AnimationRange.End
sliderTime = AnimationRange.Start
--Biped Layer Bug 안전처리 
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

--DeleteKeys $Root.rotation.controller.Z_Rotation.controller #allKeys
