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


Try
(
    DestroyDialog rltKeyReducer
)
Catch()

rollout rltKeyReducer "Selected Key Reducer"
(
    Spinner sprStartFrame "Start Frame : " across:2 type:#integer range:[-50000,50000,0]
    Spinner sprEndFrame "End Frame : " type:#integer range:[-50000,50000,0]
    Spinner sprFrames "Key Reduction Interval" type:#integer
    button btnReduceKeys "Reduce Keys"


    on btnReduceKeys pressed do 
    (
        undo on
        ( 
            if sprStartFrame.value == sprEndFrame.value then 
            (
                local fStartFrame = AnimationRange.start 
                local fEndFrame = AnimationRange.end 
            )
            else 
            (
                local fStartFrame = sprStartFrame.value 
                local fEndFrame = sprEndFrame.value 
            )

            local iInterval = sprFrames.value + 1
            getFramesforDelete fStartFrame fEndFrame iInterval
        )
    )
)--createDialog rltKeyReducer 400 80


--maxSCript Remainder = mod {Val1} {Val2}

