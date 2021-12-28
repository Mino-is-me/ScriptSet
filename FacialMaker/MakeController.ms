
for i=1 to 51 do 
(
    morphName = $CH_P_EVE_Face_003.morpher[i].name 
    MName = FilterString morphName " "
    ctrl = getNodebyName (MName[2] + "_CTRL")

    ctrlName = (MName[2] + "_CTRL")
    --select ctrl 

    script = "CTRL.position.controller.Path_Constraint.controller.percent"

    $CH_P_EVE_Face_003.morpher[i].controller = Float_Script()
    sleep 0.1
    $CH_P_EVE_Face_003.morpher[i].controller.AddConstant "CTRL" ctrl
    sleep 0.1
    $CH_P_EVE_Face_003.morpher[i].controller.script = script 
    sleep 0.1

)
