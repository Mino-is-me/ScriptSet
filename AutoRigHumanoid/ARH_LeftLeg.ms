LHip = Point()
LHip.name = "Dm L Hip"
LHip.parent = $'Bip001 Pelvis'
LHip.transform = $'Bip001 L Thigh'.transform 

LHip.rotation.controller = Orientation_Constraint() 
LHip.rotation.controller.appendTarget $'DM Hip Point' 50.0
LHip.rotation.controller.appendTarget $'Ab L Thigh Twist' 50.0



LVente = bonesys.createBone [0,0,1] [0,0,0] [1,0,0]
LVente.name = "Ab L Vente"
for i=1 to (getPropNames LVente).count do
(
    setProperty LVente (getPropNames LVente)[i] #(2.0, 2.0, 10.0, 9.44028, true, 5.0, 10.0, 10.0, false, 10.0, 10.0, 10.0, false, 4.0, 10.0, 10.0, false)[i]
)
LVente.parent = $'Dm L Hip'
LVente.pos.Controller = position_script()
LVente.pos.controller.addConstant "OBJ_A" $'Bip001 L Thigh'
LVente.pos.controller.script = "A_Rot = ( ( (OBJ_A.transform * (inverse OBJ_A.parent.transform) ).rotation ) as eulerAngles)
if A_Rot.z > 0 then AY = degtorad ( A_Rot.z - 180 )
else AY = degtorad ( 180 + A_Rot.z )
if AY < 0 then TY = -AY*5
else TY = 0
if A_Rot.y < 0 then AZ = degtorad ( A_Rot.y * 5 )
else AZ = 0
[ 0, TY, AZ]"

LVente.rotation.controller = rotation_script()
LVente.rotation.controller.script ="( EulerAngles (0) (0) (90) )" 

LHipB = bonesys.createBone [0,0,1] [0,0,0] [1,0,0]
LHipB.name = "Ab L Hip"
for i=1 to (getPropNames LHipB).count do
(
    setProperty LHipB (getPropNames LHipB)[i] #(5.0, 5.0, 80.0, 15.0, false, 5.0, 11.2, 10.0, true, 10.0, 10.0, 14.0, false, 4.0, 10.0, 10.0, false)[i]
)
LHipB.parent = $'Dm L Hip'
LHipB.pos.controller = position_script()
LHipB.pos.controller.addConstant "OBJ_A" $'Bip001 L Thigh'
LHipB.pos.controller.script = "A_Rot = ( ( (OBJ_A.transform * (inverse OBJ_A.parent.transform) ).rotation ) as eulerAngles)
if A_Rot.z > 0 then AX = degtorad ( A_Rot.z - 180 )
else AX = degtorad ( 180 + A_Rot.Z )
if A_Rot.z > 0 then AY = degtorad ( A_Rot.z - 180 )
else AY = degtorad ( 180 + A_Rot.z )
if AX > 0 then TX = -AX
else TX = AX
if AY > 0 then TY = -AY
else TY = -AY*2
[ TX, TY, 0 ]"
LHipB.rotation.controller = rotation_script()
LHipB.rotation.controller.script = "( EulerAngles (0) (0) (-90) )"


LThigh = bonesys.createBone [0,0,1] [0,0,0] [1,0,0]
LThigh.name = "Ab L Thigh Sub"
LThigh.parent = $'Bip001 L Thigh'
for i=1 to (getPropNames LThigh).count do
(
    setProperty LThigh (getPropNames LThigh)[i] #(2.0, 2.0, 0.0, 22.3832, true, 5.0, 11.2, 10.0, false, 10.0, 10.0, 14.0, false, 4.0, 10.0, 10.0, false)[i]
)
LThigh.pos.controller = position_script()
LThigh.pos.controller.addConstant "OBJ_A" $'Bip001 L Calf'
LThigh.pos.controller.addConstant "def_Angle" -95
LThigh.pos.controller.script = "A_Pos = ( (OBJ_A.transform * (inverse OBJ_A.parent.transform) ).position )
A_Rot = ( ( (OBJ_A.transform * (inverse OBJ_A.parent.transform) ).rotation ) as eulerAngles)
DA = degtorad Def_Angle
if A_Rot.z < Def_Angle then AX = A_Pos.x - ( ( degtorad A_Rot.z ) - DA )
else AX = A_Pos.x
if A_Rot.z < Def_Angle then AY = - ( ( degtorad A_Rot.z ) - DA ) * 3
else AY = 0
[ AX, AY, 0 ]"

LThigh.rotation.controller = rotation_script()
LThigh.rotation.controller.addConstant "OBJ_A"  $'Ab L Thigh Twist1'
LThigh.rotation.controller.script = "A_Rot = ( ( (OBJ_A.transform * (inverse OBJ_A.parent.transform) ).rotation ) as eulerAngles)
AX = A_Rot.x * 0.6
AZ = 180 + A_Rot.z
( EulerAngles (AX) (0) (AZ) )"

LThigh.scale.controller = scale_script()
LThigh.scale.controller.addConstant "OBJ_A"  $'Bip001 L Calf'
LThigh.scale.controller.script = "A_Rot = ( ( (OBJ_A.transform * (inverse OBJ_A.parent.transform) ).rotation ) as eulerAngles)
if A_Rot.z < 0 then AZ = 1 - ( ( degtorad A_Rot.z ) / 10 )
else AZ = 1
[1, 1, AZ]"

