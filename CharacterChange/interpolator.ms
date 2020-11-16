fn interpolator Node =
(
    localTransform = Node.transform * inverse Node.parent.transform 

    localRotation = localTransform.rotation as eulerAngles 

    print localRotation 
)