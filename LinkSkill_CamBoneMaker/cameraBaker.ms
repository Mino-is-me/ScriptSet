global camName = "camera"
global camBoneName = "camera_Bone"

undo on 
(  
    cam = getNodebyName camName 

    camBone = dummy() 
    camBone.parent = $Root 
    camBone.name = camBoneName 
    
    set Animate On 
    for i=AnimationRange.start to AnimationRange.end do 
    (
        sliderTime = i     
        camBone.transform = cam.transform 
    )
    sliderTime = AnimationRange.start 
    set Animate Off 
)