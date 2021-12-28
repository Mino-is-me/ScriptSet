--ATTR Manager 
--Script by MINOMI
rigScriptDir = projectDir + "RiggerScripts\\"
Try(DestroyDialog attrManager) Catch()

Rollout attrManager "Attributes Manager"
(
    DropDownList 'ddl_Attrs' "Attr Lists" items:#("IK Attacher", "IK Baker")
    Button 'btn_Execute' "Execute"  align:#right
    Spinner 'spn_attrNumber' "Num : " align:#right orient:#vertical across:2 type:#integer range:[1,100,1]
    Button 'btn_Delete' "Delete" align:#right
    --Button btn_IKBaker

    on btn_Execute pressed do 
    (
        undo on --pls use undo grouping Mino
        (
            case ddl_Attrs.selection of 
            (
                1: 
                (
                    fileIn ( rigScriptDir + "IKAttacher_New.ms")
                )
                2:
                (
                    fileIn ( rigScriptDir + "IKFKBaker.ms")
                )
            )

        )
    )

    on btn_Delete pressed do
    (
        undo on
        (

            B = custAttributes.getdef $ (spn_attrNumber.value)
            custAttributes.delete $ b
        )
    )
)

--CreateDialog attrManager 