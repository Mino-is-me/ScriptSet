LFoot =  bonesys.createBone [0,0,1] [0,0,0] [1,0,0]
LFoot.name = "Ab L Foot"
for i=1 to (getPropNames LFoot).count do
(
    setProperty LFoot (getPropNames LFoot)[i] #(2.0, 2.0, 0.0, 10.1558, true, 3.0, 10.0, 10.0, true, 5.0, 10.0, 10.0, false, 2.0, 10.0, 10.0, false)[i]
)
LFoot.parent = $'Bip001 L Foot'
LFoot.transform = (matrix3 [1,0,0] [0,1,0] [0,0,1] [4.76837e-07,4.76837e-07,0]) * LFoot.parent.transform 
LFoot.pos.controller = position_script()
LFoot.pos.controller.addConstant "Toe0" $'Bip001 L Toe0'
LFoot.pos.controller.script = "Toe0_RT = ( ( (Toe0.transform * (inverse Toe0.parent.transform) ).rotation ) as eulerAngles)
[ degtorad ( Toe0_RT.z - 90 )*2 , degtorad -( Toe0_RT.z - 90 )*2 , degtorad ( Toe0_RT.x)*3 ]"

LFoot.rotation.controller = rotation_script()

LToe =  bonesys.createBone [0,0,1] [0,0,0] [1,0,0]
LToe.name = "Ab L Toe0"
for i=1 to (getPropNames LToe).count do
(
    setProperty LToe (getPropNames LToe)[i] #(2.0, 2.0, 0.0, 3.79638, true, 3.0, 10.0, 10.0, true, 5.0, 10.0, 10.0, false, 2.0, 10.0, 10.0, false)[i]
)
LToe.parent = $'Bip001 L Foot'
LToe.transform = (matrix3 [-1,-2.65439e-06,0] [-2.65439e-06,1,0] [0,0,-1] [14.901,-2.64069,14.879]) * LToe.parent.transform 
LToe.pos.controller = position_script()
LToe.pos.controller.addConstant "Toe0" $'Bip001 L Toe0'
LToe.pos.controller.script = "Toe0_RT = ( ( (Toe0.transform * (inverse Toe0.parent.transform) ).rotation ) as eulerAngles)
Toe0_Pos = ( (Toe0.transform * (inverse Toe0.parent.transform) ).position )
[ ( Toe0_Pos.x + (( degtorad (Toe0_RT.z-90)*2 )) ),( (Toe0_Pos.y-3.78) + (( degtorad (Toe0_RT.z-90)*1 )) ), Toe0_Pos.z ]"

LToe.rotation.controller = rotation_script()
LToe.rotation.controller.addConstant "Toe0" $'Bip001 L Toe0'
LToe.rotation.controller.script = "Toe0_RT = ( ( (Toe0.transform * (inverse Toe0.parent.transform) ).rotation ) as eulerAngles)
( EulerAngles (Toe0_RT.y-180) (-Toe0_RT.x) (Toe0_RT.z+90) )"

