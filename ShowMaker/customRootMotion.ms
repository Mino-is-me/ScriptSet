fileIn  "\\\\10.220.70.12\\eve\\ART_Backup\\Script\\Library\\copyPaste.ms"


loadMaxFile  showMaker.edt_caster.text quiet:true

ar_tm_linkTarget = #()

if not (isValidNode $SC_LinkTarget) do (
    sc_LinkTarget = dummy()
    sc_LinkTarget.parent = $Root
    sc_LinkTarget.transform = (matrix3 [1,0,0] [0,1,-1] [0,1,1] [0,0,0])
    sc_LinkTarget.name = "SC_LinkTarget"
)

controller = getNodeByName showMaker.pbtn_controller.text --caught by showMaker

pnt_expose = point()
pnt_expose.box = off
pnt_expose.axistripod = on 
pnt_expose.centermarker = on 
pnt_expose.size = 120.0
pnt_expose.rotation = quat 0 0 -1 0

controller.rotation.controller = Orientation_constraint()
controller.rotation.controller.appendTarget pnt_expose 50.0

with animate on (
    for i=animationRange.start to animationRange.end do (
        sliderTime = i 
        
        $sc_LinkTarget.transform = controller.transform 
    )
)
sliderTime = animationRange.start

-- for i=animationRange.start to animationRange.end do (
--     sliderTime = i 
--     append ar_tm_linkTarget $sc_LinkTarget.transform 
-- )
deselect $* 
select $sc_LinkTarget 
copyNode()
sliderTime = animationRange.start

saveMaxFile (
    (showMaker.edt_exportPath.text) + ("\\LinkCaster.max") 
) quiet:true

resetMaxFile #noPrompt 



----------------------------- load target from here ----------------------------------------
loadMaxFile  showMaker.edt_target.text quiet:true


pasteNode()
xpose = $sc_LinkTarget


--Rotate $Root (Quat 0 0 1 0) -- Root Yaw Value Align 

xposeCOM = dummy()
xPoseCOM.name = "xPoseCOM"
with animate on (
    for i=animationRange.start to animationRange.end do (
        sliderTime = i 
        xposeCOM.transform = $Bip001.transform
    )
)
sliderTime = animationRange.start
--좇같은 맥스스크립트 시발 
-- cnt = 1
-- xpose = dummy()
-- with animate on (
--     for i=animationRange.start to animationRange.end do (
--         sliderTime = i 
        
-- 		if ar_tm_linkTarget[cnt] != undefiend then (
--             xpose.transform = ar_tm_linkTarget[cnt]
--             cnt += 1
--         )
--         else ( break )
--     )
-- )
-- sliderTime = animationRange.start

par = dummy() 
par.name = "par"
xpose.parent = par 
par.rotation = quat 0 0 -1 0 

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
with animate on (
	for i=animationRange.start to animationRange.end do (
		sliderTime = i 
		$Bip001.transform = xposeCOM.transform
	)
)


SliderTime = AnimationRange.start 
Biped.collapseAtLayer $Bip001.controller 0

--Rotate $Root (Quat 0 0 1 0) -- Root Yaw Align 

saveMaxFile (
(showMaker.edt_exportPath.text) + ("\\LinkTarget.max") 
) quiet:true


--free ar_tm_linkTarget