Lcalf = bonesys.createBone [0,0,1] [0,0,0] [1,0,0]
Lcalf.name = "Ab L Calf Sub"
Lcalf.parent = $'Bip001 L Calf'
for i=1 to (getPropNames Lcalf).count do
(
    setProperty Lcalf (getPropNames Lcalf)[i] #(2.0, 2.0, 0.0, 19.781, true, 5.0, 11.2, 10.0, false, 10.0, 10.0, 14.0, false, 4.0, 10.0, 10.0, false)[i]
)

Lcalf.pos.controller = position_script()
Lcalf.pos.controller.addConstant "OBJ_A" $'Bip001 L Calf'
Lcalf.pos.controller.addConstant "def_Angle" -95
Lcalf.pos.controller.script = "A_Rot = ( ( (OBJ_A.transform * (inverse OBJ_A.parent.transform) ).rotation ) as eulerAngles)

if A_Rot.z < Def_Angle then AX = degtorad ( ( -Def_Angle * 2 )+( (Def_Angle-A_Rot.z) * 1.5 ) )
else AX = degtorad ( -A_Rot.z * 2 )

if A_Rot.z > Def_Angle then AY = degtorad ( A_Rot.z * 1.5 )
else AY = degtorad ( ( A_Rot.z - ( A_Rot.z - Def_Angle ) * 5) * 1.5 )

[ AX, AY, 0 ]"

Lcalf.rotation.controller = Orientation_Constraint()
Lcalf.rotation.controller.appendTarget $'Ab L Calf Twist' 50.0
Lcalf.rotation.controller.appendTarget $'Bip001 L Calf' 50.0

Lcalf.scale.controller = scale_script()
Lcalf.scale.controller.addConstant "OBJ_A" $'Bip001 L Calf'
Lcalf.scale.controller.script = "A_Rot = ( ( (OBJ_A.transform * (inverse OBJ_A.parent.transform) ).rotation ) as eulerAngles)
if A_Rot.z < 0 then AZ = 1 - ( ( degtorad A_Rot.z ) / 10 )
else AZ = 1
[ 1, 1, AZ ]"

LKnee = bonesys.createBone [0,0,1] [0,0,0] [1,0,0]
LKnee.name = "Ab L Knee"
LKnee.parent = $'Bip001 L Thigh'
for i=1 to (getPropNames LKnee).count do
(
    setProperty LKnee (getPropNames LKnee)[i] #(2.0, 2.0, 0.0, 6.82225, false, 4.0, 11.2, 10.0, true, 5.0, 10.0, 14.0, false, 4.0, 10.0, 10.0, false)[i]
)

LKnee.pos.controller = position_script()
LKnee.pos.controller.addConstant "OBJ_A" $'Bip001 L Calf'
LKnee.pos.controller.script = "A_Pos = ( (OBJ_A.transform * (inverse OBJ_A.parent.transform) ).position )
AX = A_Pos.x
[ AX, 0, 0 ]"

LKnee.rotation.controller = rotation_script()
LKnee.rotation.controller.addConstant "OBJ_A" $'Ab L Thigh Twist1'
LKnee.rotation.controller.addConstant "OBJ_B" $'Bip001 L Calf'
LKnee.rotation.controller.addConstant "Rot_Z_Weight" 0.7
LKnee.rotation.controller.script = "A_Rot = ( ( (OBJ_A.transform * (inverse OBJ_A.parent.transform) ).rotation ) as eulerAngles)
B_Rot = ( ( (OBJ_B.transform * (inverse OBJ_B.parent.transform) ).rotation ) as eulerAngles)
AZ = ( 90 + A_Rot.z ) + ( B_Rot.z * Rot_Z_Weight )
( EulerAngles (0) (0) (AZ) )
"

LKneeBack = bonesys.createBone [0,0,1] [0,0,0] [1,0,0]
LKneeBack.name = "Ab L KneeBack"
LKneeBack.parent = $'Bip001 L Thigh'
for i=1 to (getPropNames LKneeBack).count do
(
    setProperty LKneeBack (getPropNames LKneeBack)[i] #(2.0, 2.0, 0.0, 4.74855, true, 6.0, 11.2, 10.0, false, 2.0, 10.0, 14.0, false, 4.0, 10.0, 10.0, false)[i]
)
LKneeBack.pos.controller = position_script()
LKneeBack.pos.controller.addConstant "OBJ_A" $'Bip001 L Calf'
LKneeBack.pos.controller.addConstant "Def_Angle" -95
LKneeBack.pos.controller.script = "A_Pos = ( (OBJ_A.transform * (inverse OBJ_A.parent.transform) ).position )
A_Rot = ( ( (OBJ_A.transform * (inverse OBJ_A.parent.transform) ).rotation ) as eulerAngles)
if A_Rot.z < Def_Angle then AX = A_Pos.x + ( degtorad ( ( A_Rot.z - ( A_Rot.z - Def_Angle ) ) * 3 ) )
else AX = A_Pos.x + ( degtorad ( A_Rot.z * 3 ) )
if A_Rot.z < Def_Angle then AY = degtorad ( ( A_Rot.z - ( ( A_Rot.z - Def_Angle ) * 2 ) ) * 2 )
else AY = Degtorad ( A_Rot.z * 2 )
[ AX, AY, 0 ]"
LKneeBack.rotation.controller = rotation_script()
LKneeBack.rotation.controller.addConstant "Mix_Rotation" 0.4
LKneeBack.rotation.controller.addConstant "OBJ_A" $'Bip001 L Calf'
LKneeBack.rotation.controller.script = "A_Rot = ( ( (OBJ_A.transform * (inverse OBJ_A.parent.transform) ).rotation ) as eulerAngles)



AZ = -90 + ( A_Rot.z * Mix_Rotation )



( EulerAngles (0) (0) (AZ) )"

