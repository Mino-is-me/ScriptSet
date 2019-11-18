--global ar_rollouts1to10 = #('R1','R2','R3','R4','R5','R6','R7','R8','R9','R10')

fn addRolloutoFloater strRolloutName iCnt =
(
    case cnt of 
    (
        default:
        (
            
        )
        1:
        ( 
            addRollout 'manage' mainFloater 
            addRollout 'R1' mainFloater
            'R1'.title = strRolloutName
        )
        2:
        (
            
            addRollout 'R2' mainFloater
            'R2'.title = strRolloutName
        )
        3:
        (   
            addRollout 'R3' mainFloater
            'R3'.title = strRolloutName
        )
        4:
        (
            addRollout 'R4' mainFloater
            'R4'.title = strRolloutName
        )
        5:
        (
            addRollout 'R5' mainFloater
            'R5'.title = strRolloutName
        )
        6:
        (
            addRollout 'R6' mainFloater
            'R6'.title = strRolloutName
        )
        7:
        (
            addRollout 'R7' mainFloater
            'R7'.title = strRolloutName
        )
        8:
        (
            addRollout 'R8' mainFloater
            'R8'.title = strRolloutName
        )
        9:
        (
            addRollout 'R9' mainFloater
            'R9'.title = strRolloutName
        )
        10:
        (
            addRollout 'R10' mainFloater
            'R10'.title = strRolloutName
        )
    )
)

fn applyScript posScript rotScript sclScript boneToApply =
(
    isPosScript = iskindof boneToApply.pos.controller position_Script
    isRotScript = iskindof boneToApply.rotation.controller rotation_Script
    isScaleScript = iskindof boneToApply.scale.controller scale_script
    if isPosScript == true and posScript != "" do 
    (
        boneToApply.pos.controller.script = posScript
    )
    if isRotScript == true and rotScript != "" do 
    (
        boneToApply.rotation.controller.script = rotScript
    )
    if isScaleScript == true and sclScript != "" do 
    (
        boneToApply.scale.controller.script = sclScript
    )
)

Rollout 'manage' "Bulk Manage"
(
    button btn_apply "Apply All"

    on btn_apply pressed do 
    (
        try 
        (
            cnt = multiapply.mlb_appliedFiles.items.count
        )
        catch
        (
            cnt = 0 
        )
        if cnt == 0 then 
        (
            try 
            (
                R1.apply.pressed() 
                R2.apply.pressed()
                R3.apply.pressed()
                R4.apply.pressed()
                R5.apply.pressed()
                R6.apply.pressed()
                R7.apply.pressed()
                R8.apply.pressed()
                R9.apply.pressed()
                R10.apply.pressed()
            )
            catch
            ()
            messageBox "Apply Task Done" title:"Task Alert"
        )
        else 
        (
            folder = getFilenamePath multiapply.mlb_appliedFiles.items[1]
            makeDir (Folder + "ControllerApplied")
			newfolder = (Folder + "ControllerApplied" + "\\")
            for i in multiapply.mlb_appliedFiles.items do 
            (
                loadMaxFile i quiet:true
                units.systemScale = 1
                try 
                (
                    R1.apply.pressed() 
                    R2.apply.pressed()
                    R3.apply.pressed()
                    R4.apply.pressed()
                    R5.apply.pressed()
                    R6.apply.pressed()
                    R7.apply.pressed()
                    R8.apply.pressed()
                    R9.apply.pressed()
                    R10.apply.pressed()
                )
                catch
                ()
                saveMaxFile (newfolder + MaxFileName)
            )
            messageBox "Apply Task Done" title:"Task Alert"
        )

    )
)

