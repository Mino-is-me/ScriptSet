--I'm freaking Lazy 
--Script by MINO 


Try(DestroyDialog 'rlt_lazyTool')
Catch()

rollout 'rlt_lazyTool' "Lazy Tool"
(
    Group "Reset"
    (
        Button btn_resetXForm "Reset XForm Selected" align:#left
        Button btn_pos000 "Set Pos [0,0,0]" align:#left
    )
    Group "Pivot"
    (
        Button btn_resetPivot "Reset Pivot Selected" align:#left
        spinner spn_xpos "X"  type:#integer align:#left width:50 scale:10 across:3
        spinner spn_ypos "Y" type:#integer align:#left width:50 scale:10
        spinner spn_zpos "Z" type:#integer align:#left width:50 scale:10
    )
    group "POS"
    (
        Button btn_posCopy "Pos Copy" align:#left across:2
        Button btn_posPaste "Pos Paste" align:#left
        spinner spn_xpos1 "X"  type:#Float align:#left range:[-1000,1000,0] width:70 scale:10 across:3
        spinner spn_ypos1 "Y" type:#Float align:#left range:[-1000,1000,0] width:70 scale:10
        spinner spn_zpos1 "Z" type:#Float align:#left range:[-1000,1000,0] width:70 scale:10
    )

    label lb_waterMark "Script by MINOMI"

    on btn_resetXForm pressed do 
    (
        ResetXForm $
    )
    on btn_pos000 pressed do 
    (
        $.pos = [0,0,0]
    )

    on btn_posCopy pressed do 
    (
        spn_xpos1.value = $.pos.x
        spn_ypos1.value = $.pos.y
        spn_zpos1.value = $.pos.z
    )
    on btn_posPaste pressed do 
    (
        $.pos = [spn_xpos1.value,spn_ypos1.value,spn_zpos1.value]
    )

    on btn_resetPivot pressed do 
    (
        $.pivot = [spn_xpos.value,spn_ypos.value,spn_zpos.value]
    )
)

CreateDialog 'rlt_lazyTool' 250 400