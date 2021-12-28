undo on
(
    animate on 
    (
        for i=animationRange.start to animationRange.end do 
        (
            sliderTime =  i 
            for i in $* do 
            (
                i.transform = i.transform 
            )
        )
    )
)
sliderTime = animationRange.start 