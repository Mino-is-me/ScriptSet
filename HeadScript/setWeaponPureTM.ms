set Animate on 

for obj in selection do 
(
    originName = substituteString obj.name "_expose" ""
    originNode = getNodeByName originName
    originNode.pos.controller = Position_XYZ()
    originNode.rotation.controller = Euler_XYZ()
    
)
for obj in selection do 
(

    for i=AnimationRange.start to AnimationRange.end do 
    (
        sliderTime = i 
        exp_obj.transform = obj.transform 
    )
)

set Animate off 