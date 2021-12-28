try(destroyDialog ruleMoveMaker) catch()


rollout ruleMoveMaker "Rule Move Maker"
(
    pickbutton ptn_objectPick "Pick Trace Object"
    button btn_excute "Trace"

    on ptn_objectPick picked obj do 
    (
        ptn_objectPick.text = obj.name  
    )

    on btn_excute pressed do 
    (
        Try(Delete $ComTracer) catch()
        ComTracer = Dummy()
        ComTracer.name = "ComTracer"
        ComTracer.BoxSize = ComTracer.BoxSize * 10 --for debugging 
        with animate on 
        (
            for i=animationRange.start to animationRange.end do 
            (
                SliderTime = i 
                ComTracer.transform = $Bip001.transform
            )
        )

        with animate on 
        (
            for i=animationRange.start to animationRange.end do 
            (
                SliderTime = i 
                $Root.transform = ptn_objectPick.object.transform 
            )
        )
        SliderTime = animationrange.start

        biped.createLayer $Bip001.controller 1 "TracedLayer01" 

        with animate on 
        (
            for i=animationRange.start to animationRange.end do 
            (
                SliderTime = i 
                $Bip001.transform = ComTracer.transform
            )
        )
        SliderTime = animationrange.start

    )
)
CreateDialog ruleMoveMaker