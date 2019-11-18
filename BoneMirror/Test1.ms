A_Pos = ( (OBJ_A.transform * (inverse OBJ_A.parent.transform) ).position )
A_Rot = ( ( (OBJ_A.transform * (inverse OBJ_A.parent.transform) ).rotation ) as eulerAngles)

if A_Rot.y > 0 then AX = A_Pos.x + ( degtorad ( A_Rot.y / 2 ) )
else AX = A_Pos.x

if A_Rot.y > 0 then AY = A_Pos.y - ( degtorad ( A_Rot.y / 5 ) )
else AY = A_Pos.y

if A_Rot.y > 0 then AZ = A_Pos.z - ( degtorad ( A_Rot.y / 10 ) )
else AZ = A_Pos.z

[AX, AY, AZ]
v: T:0
v: S:0
v: F:0
v: NT:0
v: OBJ_A:0