Rollout 'R1' ""
(
    editText posctrl "Pos Script : " across:2
    button posctrlapply "+" 
    editText rotctrl "Rot Script : " across:2
    button rotctrlapply "+"
    editText sclctrl "Scale Script : " across:2
    button sclctrlapply "+" 
    button apply "Apply"


    on posctrlapply pressed do 
    (
        posctrl.text = getClipboardText() 
    )
    on rotctrlapply pressed do 
    (
        rotctrl.text = getclipboardText()
    )
    on sclctrlapply pressed do 
    (
        sclctrl.text = getclipboardText()
    )
    on apply pressed do 
    (
        local boneObj = getNodeByName 'R1'.title 
        applyScript posctrl.text rotctrl.text sclctrl.text boneObj
    )

)
Rollout 'R2' ""
(
    editText posctrl "Pos Script : " across:2
    button posctrlapply "+" 
    editText rotctrl "Rot Script : " across:2
    button rotctrlapply "+"
    editText sclctrl "Scale Script : " across:2
    button sclctrlapply "+" 
    button apply "Apply"


    on posctrlapply pressed do 
    (
        posctrl.text = getClipboardText() 
    )
    on rotctrlapply pressed do 
    (
        rotctrl.text = getclipboardText()
    )
    on sclctrlapply pressed do 
    (
        sclctrl.text = getclipboardText()
    )
    on apply pressed do 
    (
        local boneObj = getNodeByName 'R2'.title 
        applyScript posctrl.text rotctrl.text sclctrl.text boneObj
    )
)
Rollout 'R3' ""
(
    editText posctrl "Pos Script : " across:2
    button posctrlapply "+" 
    editText rotctrl "Rot Script : " across:2
    button rotctrlapply "+"
    editText sclctrl "Scale Script : " across:2
    button sclctrlapply "+" 
    button apply "Apply"


    on posctrlapply pressed do 
    (
        posctrl.text = getClipboardText() 
    )
    on rotctrlapply pressed do 
    (
        rotctrl.text = getclipboardText()
    )
    on sclctrlapply pressed do 
    (
        sclctrl.text = getclipboardText()
    )
    on apply pressed do 
    (
        local boneObj = getNodeByName 'R3'.title 
        applyScript posctrl.text rotctrl.text sclctrl.text boneObj
    )
)
Rollout 'R4' ""
(
    editText posctrl "Pos Script : " across:2
    button posctrlapply "+" 
    editText rotctrl "Rot Script : " across:2
    button rotctrlapply "+"
    editText sclctrl "Scale Script : " across:2
    button sclctrlapply "+" 
    button apply "Apply"


    on posctrlapply pressed do 
    (
        posctrl.text = getClipboardText() 
    )
    on rotctrlapply pressed do 
    (
        rotctrl.text = getclipboardText()
    )
    on sclctrlapply pressed do 
    (
        sclctrl.text = getclipboardText()
    )
    on apply pressed do 
    (
        local boneObj = getNodeByName 'R4'.title 
        applyScript posctrl.text rotctrl.text sclctrl.text boneObj
    )
)
Rollout 'R5' ""
(
    editText posctrl "Pos Script : " across:2
    button posctrlapply "+" 
    editText rotctrl "Rot Script : " across:2
    button rotctrlapply "+"
    editText sclctrl "Scale Script : " across:2
    button sclctrlapply "+" 
    button apply "Apply"


    on posctrlapply pressed do 
    (
        posctrl.text = getClipboardText() 
    )
    on rotctrlapply pressed do 
    (
        rotctrl.text = getclipboardText()
    )
    on sclctrlapply pressed do 
    (
        sclctrl.text = getclipboardText()
    )
    on apply pressed do 
    (
        local boneObj = getNodeByName 'R5'.title 
        applyScript posctrl.text rotctrl.text sclctrl.text boneObj
    )
)
Rollout 'R6' ""
(
    editText posctrl "Pos Script : " across:2
    button posctrlapply "+" 
    editText rotctrl "Rot Script : " across:2
    button rotctrlapply "+"
    editText sclctrl "Scale Script : " across:2
    button sclctrlapply "+" 
    button apply "Apply"


    on posctrlapply pressed do 
    (
        posctrl.text = getClipboardText() 
    )
    on rotctrlapply pressed do 
    (
        rotctrl.text = getclipboardText()
    )
    on sclctrlapply pressed do 
    (
        sclctrl.text = getclipboardText()
    )
    on apply pressed do 
    (
        local boneObj = getNodeByName 'R6'.title 
        applyScript posctrl.text rotctrl.text sclctrl.text boneObj
    )
)
Rollout 'R7' ""
(
    editText posctrl "Pos Script : " across:2
    button posctrlapply "+" 
    editText rotctrl "Rot Script : " across:2
    button rotctrlapply "+"
    editText sclctrl "Scale Script : " across:2
    button sclctrlapply "+" 
    button apply "Apply"


    on posctrlapply pressed do 
    (
        posctrl.text = getClipboardText() 
    )
    on rotctrlapply pressed do 
    (
        rotctrl.text = getclipboardText()
    )
    on sclctrlapply pressed do 
    (
        sclctrl.text = getclipboardText()
    )
    on apply pressed do 
    (
        local boneObj = getNodeByName 'R7'.title 
        applyScript posctrl.text rotctrl.text sclctrl.text boneObj
    )
)
Rollout 'R8' ""
(
    editText posctrl "Pos Script : " across:2
    button posctrlapply "+" 
    editText rotctrl "Rot Script : " across:2
    button rotctrlapply "+"
    editText sclctrl "Scale Script : " across:2
    button sclctrlapply "+" 
    button apply "Apply"


    on posctrlapply pressed do 
    (
        posctrl.text = getClipboardText() 
    )
    on rotctrlapply pressed do 
    (
        rotctrl.text = getclipboardText()
    )
    on sclctrlapply pressed do 
    (
        sclctrl.text = getclipboardText()
    )
    on apply pressed do 
    (
        local boneObj = getNodeByName 'R8'.title 
        applyScript posctrl.text rotctrl.text sclctrl.text boneObj
    )
)
Rollout 'R9' ""
(
    editText posctrl "Pos Script : " across:2
    button posctrlapply "+" 
    editText rotctrl "Rot Script : " across:2
    button rotctrlapply "+"
    editText sclctrl "Scale Script : " across:2
    button sclctrlapply "+" 
    button apply "Apply"


    on posctrlapply pressed do 
    (
        posctrl.text = getClipboardText() 
    )
    on rotctrlapply pressed do 
    (
        rotctrl.text = getclipboardText()
    )
    on sclctrlapply pressed do 
    (
        sclctrl.text = getclipboardText()
    )
    on apply pressed do 
    (
        local boneObj = getNodeByName 'R9'.title 
        applyScript posctrl.text rotctrl.text sclctrl.text boneObj
    )
)
Rollout 'R10' ""
(
    editText posctrl "Pos Script : " across:2
    button posctrlapply "+" 
    editText rotctrl "Rot Script : " across:2
    button rotctrlapply "+"
    editText sclctrl "Scale Script : " across:2
    button sclctrlapply "+" 
    button apply "Apply"


    on posctrlapply pressed do 
    (
        posctrl.text = getClipboardText() 
    )
    on rotctrlapply pressed do 
    (
        rotctrl.text = getclipboardText()
    )
    on sclctrlapply pressed do 
    (
        sclctrl.text = getclipboardText()
    )
    on apply pressed do 
    (
        local boneObj = getNodeByName 'R10'.title 
        applyScript posctrl.text rotctrl.text sclctrl.text boneObj
    )
)

Rollout 'R11' ""
(

)
Rollout 'R12' ""
(
    
)
Rollout 'R13' ""
(
    
)
Rollout 'R14' ""
(
    
)
Rollout 'R15' ""
(
    
)
Rollout 'R16' ""
(
    
)
Rollout 'R17' ""
(
    
)
Rollout 'R18' ""
(
    
)
Rollout 'R19' ""
(
    
)
Rollout 'R20' ""
(
    
)

Rollout 'R21' ""
(

)
Rollout 'R22' ""
(
    
)
Rollout 'R23' ""
(
    
)
Rollout 'R24' ""
(
    
)
Rollout 'R25' ""
(
    
)
Rollout 'R26' ""
(
    
)
Rollout 'R27' ""
(
    
)
Rollout 'R28' ""
(
    
)
Rollout 'R29' ""
(
    
)
Rollout 'R30' ""
(
    
)
