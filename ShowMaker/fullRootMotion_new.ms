filein (projectDir + "Library\\copyPaste.ms")
----------------------------- load target from here ----------------------------------------
loadMaxFile  showMaker.edt_target.text quiet:true

pnt_expose_COM = point()
pnt_expose_COM.box = off
pnt_expose_COM.axistripod = on 
pnt_expose_COM.centermarker = on 
pnt_expose_COM.size = 120.0
pnt_expose_COM.name = "COM_EXPOSE"

pnt_expose_Root = point()
pnt_expose_Root.name = "Root_EXPOSE"
pnt_expose_Root.size = 120.0
pnt_expose_Root.transform = $Root.transform 
pnt_expose_Root.position.controller = Position_Constraint()
pnt_expose_Root.position.controller.appendTarget $'Bip001' 50.0
pnt_expose_Root.position.controller.relative = on 

pnt_ex_root_recoder = dummy()

with animate on (  --COM transform expose 
    for i in animationRange.start to animationRange.end do (
        sliderTime = i 
        pnt_expose_COM.transform = $'Bip001'.transform
        pnt_ex_root_recoder.transform = pnt_expose_Root.transform 
    )
)
sliderTime = animationRange.start

with animate on ( -- floor z height of root 
    for i in animationRange.start to animationRange.end do (
        sliderTime = i 
        if pnt_ex_root_recoder.pos.z < 0.0 then (
            pnt_ex_root_recoder.pos.z = 0.0
        )
    )
)

with animate on ( -- make Root motion
    for i in animationRange.start to animationRange.end do (
        sliderTime = i 
        $'Root'.transform = pnt_ex_root_recoder.transform
    )
)

biped.createLayer $Bip001.controller 1 "RMotionLayer01"
with animate on ( -- floor COM transform 
    for i in animationRange.start to animationRange.end do (
        sliderTime = i 
        $'Bip001'.transform = pnt_expose_COM.transform
    )
)
sliderTime = animationRange.start 
--Biped.collapseAtLayer $Bip001.controller 0

sliderTime = animationRange.start 

$Root.pos = [0,showMaker.spn_distance.value,0]

if ( showMaker.edt_exportPath.text != "" ) do (
    saveMaxFile ((showMaker.edt_exportPath.text) + ("\\LinkTarget.max") ) quiet:true
)

select $Root 
$.name = "SC_LinkTarget_origin"
copyNode()
------load caster from here---------
loadMaxFile showMaker.edt_caster.text quiet:true 
pasteNode() 

if not (isValidNode $SC_LinkTarget) do (
    sc_LinkTarget = dummy()
    sc_LinkTarget.parent = $Root
    sc_LinkTarget.transform = (matrix3 [1,0,0] [0,1,0] [0,0,1] [0,0,0])
    sc_LinkTarget.name = "SC_LinkTarget"
)


LinkTargetMirrorMaker = dummy()
LinkTargetMirrorMaker.name = "LinkTargetMirrorMaker"
$SC_LinkTarget_origin.parent = LinkTargetMirrorMaker
LinkTargetMirrorMaker.rotation = quat 0 0 -1 0 

with animate on (
    for i in animationRange.start to animationRange.end do (
        sliderTime = i 
        $sc_LinkTarget.transform = $SC_LinkTarget_origin.transform 
    )
)
sliderTime = animationRange.start 

delete $SC_LinkTarget_origin

if ( showMaker.edt_exportPath.text != "" ) do (
    saveMaxFile ((showMaker.edt_exportPath.text) + ("\\LinkCaster.max") ) quiet:true
)