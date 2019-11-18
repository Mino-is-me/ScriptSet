/*
return Value => Parent Space (Base Joint Space)

input Value -> World Space 

Rig function List*/

getinverseBoneTR( UBone OBJ_A, float Def_Angle, float Biceps_Pos)
{
	A_TR = OBJ_A.transform * ( inverse OBJ_A.parent.transform )

}



