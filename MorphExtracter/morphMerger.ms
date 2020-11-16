--morphTargets = #()
--morphTargets = for i in selection collect i.name 
for obj in selection do 
(
    morphStack = obj.morpher
    origin = obj
    for i=1 to morphTargets.count do 
    (

        local MorphName = WM3_MC_GetName morphstack i
        if MorphName != "- empty -" then 
        (
            for j in morphTargets do
            (
                if MorphName == j do 
                (
                    WM3_MC_SetValue morphStack i 100.0 
                    Copied = Copy origin
                    select Copied 

                    sleep 0.1 

                    macros.run "Modifier Stack" "Convert_to_Poly"
                    Copied.pos = (getNodeByName j).transform.pos 
                    Copied.name = j 
                    select origin

                    WM3_MC_SetValue morphStack i 0.0 

                )
            )
        )
    )
)