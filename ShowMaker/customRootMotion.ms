loadMaxFile  showMaker.edt_caster.text quiet:true


ar_tm_linkTarget = #()

if not (isValidNode $SC_LinkTarget) do (
    sc_LinkTarget = dummy()
    sc_LinkTarget.parent = $Root
    sc_LinkTarget.transform = (matrix3 [1,0,0] [0,1,-1.19209e-07] [0,1.19209e-07,1] [0,0,0])
    sc_LinkTarget.name = "SC_LinkTarget"
)

controller = getNodeByName showMaker.pbtn_controller.text --caught by showMaker

with animate on (
    for i=animationRange.start to animationRange.end do (
        sliderTime = i 
        
        $sc_LinkTarget.transform = controller.transform 
    )
)
sliderTime = animationRange.start

for i=animationRange.start to animationRange.end do (
    sliderTime = i 
    append ar_tm_linkTarget $sc_LinkTarget.transform 
)
sliderTime = animationRange.start

saveMaxFile (
    (showMaker.edt_exportPath.text) + ("\\LinkCaster.max") 
) quiet:true

resetMaxFile #noPrompt 



----------------------------- load target from here ----------------------------------------
loadMaxFile  showMaker.edt_target.text quiet:true


ar_comTM = #()
for i=animationRange.start to animationRange.end do (
	sliderTime = i 
    append ar_comTM $Bip001.transform
)
sliderTime = animationRange.start

cnt = 1
xpose = dummy()
with animate on (
    for i=animationRange.start to animationRange.end do (
        sliderTime = i 
        
		if ar_tm_linkTarget[cnt] != undefiend then (
            xpose.transform = ar_tm_linkTarget[cnt]
            cnt += 1
        )
        else ( break )
    )
)
sliderTime = animationRange.start
ar_COMPos = #()
ar_RootPos= #()
ar_originPos = #() 

distanceFromRoot = [0,0,0]
cnt = 0 

dm_reflectCOM = Dummy() 
dm_RotationCOM = Dummy() 
--dm_reflectProp = Dummy()

AnimStart = AnimationRange.start as integer / 160 
AnimEnd = AnimationRange.end as integer / 160


FrameCount = AnimEnd-AnimStart + 1

sliderTime = AnimationRange.Start 

-------------------Position Controller-----------------------
dm_reflectCOM.position.controller = Position_Constraint()
if isValidNode $Bip002 and not isValidNode $Bip001 then 
(
	for i in $Bip002* do
	(
		i.name = substituteString i.name "Bip002" "Bip001"
	)
)
dm_reflectCOM.position.controller.appendTarget $Bip001 50.0 
dm_reflectCOM.position.controller.relative = on 
	
if isValidNode $Root001 and not isValidNode $Root do
(
	$Root001.name = "Root"
)

for i=AnimationRange.start to AnimationRange.end do 
(
    sliderTime = i
	cnt = cnt + 1


	newVec = dm_reflectCOM.pos 

	comVec = biped.getTransform $Bip001 #Pos
	

    append ar_COMPos newVec -- reflected COM Pos 

    append ar_originPos comVec -- COM Pos 

) 

sliderTime = AnimationRange.start

$Bip001.parent = World 

with animate on 
(
	cnt1= 0
	for i=AnimationRange.start to AnimationRange.end do 
	(
		SliderTime = i 
		cnt1 = cnt1+1
		frCNT = ( (i as integer) / 160) + 1 
		if ar_COMPos[cnt1].z < 0 do
		(
			ar_COMPOS[cnt1].z = 0.0
		)
		$Root.pos = ar_COMPos[cnt1]
	)
)

--
set animate on 
sliderTIme = AnimationRange.end 
set animate Off 
sliderTIme = AnimationRange.start 
--
$Bip001.parent=$Root

with animate on 
(
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
		--biped.setTransform $Bip001 #Rotation ar_COMRot[cnt2] true 

	)
)

SliderTime = AnimationRange.start 

Biped.collapseAtLayer $Bip001.controller 0

with animate on (
    for i=animationRange.start to animationRange.end do (
        sliderTime = i 
		
		$Root.transform = xpose.transform
    )
)

saveMaxFile (
(showMaker.edt_exportPath.text) + ("\\LinkTarget.max") 
) quiet:true


--free ar_tm_linkTarget