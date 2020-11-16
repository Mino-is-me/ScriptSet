RFoot =  bonesys.createBone [0,0,1] [0,0,0] [1,0,0]
RFoot.name = "Ab R Foot"
for i=1 to (getPropNames RFoot).count do
(
    setProperty RFoot (getPropNames RFoot)[i] #(2.0, 2.0, 0.0, 10.1558, true, 3.0, 10.0, 10.0, true, 5.0, 10.0, 10.0, false, 2.0, 10.0, 10.0, false)[i]
)
RFoot.parent = $'Bip001 R Foot'
RFoot.transform = (matrix3 [1,0,0] [0,1,0] [0,0,1] [4.76837e-07,4.76837e-07,0]) * RFoot.parent.transform 
RFoot.pos.controller = position_script()
RFoot.pos.controller.addConstant "Toe0" $'Bip001 R Toe0'
RFoot.pos.controller.script = "Toe0_RT = ( ( (Toe0.transform * (inverse Toe0.parent.transform) ).rotation ) as eulerAngles)
[ degtorad ( Toe0_RT.z - 90 )*2 , degtorad -( Toe0_RT.z - 90 )*2 , degtorad ( Toe0_RT.x)*3 ]"

RFoot.rotation.controller = rotation_script()


RToe =  bonesys.createBone [0,0,1] [0,0,0] [1,0,0]
RToe.name = "Ab R Toe0"
for i=1 to (getPropNames RToe).count do
(
    setProperty RToe (getPropNames RToe)[i] #(2.0, 2.0, 0.0, 3.79638, true, 3.0, 10.0, 10.0, true, 5.0, 10.0, 10.0, false, 2.0, 10.0, 10.0, false)[i]
)
RToe.parent = $'Bip001 R Foot'
RToe.transform = (matrix3 [-1,-2.65439e-06,0] [-2.65439e-06,1,0] [0,0,-1] [14.901,-2.64069,14.879]) * RToe.parent.transform 
RToe.pos.controller = position_script()
RToe.pos.controller.addConstant "Toe0" $'Bip001 R Toe0'
RToe.pos.controller.script = "Toe0_RT = ( ( (Toe0.transform * (inverse Toe0.parent.transform) ).rotation ) as eulerAngles)
Toe0_Pos = ( (Toe0.transform * (inverse Toe0.parent.transform) ).position )
[ ( Toe0_Pos.x + (( degtorad (Toe0_RT.z-90)*2 )) ),( (Toe0_Pos.y-3.78) + (( degtorad (Toe0_RT.z-90)*1 )) ), Toe0_Pos.z ]"

RToe.rotation.controller = rotation_script()
RToe.rotation.controller.addConstant "Toe0" $'Bip001 R Toe0'
RToe.rotation.controller.script = "Toe0_RT = ( ( (Toe0.transform * (inverse Toe0.parent.transform) ).rotation ) as eulerAngles)
( EulerAngles (Toe0_RT.y-180) (-Toe0_RT.x) (Toe0_RT.z+90) )"

