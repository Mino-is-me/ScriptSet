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
with animate on (
    for i=animationRange.start to animationRange.end do (
        sliderTime = i 
        
		if ar_tm_linkTarget[cnt] != undefiend then (
            $Root.transform = ar_tm_linkTarget[cnt]
            cnt += 1
        )
        else ( break )
    )
)
sliderTime = animationRange.start

cnt = 1
biped.createLayer $Bip001.controller 1 "RMotionLayer01"
with animate on (
    for i=animationRange.start to animationRange.end do (
        sliderTime = i 
        $Bip001.transform = ar_comTM[cnt]
        cnt += 1
    )
)
sliderTime = animationRange.start


Biped.collapseAtLayer $Bip001.controller 0

saveMaxFile (
(showMaker.edt_exportPath.text) + ("\\LinkTarget.max") 
) quiet:true


--free ar_tm_linkTarget
free pbtn_controller_name