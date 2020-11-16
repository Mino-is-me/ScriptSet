for i in selection do 
(
    copied = Copy i
    T1 = copied.transform
    copied.pos.controller = position_xyz()
    copied.transform = T1 
    copied.scale = [-1,1,1]
    copied.pos.x = -copied.pos.x
    resetScale copied

    copied.scale = [-1,-1,-1]

    resetScale copied
)