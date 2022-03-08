node_controller = showMaker.pbtn_controller.object 
if not (node_controller == undefined) do 
(
    ar_COMPos = #()
    ar_RootPos= #()
    ar_originPos = #() 

    distanceFromRoot = [0,0,0]
    cnt = 0 



    dm_reflectCOM = Dummy() 
    dm_RotationCOM = Dummy() 
    --dm_reflectProp = Dummy()

    AnimStart = AnimationRange.start as integer / 160 
    AnimEnd = AnimationRange.end as integer / 160


    FrameCount = AnimEnd-AnimStart + 1

    sliderTime = AnimationRange.Start 

    -------------------Position Controller-----------------------
    dm_reflectCOM.position.controller = Position_Constraint()
    if isValidNode $Bip002 and not isValidNode $Bip001 then 
    (
        for i in $Bip002* do
        (
            i.name = substituteString i.name "Bip002" "Bip001"
        )
    )
    dm_reflectCOM.position.controller.appendTarget node_controller 50.0 
    dm_reflectCOM.position.controller.relative = off
        
    if isValidNode $Root001 and not isValidNode $Root do
    (
        $Root001.name = "Root"
    )

    for i=AnimationRange.start to AnimationRange.end do 
    (
        sliderTime = i
        cnt = cnt + 1


        newVec = dm_reflectCOM.pos 

        comVec = biped.getTransform $Bip001 #Pos
        

        append ar_COMPos newVec -- reflected COM Pos 

        append ar_originPos comVec -- COM Pos 

    ) 

    sliderTime = AnimationRange.start

    $Bip001.parent = World 

    with animate on 
    (
        cnt1= 0
        for i=AnimationRange.start to AnimationRange.end do 
        (
            SliderTime = i 
            cnt1 = cnt1+1
            frCNT = ( (i as integer) / 160) + 1 
            if ar_COMPos[cnt1].z < 0 do
            (
                ar_COMPOS[cnt1].z = 0.0
            )
            $Root.pos = ar_COMPos[cnt1]
        )
    )

    --
    with animate on 
    (
        sliderTIme = AnimationRange.end 
    )
    
    
    sliderTIme = AnimationRange.start 

    $Bip001.parent=$Root

    with animate on 
    (
        biped.createLayer $Bip001.controller 1 "RMotionLayer01"

        sliderTime = AnimationRange.End
        sliderTime = AnimationRange.Start
        --Biped Layer Bug 안전처리 
        cnt2 = 0
        for i=AnimationRange.start to AnimationRange.end do 
        (
            sliderTime = i
            cnt2=cnt2+1
            frCNT = ( (i as integer) / 160) + 1 
            
            biped.setTransform $Bip001 #pos ar_originPos[cnt2] true 
            --biped.setTransform $Bip001 #Rotation ar_COMRot[cnt2] true 

        )
    )

    SliderTime = AnimationRange.start 

    Biped.collapseAtLayer $Bip001.controller 0



    $Root.pos = [0,showMaker.spn_distance.value,0]

    thecopypastedir = getdir #autoback -- CHANGE THIS TO ANY FOLDER YOU WANT
    thecopypastefile = "\pastefile.max" --this is the filename to save as...
    thecopypastestring = thecopypastedir + thecopypastefile --this is the complete string

    if $Root != undefined do 
    (
        saveNodes $Root thecopypastestring --this saves ("copies") the objects as a file
    )
)