fn zeroCtrls = 
(
    deselect $*
    selectmore $jaw*
    selectmore $mouth*
    for i in selection do 
    (
		Try
		(		
			i.pos.controller.Path_Constraint.controller.percent = 0.0
		)
		Catch()
    )
    deselect $* 
)


Try(DestroyDialog visage ) Catch()
rollout visage "VISAGE" width:400 height:300
(
	groupBox 'grp1' "Remote" pos:[9,15] width:186 height:78 align:#left
	button 'btn1' "Set All Controllers as 0" pos:[15,38] width:161 height:20 align:#left
	button 'btn2' "Set Selected Controllers as 0" pos:[15,63] width:165 height:20 align:#left
	button 'btn3' "Get Captured Data File" pos:[14,200] width:169 height:43 align:#left tooltip:"It would take MUCH long time than you expected"
	groupBox 'grp2' "Remove Data" pos:[8,102] width:185 height:91 align:#left
	button 'btn5' "Viseme" pos:[17,120] width:69 height:29 align:#left
	button 'btn7' "Emotion" pos:[108,120] width:69 height:29 align:#left
	button 'btn8' "All" pos:[18,156] width:66 height:30 align:#left
	button 'btn9' "Selection" pos:[108,157] width:66 height:30 align:#left
    dropDownList 'ddl_Face' "Get face file" pos:[18,250] width:100 height:41 items:#("EVE", "Tachy", "Lilly", "Maid(Arisa)") align:#left across:2
    button 'btn_getFaceFile' "GetFile"pos:[130,268]


    groupBox 'grp11' "Viseme KeyMaker" pos:[209,15] width:186 height:78 align:#left
	button 'btn11' "A" pos:[215,38] width:20 height:20 align:#left
	button 'btn12' "E" pos:[240,38] width:20 height:20 align:#left
	button 'btn13' "I" pos:[265,38] width:20 height:20 align:#left
    button 'btn113' "O" pos:[290,38] width:20 height:20 align:#left
    button 'btn114' "U" pos:[315,38] width:20 height:20 align:#left
    button 'btn115' "Uh" pos:[340,38] width:20 height:20 align:#left
    button 'btn116' "_" pos:[365,38] width:20 height:20 align:#left
    label 'label11' "Tachy Teeth Controller is also Available" pos:[215,70]
    --button 'btn111' "A" pos:[215,38] width:161 height:20 align:#left
	--button 'btn112' "E" pos:[215,63] width:165 height:20 align:#left
	--button 'btn113' "I" pos:[214,200] width:169 height:43 align:#left


    groupBox 'grp12' "Data Convert" pos:[208,102] width:185 height:91 align:#left
	button 'btn15' "Get Data" pos:[217,120] width:69 height:29 align:#left
	button 'btn17' "Convert" pos:[308,120] width:69 height:29 align:#left
    button 'btn_executePy' "Key Clean" pos:[217,155] width:69 height:29 align:#left
	--button 'btn18' "All" pos:[218,156] width:66 height:30 align:#left
	--button 'btn19' "Selection" pos:[308,157] width:66 height:30 align:#left



    groupBox 'Grp_Snapshot' "SnapShot(WIP)" pos:[208,200] width:185 height:91 align:#left
    button 'btn_snap' "Snap" pos:[217,220] width:69 height:29 align:#left
    button 'btn_shot' "Shot" pos:[217,255] width:69 height:29 align:#left
    button 'btn_teethPos' "Teeth Controller" pos:[308,220] width:69 height:29 align:#left
    on btn_teethPos pressed do 
    (
        filein "Z:\\ART_Backup\\Script\\FacialMaker\\teethController.ms"
    )

    on btn_executePy pressed do 
    (
        python.ExecuteFile "Z:\ART_Backup\Script\FacialMaker\keyDeleteInter.py"
    )
    on btn15 pressed do 
    (
        case visage.ddl_face.selection of
        (
            1:
            (
                mergemaxfile "Z:\\ART_Backup\\Facial\\Character_RigidFacial\\EVE\\EVE_Face_notRigid.max" #select #autoRenameDups quiet:true
            )
            2:
            (
                mergemaxfile "Z:\\ART_Backup\\Facial\\Character_RigidFacial\\Tachy\\Tachy_Face_notRigid.max" #select #autoRenameDups quiet:true
            )
            3:
            (
                mergemaxfile "Z:\\ART_Backup\\Facial\\Character_RigidFacial\\Lilly\\Lilly_Face_notRigid.max" #select #autoRenameDups quiet:true
            )
            4:
            (
                mergemaxfile "Z:\\ART_Backup\\Facial\\Character_RigidFacial\\Maid\\Maid_Face_notRig.max" #select #autoRenameDups quiet:true
            )
        )
    )
    on btn17 pressed do 
    (
        fileIn "Z:\\ART_Backup\\Script\\FacialMaker\\MakeController.ms"
    )
    on btn114 pressed do -- U
    (
        undo on 
        (
            with animate on 
            (
                zeroCtrls()
                $mouthFunnel_CTRL.pos.controller.Path_Constraint.controller.percent = 100.0
                $mouthClose_CTRL.pos.controller.Path_Constraint.controller.percent = 50.0
            )
        )
    )

    on btn13 pressed do -- i 
    (
        undo on
        (
            with animate on 
            (
                zeroCtrls()
                $mouthSmileLeft_CTRL.pos.controller.Path_Constraint.controller.percent = 24.933
                $mouthSmileRight_CTRL.pos.controller.Path_Constraint.controller.percent = 24.933
                $jawForward_CTRL.pos.controller.Path_Constraint.controller.percent = 24.586
                $mouthUpperUpRight_CTRL.pos.controller.Path_Constraint.controller.percent = 50.249
                $mouthUpperUpLeft_CTRL.pos.controller.Path_Constraint.controller.percent = 50.249
                $mouthLowerDownRight_CTRL.pos.controller.Path_Constraint.controller.percent = 39.643
                $mouthLowerDownLeft_CTRL.pos.controller.Path_Constraint.controller.percent = 39.643


            )
        )
    )

    on btn113 pressed do -- O
    (
        undo on 
        (
            with animate on 
            (
                zeroCtrls()
                $mouthFunnel_CTRL.pos.controller.Path_Constraint.controller.percent = 100.0
                $mouthClose_CTRL.pos.controller.Path_Constraint.controller.percent = 19.0
            )
        )
    )

    on btn11 pressed do --A
    (
        undo on 
        (
            with animate on 
            (
                zeroCtrls()
                $jawOpen_CTRL.pos.controller.Path_Constraint.controller.percent = 100.0
            )
        )
    )

    on btn12 pressed do --E
    (
        undo on 
        (
            with animate on 
            (
                zeroCtrls()
                $jawOpen_CTRL.pos.controller.Path_Constraint.controller.percent = 50.0
                $mouthSmileLeft_CTRL.pos.controller.Path_Constraint.controller.percent = 81.262
                $mouthSmileRight_CTRL.pos.controller.Path_Constraint.controller.percent = 81.262
                $mouthFrownLeft_CTRL.pos.controller.Path_Constraint.controller.percent = 38.632
                $mouthFrownRight_CTRL.pos.controller.Path_Constraint.controller.percent = 38.632
            )
        )
    )

    on btn115 pressed do --uh
    (
        undo on
        (
            with animate on 
            (
                zeroCtrls()
                $mouthShrugUpper_CTRL.pos.controller.Path_Constraint.controller.percent = 100.0 
            )
        )
    )

    on btn116 pressed do -- _
    (        
        undo on 
        (
            with animate on 
            (
                zeroCtrls()
            )
        )
    )




    on btn1 pressed do -- Set All Controllers as 0
    (
        for i in $* do 
        (
            Try 
            (
                i.pos.controller.Path_Constraint.controller.percent = 0.0 
            )
            Catch()
        )
    )

    on btn2 pressed do -- Set Selected Controllers as 0
    (
        for i in selection do 
        (
            Try 
            (
                i.pos.controller.Path_Constraint.controller.percent = 0.0 
            )
            Catch()
        )
    )

    on btn5 pressed do -- Remove Viseme keys
    (
        deselect $*
        selectmore $jaw*
        selectmore $mouth*
        for i in selection do 
        (
            deleteKeys i.controller
        )
    )

    on btn7 pressed do --Remove Emotion keys 
    (
        deselect $*
        selectmore $eye*
        selectmore $cheeck*
        selectmore $brow*
        selectmore $cheek*
        selectmore $nose*
        
        for i in selection do 
        (
            deleteKeys i.controller
        )
    )

    on btn8 pressed do -- Remove All keys 
    (
        for i in $*_CTRL do 
        (
            deleteKeys i.controller
        )
    )

    on btn9 pressed do -- Remove Selection keys 
    (
        for i in selection do 
        (
            deleteKeys i.controller
        )
    )
    on btn_getFaceFile pressed do
    (
        case visage.ddl_face.selection of
        (
            1:
            (
                loadMaxFile "Z:\\ART_Backup\\Facial\\Character_RigidFacial\\EVE\\EVE_Face_Rigid.max" quiet:true
            )
            2:
            (
                loadMaxFile "Z:\\ART_Backup\\Facial\\Character_RigidFacial\\Tachy\\Tachy_Face_Rig.max" quiet:true
            )
            3:
            (
                loadMaxFile "Z:\\ART_Backup\\Facial\\Character_RigidFacial\\Lilly\\Lilly_Face_Rig.max" quiet:true
            )
            4:
            (
                loadMaxFile "Z:\\ART_Backup\\Facial\\Character_RigidFacial\\Maid\\Maid_Face_Rig.max" quiet:true
            )
        )
    )


    on btn3 pressed do
    (
        filein "Z:\\ART_Backup\\Script\\FacialMaker\\Creator_de_Visage.ms"
    )
)
CreateDialog visage