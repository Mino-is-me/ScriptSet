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

with animate on ( $Root.rotation = quat 0 0 1 0 )

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

sleep 0.1 

xpose.pos = [0,0,0]

sleep 0.1 


with animate on (
	for i=animationRange.start to animationRange.end do (
		sliderTime = i 
		$Root.pos = xpose.pos
	)		
)
sliderTime = animationRange.start 

biped.createLayer $Bip001.controller 1 "RMotionLayer01"
sliderTime = animationRange.start 
cnt = 1 
with animate on (
	for i=animationRange.start to animationRange.end do (
		sliderTime = i 
		$Bip001.transform = ar_comTM[cnt]
		cnt += 1
	)
)


SliderTime = AnimationRange.start 
Biped.collapseAtLayer $Bip001.controller 0


saveMaxFile (
(showMaker.edt_exportPath.text) + ("\\LinkTarget.max") 
) quiet:true


--free ar_tm_linkTarget