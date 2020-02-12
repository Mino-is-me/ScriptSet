set Animate on 
for obj in selection do 
(
    exp_obj = Dummy() 
    exp_obj.name = obj.name + "_expose"

    for i=AnimationRange.start to AnimationRange.end do 
    (
        sliderTime = i 
        exp_obj.transform = obj.transform 
    )
)

set Animate off 