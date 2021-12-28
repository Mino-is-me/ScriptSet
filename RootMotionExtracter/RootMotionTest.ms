ar_COMRot = #()
ar_COMPos = #()
ar_RootPos= #()
ar_originPos = #() 
ar_reflectedRot = #() 

distanceFromRoot = [0,0,0]
cnt = 0 

dm_reflectCOM = Dummy() 
dm_RotationCOM = Dummy() 
if (isValidNode $'Bip001 Prop1' ) then
(
	dm_reflectProp = Dummy()
)
else 
(
	dm_reflectProp = undefined
)
AnimStart = AnimationRange.start as integer / 160 
AnimEnd = AnimationRange.end as integer / 160

isXAxisChecked =  RootMotionMaker.FrontBackOnly.checked

isCTRL = RootMotionMaker.isCTRL.checked 

FrameCount = AnimEnd-AnimStart + 1


nCOM = getNodeByName "Bip001"
nBase = getNodeByName "Base"
nRoot = getNodeByName "Root"
nProp = getNodeByName "Bip001 Prop1"

sliderTime = AnimationRange.Start 


if isCTRL then
(
	nCOM = getNodeByName "Bip001 Ctrl"
	nBase = getNodeByName "Base Ctrl"
	nRoot = getNodeByName "Root Ctrl"
	nProp = getNodeByName "Bip001 Ctrl Prop1"
)

	
	--nCOMParent = nCOM.parent



-------------------Position Controller-----------------------
dm_reflectCOM.position.controller = Position_Constraint()
dm_reflectCOM.position.controller.appendTarget nCOM 50.0 
dm_reflectCOM.position.controller.relative = on 
-------------------Rotation Controller-----------------------
dm_RotationCOM.rotation.controller = Orientation_Constraint() 
dm_RotationCOM.rotation.controller.appendTarget nCOM 50.0 
dm_RotationCOM.rotation.controller.relative = on 
-------------------Rotation Controller-----------------------
for i=AnimationRange.start to AnimationRange.end do 
(
    sliderTime = i
	cnt = cnt + 1
	if isCTRL == false and dm_reflectProp != undefined  then 
	(
		with Animate On
		(
			dm_reflectProp.transform = nProp.transform 
		)
	)

	
	if isXAxisChecked then
	(
		newVec = [0,dm_reflectCOM.pos.y,dm_reflectCOM.pos.z]
	)
	else 
	(
		newVec = dm_reflectCOM.pos 
	)

	newQuat = biped.getTransform nCOM #Rotation 
	comVec = biped.getTransform nCOM #Pos


/*
    if i == 0f then 
    (
        append ar_RootPos Root.pos 
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

--COM.parent = World 

Set Animate On 
cnt1= 0
for i=AnimationRange.start to AnimationRange.end do 
(
    SliderTime = i 
	cnt1 = cnt1+1
	--print sliderTime 
	frCNT = ( (i as integer) / 160) + 1 
	--print frCNT 
    nRoot.pos = ar_COMPos[cnt1]
	--print ar_COMPos[cnt1]
    nRoot.pos.z = 0

)
Set Animate Off 

--
set Animate on 
sliderTIme = AnimationRange.end 
Rotate nRoot euRotateAngle
set Animate Off 
sliderTIme = AnimationRange.start 
--
--COM.parent=COMParent

set Animate on 

biped.createLayer nCOM.controller 1 "RMotionLayer01"



sliderTime = AnimationRange.End
sliderTime = AnimationRange.Start
--Biped Layer Bug 안전처리 
cnt2 = 0
for i=AnimationRange.start to AnimationRange.end do 
(
	sliderTime = i
	cnt2=cnt2+1
	frCNT = ( (i as integer) / 160) + 1 
	

	biped.setTransform nCOM #pos ar_originPos[cnt2] true 
	biped.setTransform nCOM #Rotation ar_COMRot[cnt2] true 

	--prop bake
	if isBakePropKey == true and nprop!=undefined do 
	(
		nProp.transform = dm_reflectProp.transform
	)
	--prop bake end
)
Set animate Off 


sliderTime = animationRange.start