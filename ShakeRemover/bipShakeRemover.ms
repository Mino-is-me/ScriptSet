/* WaterMark
    "Script By Minomi from Shiftup - Project_EVE"
*/

fn getSelectedNodes =
(
    local arNodes = for i in selection where classof i == Biped_Object collect i 
    return arNodes 
)

fn isRootBipDeleteKey bipNode =
(
    if bipNode.controller.rootName == bipNode.name do 
    (
        ctrlRoot = bipNode.transform.controller
        vertCtrl = ctrlRoot.vertical.controller
        horzCtrl = ctrlRoot.horizontal.controller 
        turnCtrl = ctrlRoot.turning.controller
    )
)

fn getFramesforDelete fStartFrame fEndFrame iInterval =
(
    /*debug code
    fStartFrame = 0 
    fEndFrame = 100 
    iInterval =3
    */
    arAllFrames =  ( for i = fStartFrame to fEndFrame collect i )
        
    local arSpecific = #()
    local arIntervalFrames = #()
    local temp = 0
    local nodes = getSelectedNodes()

    for i=fStartFrame to fEndFrame do 
    (
        temp += 1
        cnt = fStartFrame + ( iInterval * temp )
        if cnt < fEndFrame do 
        (
            append arSpecific cnt 
        )
    )
    
    for i in arSpecific do 
    (
        indexkey = findItem arAllFrames i 
        --print indexKey 
        arAllFrames = deleteItem arAllFrames indexkey
    )

    indexKey = findItem arAllFrames fStartFrame
    arAllFrames = deleteItem arAllFrames indexkey

    indexKey = findItem arAllFrames fEndFrame
    arAllFrames = deleteItem arAllFrames indexKey
    
    -- for i in arAllFrames do print i -> Debug Line 
    for i in arAllFrames do 
    (
        for j in nodes do 
        (
            if (j.controller.rootName == j.name) then  
            (
                local ctrlRoot = j.transform.controller
                local vertCtrl = ctrlRoot.vertical.controller
                local horzCtrl = ctrlRoot.horizontal.controller 
                local turnCtrl = ctrlRoot.turning.controller

                local iIndexV = getKeyIndex vertCtrl i 
                local iIndexH = getKeyIndex horzCtrl i 
                local iIndexT = getKeyIndex turnCtrl i 

                if iIndexV > 0 do 
                (
                    deleteKey vertCtrl iIndexV
                )
                
                if iIndexH > 0 do 
                (
                    deleteKey horzCtrl iIndexH
                )
                if iIndexT > 0 do
                (
                    deleteKey turnCtrl iIndexT
                )
            )
            else
            ( 
                local iIndex = getKeyIndex j.controller i 

                if iIndex > 0 do 
                (
                    deleteKey j.controller iIndex 
                )
            )
        )
    )
)

fn getLegAngle CalfBone= 
(
    RThighRot = CalfBone.parent.transform.rotation as eulerAngles 
    RCalfRot = CalfBone.transform.rotation as eulerAngles 
    Rthigh = [RThighRot.x, RThighRot.y, RThighRot.z]
    RCalf = [RCalfRot.x,RCalfRot.y,RCalfRot.z]
    RLegAngle = Dot (Normalize RThigh) (Normalize RCalf)

    return RLegAngle 
)

fn setSlidingKeyBiped =
(
	
	
    isIdleFile = FindString MaxFileName "Idle"
    sliderTime = 0f 
    RCalf1 = getLegAngle $Bip001_R_Calf 
    LCalf1 = getLegAngle $Bip001_L_Calf 
    TM1 = $Bip001_R_Foot.transform 
    TM2 = $Bip001_L_Foot.transform 

    if RCalf1 >= 0.99 do 
	(
        TM1.pos.y = TM1.pos.y - 3 
	)
    if LCalf1 > 0.99 do 
	(
        TM2.pos.y = TM2.pos.y + 3 
	)

    Set Animate on 
    for i=AnimationRange.start to AnimationRange.end do 
    (
        SliderTime = i 

        if isIdleFile != undefined do 
		(
            $Bip001_R_Foot.transform = TM1
        )
        Biped.setSlidingKey $Bip001_R_Foot

        if isIdleFile != undefined do 
		(
            $Bip001_L_Foot.transform = TM2 
		)
        Biped.setSlidingKey $Bip001_L_Foot
    )
    Set Animate Off 

)
files  = getFiles (Dir + "\\" + "*.max")
for file in Files do 
(
    
    loadMaxFile file quiet:true
    set Animate on 
    setSlidingKeyBiped()
    set Animate Off 
	
	select $Bip001_Pelvis
    getFramesforDelete AnimationRange.start AnimationRange.end 5
    exportFileName = "\\\\10.220.70.12\\eve\\ART_Backup\\SequenceExport\\" + (substituteString MaxFileName ".max" ".fbx")
	saveFileName = ("\\\\10.220.70.12\\eve\\ART_Backup\\SequenceExport\\" + MaxFileName)
    exportFile exportFileName #noPrompt using:FBXEXPORTER

    SaveMaxFile saveFileName quiet:true useNewFile:false
)