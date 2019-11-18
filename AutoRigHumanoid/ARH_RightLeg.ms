RHip = Point()
RHip.name = "Dm R Hip"
RHip.parent = $'Bip001 Pelvis'
RHip.transform = $'Bip001 R Thigh'.transform 

RHip.rotation.controller = Orientation_Constraint()
RHip.rotation.controller.appendTarget $'DM Hip Point' 50.0
RHip.rotation.controller.appendTarget $'Ab R Thigh Twist' 50.0 


RVente = bonesys.createBone [0,0,1] [0,0,0] [1,0,0]
RVente.name = "Ab R Vente"
for i=1 to (getPropNames RVente).count do
(
    setProperty RVente (getPropNames RVente)[i] #(2.0, 2.0, 10.0, 9.44028, true, 5.0, 10.0, 10.0, false, 10.0, 10.0, 10.0, false, 4.0, 10.0, 10.0, false)[i]
)
RVente.parent = $'Dm R Hip'
RVente.pos.Controller = position_script()
RVente.pos.controller.addConstant "OBJ_A" $'Bip001 R Thigh'
RVente.pos.controller.script = "A_Rot = ( ( (OBJ_A.transform * (inverse OBJ_A.parent.transform) ).rotation ) as eulerAngles)

if A_Rot.z > 0 then AY = degtorad ( A_Rot.z - 180 )
else AY = degtorad ( 180 + A_Rot.z )

if AY < 0 then TY = -AY*5
else TY = 0

if A_Rot.y > 0 then AZ = degtorad ( A_Rot.y * 5 )
else AZ = 0

[ 0, TY, AZ]"

RVente.rotation.controller = rotation_script()
RVente.rotation.controller.script ="( EulerAngles (0) (0) (90) )" 


RHipB = bonesys.createBone [0,0,1] [0,0,0] [1,0,0]
RHipB.name = "Ab R Hip"
for i=1 to (getPropNames RHipB).count do
(
    setProperty RHipB (getPropNames RHipB)[i] #(5.0, 5.0, 80.0, 15.0, false, 5.0, 11.2, 10.0, true, 10.0, 10.0, 14.0, false, 4.0, 10.0, 10.0, false)[i]
)
RHipB.parent = $'Dm R Hip'
RHipB.pos.controller = position_script()
RHipB.pos.controller.addConstant "OBJ_A" $'Bip001 R Thigh'
RHipB.pos.controller.script = "A_Rot = ( ( (OBJ_A.transform * (inverse OBJ_A.parent.transform) ).rotation ) as eulerAngles)
if A_Rot.z > 0 then AX = degtorad ( A_Rot.z - 180 )
else AX = degtorad ( 180 + A_Rot.Z )
if A_Rot.z > 0 then AY = degtorad ( A_Rot.z - 180 )
else AY = degtorad ( 180 + A_Rot.z )
if AX > 0 then TX = -AX
else TX = AX
if AY > 0 then TY = -AY
else TY = -AY*2
[ TX, TY, 0 ]"
RHipB.rotation.controller = rotation_script()
RHipB.rotation.controller.script = "( EulerAngles (0) (0) (-90) )"



RThigh = bonesys.createBone [0,0,1] [0,0,0] [1,0,0]
RThigh.name = "Ab R Thigh Sub"
RThigh.parent = $'Bip001 R Thigh'
for i=1 to (getPropNames RThigh).count do
(
    setProperty RThigh (getPropNames RThigh)[i] #(2.0, 2.0, 0.0, 22.3832, true, 5.0, 11.2, 10.0, false, 10.0, 10.0, 14.0, false, 4.0, 10.0, 10.0, false)[i]
)
RThigh.pos.controller = position_script()
RThigh.pos.controller.addConstant "OBJ_A" $'Bip001 R Calf'
RThigh.pos.controller.addConstant "def_Angle" -95
RThigh.pos.controller.script = "A_Pos = ( (OBJ_A.transform * (inverse OBJ_A.parent.transform) ).position )
A_Rot = ( ( (OBJ_A.transform * (inverse OBJ_A.parent.transform) ).rotation ) as eulerAngles)
DA = degtorad Def_Angle
if A_Rot.z < Def_Angle then AX = A_Pos.x - ( ( degtorad A_Rot.z ) - DA )
else AX = A_Pos.x
if A_Rot.z < Def_Angle then AY = - ( ( degtorad A_Rot.z ) - DA ) * 3
else AY = 0
[ AX, AY, 0 ]"

RThigh.rotation.controller = rotation_script()
RThigh.rotation.controller.addConstant "OBJ_A"  $'Ab R Thigh Twist1'
RThigh.rotation.controller.script = "A_Rot = ( ( (OBJ_A.transform * (inverse OBJ_A.parent.transform) ).rotation ) as eulerAngles)
AX = A_Rot.x * 0.6
AZ = 180 + A_Rot.z
( EulerAngles (AX) (0) (AZ) )"

RThigh.scale.controller = scale_script()
RThigh.scale.controller.addConstant "OBJ_A"  $'Bip001 R Calf'
RThigh.scale.controller.script = "A_Rot = ( ( (OBJ_A.transform * (inverse OBJ_A.parent.transform) ).rotation ) as eulerAngles)
if A_Rot.z < 0 then AZ = 1 - ( ( degtorad A_Rot.z ) / 10 )
else AZ = 1
[1, 1, AZ]"


