--Script by Minomi

--PathFinder : Make Anim Key from Path Translation
--only Support one Path (this Time)
ar_RootPoses = #()
ar_COMRot = #() 
dm_Path = $Root.pos.controller.path 
bn_Root = $Root 
originV = [0,0,0]
for i=AnimationRange.start to AnimationRange.end do  
(
	sliderTime = i 
	newVec = Biped.getTransform $Bip001 #Pos 
    append ar_RootPoses newVec
	append ar_COMRot (Biped.getTransform $Bip001 #Rotation)

	if i==0f do 
	(
		originV = bn_Root.pos 
	)
)
sliderTime = 0
$Root.position.controller = Position_XYZ()

for i=AnimationRange.start to AnimationRange.end do  
(
	sliderTime = i 
	bn_Root.pos = originV
	frToInt = (i as integer ) / 160

	biped.setTransform $Bip001 #pos ar_RootPoses[frToInt+1] true 
	biped.setTransform $Bip001 #Rotation ar_COMRot[frToInt +1] true 
)

sliderTime = 0f 