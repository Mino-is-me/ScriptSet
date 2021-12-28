for i=1 to 51 do 
(
    morphName = $CH_P_EVE_Face_003.morpher[i].name 
    MName = FilterString morphName " "
    ctrl = getNodebyName (MName[2] + "_CTRL")

    ctrlName = (MName[2] + "_CTRL")
    --select ctrl 
    $CH_P_EVE_Face_003.morpher[i].controller = Bezier_Float()

)