Rcalf = bonesys.createBone [0,0,1] [0,0,0] [1,0,0]
Rcalf.name = "Ab R Calf Sub"
Rcalf.parent = $'Bip001 R Calf'
for i=1 to (getPropNames Rcalf).count do
(
    setProperty Rcalf (getPropNames Rcalf)[i] #(2.0, 2.0, 0.0, 19.781, true, 5.0, 11.2, 10.0, false, 10.0, 10.0, 14.0, false, 4.0, 10.0, 10.0, false)[i]
)

Rcalf.pos.controller = position_script()
Rcalf.pos.controller.addConstant "OBJ_A" $'Bip001 R Calf'
Rcalf.pos.controller.addConstant "def_Angle" -95
Rcalf.pos.controller.script = "A_Rot = ( ( (OBJ_A.transform * (inverse OBJ_A.parent.transform) ).rotation ) as eulerAngles)

if A_Rot.z < Def_Angle then AX = degtorad ( ( -Def_Angle * 2 )+( (Def_Angle-A_Rot.z) * 1.5 ) )
else AX = degtorad ( -A_Rot.z * 2 )

if A_Rot.z > Def_Angle then AY = degtorad ( A_Rot.z * 1.5 )
else AY = degtorad ( ( A_Rot.z - ( A_Rot.z - Def_Angle ) * 5) * 1.5 )

[ AX, AY, 0 ]"

Rcalf.rotation.controller = Orientation_Constraint()
Rcalf.rotation.controller.appendTarget $'Ab R Calf Twist' 50.0
Rcalf.rotation.controller.appendTarget $'Bip001 R Calf' 50.0

Rcalf.scale.controller = scale_script()
Rcalf.scale.controller.addConstant "OBJ_A" $'Bip001 R Calf'
Rcalf.scale.controller.script = "A_Rot = ( ( (OBJ_A.transform * (inverse OBJ_A.parent.transform) ).rotation ) as eulerAngles)
if A_Rot.z < 0 then AZ = 1 - ( ( degtorad A_Rot.z ) / 10 )
else AZ = 1
[ 1, 1, AZ ]"

RKnee = bonesys.createBone [0,0,1] [0,0,0] [1,0,0]
RKnee.name = "Ab R Knee"
RKnee.parent = $'Bip001 R Thigh'
for i=1 to (getPropNames RKnee).count do
(
    setProperty RKnee (getPropNames RKnee)[i] #(2.0, 2.0, 0.0, 6.82225, false, 4.0, 11.2, 10.0, true, 5.0, 10.0, 14.0, false, 4.0, 10.0, 10.0, false)[i]
)

RKnee.pos.controller = position_script()
RKnee.pos.controller.addConstant "OBJ_A" $'Bip001 R Calf'
RKnee.pos.controller.script = "A_Pos = ( (OBJ_A.transform * (inverse OBJ_A.parent.transform) ).position )
AX = A_Pos.x
[ AX, 0, 0 ]"

RKnee.rotation.controller = rotation_script()
RKnee.rotation.controller.addConstant "OBJ_A" $'Ab R Thigh Twist1'
RKnee.rotation.controller.addConstant "OBJ_B" $'Bip001 R Calf'
RKnee.rotation.controller.addConstant "Rot_Z_Weight" 0.7
RKnee.rotation.controller.script = "A_Rot = ( ( (OBJ_A.transform * (inverse OBJ_A.parent.transform) ).rotation ) as eulerAngles)
B_Rot = ( ( (OBJ_B.transform * (inverse OBJ_B.parent.transform) ).rotation ) as eulerAngles)
AZ = ( 90 + A_Rot.z ) + ( B_Rot.z * Rot_Z_Weight )
( EulerAngles (0) (0) (AZ) )
"

RKneeBack = bonesys.createBone [0,0,1] [0,0,0] [1,0,0]
RKneeBack.name = "Ab R KneeBack"
RKneeBack.parent = $'Bip001 R Thigh'
for i=1 to (getPropNames RKneeBack).count do
(
    setProperty RKneeBack (getPropNames RKneeBack)[i] #(2.0, 2.0, 0.0, 4.74855, true, 6.0, 11.2, 10.0, false, 2.0, 10.0, 14.0, false, 4.0, 10.0, 10.0, false)[i]
)
RKneeBack.pos.controller = position_script()
RKneeBack.pos.controller.addConstant "OBJ_A" $'Bip001 R Calf'
RKneeBack.pos.controller.addConstant "Def_Angle" -95
RKneeBack.pos.controller.script = "A_Pos = ( (OBJ_A.transform * (inverse OBJ_A.parent.transform) ).position )
A_Rot = ( ( (OBJ_A.transform * (inverse OBJ_A.parent.transform) ).rotation ) as eulerAngles)
if A_Rot.z < Def_Angle then AX = A_Pos.x + ( degtorad ( ( A_Rot.z - ( A_Rot.z - Def_Angle ) ) * 3 ) )
else AX = A_Pos.x + ( degtorad ( A_Rot.z * 3 ) )
if A_Rot.z < Def_Angle then AY = degtorad ( ( A_Rot.z - ( ( A_Rot.z - Def_Angle ) * 2 ) ) * 2 )
else AY = Degtorad ( A_Rot.z * 2 )
[ AX, AY, 0 ]"
RKneeBack.rotation.controller = rotation_script()
RKneeBack.rotation.controller.addConstant "Mix_Rotation" 0.4
RKneeBack.rotation.controller.addConstant "OBJ_A" $'Bip001 R Calf'
RKneeBack.rotation.controller.script = "A_Rot = ( ( (OBJ_A.transform * (inverse OBJ_A.parent.transform) ).rotation ) as eulerAngles)



AZ = -90 + ( A_Rot.z * Mix_Rotation )



( EulerAngles (0) (0) (AZ) )"

