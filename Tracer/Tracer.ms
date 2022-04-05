    -- Tracer Script by Mino 
if selection.count != 0 do (
    with animate on (
        for each in selection do (
            tracer = dummy()
            tracer.name = each.name 
            tracer.parent = each.parent 
            for i in animationRange.start to animationRange.end do (
                slidertime = i 
                tracer.transform = each.transform   
            )
            sliderTime = animationRange.start
        )
    )

    $Bip001.controller.figureMode = true 
    $Bip001.controller.prop1exists = false
    $Bip001.controller.figureMode = false 

    select $'Bip001 Prop1'
)

