the_IKBaker = attributes IKBaker 
(
    parameters main rollout:rlt_Baker
    (
        temp type: #string
    )
    rollout rlt_Baker "IK FK Baker"
    (
        
        checkBox chk_ActiveRange "Active Range" checked:true
        checkBox chk_SetRange "Set Range"

        spinner spi_StartFrame "Start : " type:#integer Range:[0,9999,0]
        spinner spi_EndFrame "End : " type:#integer Range:[0,9999,100]

        button btn_IKFK "FK -> IK"
        button btn_FKIK "IK -> FK"

        on rlt_Baker open do 
        (
            spi_StartFrame.value = AnimationRange.start as integer / 160
            spi_EndFrame.value = AnimationRange.end as integer / 160  

        )

        on chk_ActiveRange changed state do 
        (
            if state == true do 
            (
                chk_SetRange.checked = false 

                spi_StartFrame.enabled = false 
                spi_EndFrame.enabled = false 

            )
            
        )

        on chk_SetRange changed state do 
        (
            if state == true do 
            (
                chk_ActiveRange.checked = false 

                spi_StartFrame.enabled = true 
                spi_EndFrame.enabled = true
            )
        )

        on btn_IKFK pressed do
        (
            undo on 
            (
                with Animate on 
                (
                    if chk_SetRange.state == true do 
                    (
                        animStart = spi_StartFrame.value 
                        animEnd = spi_EndFrame.value 

                    )

                    if chk_ActiveRange.state == true do 
                    (
                        animStart = AnimationRange.start 
                        animEnd = AnimationRange.end
                    )

                    for i=animStart to animEnd do 
                    (
                        sliderTime = i 
                        for j=1 to $.IKBones.count do 
                        (
                            (getNodeByName $.FKBones[j]).transform = (getNodeByName $.IKBones[j]).transform
                        )
                    )
                )
            )
        )
        
        
        on btn_FKIK pressed do
        (
            undo on 
            (
                with Animate on 
                (
                    if chk_SetRange.state == true do 
                    (
                        animStart = spi_StartFrame.value 
                        animEnd = spi_EndFrame.value 

                    )

                    if chk_ActiveRange.state == true do  
                    (
                        animStart = AnimationRange.start 
                        animEnd = AnimationRange.end 
                    )

                    for i=animStart to animEnd do 
                    (
                        sliderTime = i 
                        for j=1 to $.IKTargets.count do 
                        (
                            (getNodeByName $.IKTargets[j]).transform = (getNodeByName $.FKTargets[j]).transform
                        )
                    )
                )
            )
        )
    )
)
--CreateDialog rlt_Baker 
custAttributes.add $ the_IKBaker
