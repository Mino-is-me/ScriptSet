

Try
(
    destroyDialog 'rlt_RootMotionMaker'
)
Catch()
rollout 'rlt_RootMotionMaker' "Simple Root Motion Extractor"
(
    checkBox 'chk_x' "X" across:3 checked:true
    checkBox 'chk_y' "Y" checked:true
    checkBox 'chk_z' "Z" checked:true
    Spinner 'clampStart' "Start" type:#integer across:2 range:[0,9999,0]
    Spinner 'clmapend' "End" type:#integer range:[0,9999,0]
    button 'extract' "Extract"

    on extract pressed do 
    (

        customRange = (interval 0 0)
        customRange.start = rlt_RootMotionMaker.clampStart.value 
        customRange.end = rlt_RootMotionMaker.clmapend.value 
        undo on 
        (
            deselect $*

            
            nCOM = $'Bip001'
            Root = $'Root'

            biped.createLayer $Bip001.controller 1 "RMotionLayer01"
            dm_expose = Dummy()
            dm_expose.pos.controller = Position_Constraint()
           -- dm_expose.rotation.controller = Orientation_Constraint()
            dm_expose.pos.controller.relative = on 
           -- dm_expose.rotation.controller.relative = on
           -- dm_expose.rotation.controller.appendTarget nCOM 50.0 
            dm_expose.pos.controller.appendTarget nCOM 50.0

            COMexpose = Dummy()

            nCOM.parent = undefiend 
            
            set animate on 
            (
                for i=AnimationRange.start to AnimationRange.end do 
                (
                    sliderTime = i 
                    COMexpose.transform = nCOM.transform 

                    
                    if i >= customRange.start and i <= customRange.end then -- inRange  
                    (
                        Root.transform = dm_expose.transform 
                    )
                    else --Outrange
                    (
                        Root.transform = dm_expose.transform 
                        if Root.pos.z <= 0.0 do 
                        (
                            Root.pos.z = 0
                        )
                    )

                )
                if not rlt_RootMotionMaker.chk_x.checked do DeleteKeys Root.position.controller.X_Position.controller #allKeys
                if not rlt_RootMotionMaker.chk_y.checked do DeleteKeys Root.position.controller.Y_Position.controller #allKeys
                if not rlt_RootMotionMaker.chk_z.checked do DeleteKeys Root.position.controller.Z_Position.controller #allKeys

                nCOM.parent = Root 
                for i=AnimationRange.start to AnimationRange.end do 
                (                
                    sliderTime = i 
                    nCOM.transform = COMexpose.transform 
                    --Root.transform = dm_expose.transform 
                )

            )
        )
    )
)
CreateDialog 'rlt_RootMotionMaker' 200 100