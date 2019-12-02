---------------LArm----------------------------
( --Ab L Forearm Sub
	
	LForeArmSub = bonesys.createBone [0,0,1] [0,0,0] [1,0,0]
	LForeArmSub.name = "Ab L Forearm Sub"
	for i=1 to (getPropNames LForeArmSub).count do
	(
		setProperty LForeArmSub (getPropNames LForeArmSub)[i] #(2.0, 2.0, 0.0, 12.1937, true, 5.0, 11.2, 10.0, false, 10.0, 10.0, 14.0, false, 4.0, 10.0, 10.0, false)[i]
	)
	LForeArmSub.parent = $'Bip001 L ForeArm' 
	LForeArmSub.transform = (matrix3 [0.999976,0.00683945,-0.00117663] [-0.00684363,0.99997,-0.00359495] [0.0011521,0.00360295,0.999993] [-0.334976,-0.159534,0.392288]) * LForeArmSub.parent.transform 
	LForeArmSub.pos.controller = Position_Script()
	LForeArmSUb.pos.controller.addConstant "OBJ_A" $'Bip001 L Forearm'
	LForeArmSUb.pos.controller.addConstant "Def_Angle" -95 
	LForeArmSub.pos.controller.script = "A_Rot = ( ( (OBJ_A.transform * (inverse OBJ_A.parent.transform) ).rotation ) as eulerAngles)

	if A_Rot.z < Def_Angle then AX = degtorad ( ( -Def_Angle * 2 )+( (Def_Angle-A_Rot.z) * 1.5 ) )
	else AX = degtorad ( -A_Rot.z * 2 )
	
	if A_Rot.z > Def_Angle then AY = degtorad ( A_Rot.z * 1.5 )
	else AY = degtorad ( ( A_Rot.z - ( A_Rot.z - Def_Angle ) * 5) * 1.5 )
	
	[ AX, AY, 0 ]"
	
	LForeArmSub.rotation.controller = Orientation_Constraint() 
	LForeArmSub.rotation.controller.appendTarget $'Bip001 L Forearm' 70.0 
	LForeArmSub.rotation.controller.appendTarget $'Ab L ForeArm Twist' 30.0 
	
	LForeArmSub.scale.controller = scale_script()
	LForeArmSUb.scale.controller.addConstant "OBJ_A" $'Bip001 L Forearm'
	LForeArmSUb.scale.controller.script = "A_Rot = ( ( (OBJ_A.transform * (inverse OBJ_A.parent.transform) ).rotation ) as eulerAngles)

	if A_Rot.z < 0 then AZ = 1 - degtorad ( A_Rot.z / 10 )
	else AZ = 1

	[1, 1, AZ]"
	
)

( --Ab L Elbow
	
	LElbow = bonesys.createBone [0,0,1] [0,0,0] [1,0,0]
	LElbow.name = "Ab L Elbow"
	for i=1 to (getPropNames LElbow).count do
	(
		setProperty LElbow (getPropNames LElbow)[i] #(2.0, 2.0, 0.0, 12.1937, true, 5.0, 11.2, 10.0, false, 10.0, 10.0, 14.0, false, 4.0, 10.0, 10.0, false)[i]
	)
	LElbow.parent = $'Bip001 L UpperArm' 
	LElbow.transform = (matrix3 [0.81807,-0.386027,0.426314] [0.510902,0.147416,-0.846905] [0.264083,0.910632,0.317819] [-39.8032,-98.4396,95.7997]) * LElbow.parent.transform 
	LElbow.pos.controller = Position_Script()
	LElbow.pos.controller.addConstant "OBJ_A" $'Bip001 L Forearm'
	LElbow.pos.controller.script = "A_Pos = ( (OBJ_A.transform * (inverse OBJ_A.parent.transform) ).position )



	[ A_Pos.x, 0, 0 ]"
	
	LElbow.rotation.controller = rotation_Script() 
	LElbow.rotation.controller.addConstant "OBJ_A" $'Ab L UpperArm Twist1'
	LElbow.rotation.controller.addConstant "OBJ_B" $'Bip001 L Forearm'
	LElbow.rotation.controller.addConstant "Rot_z_Weight" 0.6
	LElbow.rotation.controller.script = "A_Rot = ( ( (OBJ_A.transform * (inverse OBJ_A.parent.transform) ).rotation ) as eulerAngles)

B_Rot = ( ( (OBJ_B.transform * (inverse OBJ_B.parent.transform) ).rotation ) as eulerAngles)



AZ = (90 + A_Rot.z) + (B_Rot.z * Rot_Z_Weight)



( EulerAngles (0) (0) (AZ) )"

)

( --Ab L UpperArm Sub
	LUpperArmSub = bonesys.createBone [0,0,1] [0,0,0] [1,0,0]
	LUpperArmSub.name = "Ab L UpperArm Sub" 
	for i=1 to (getPropNames LUpperArmSub).count do
	(
		setProperty LUpperArmSub (getPropNames LUpperArmSub)[i] #(2.0, 2.0, 0.0, 12.1937, true, 5.0, 11.2, 10.0, false, 10.0, 10.0, 14.0, false, 4.0, 10.0, 10.0, false)[i]
	)
	LUpperArmSub.parent = $'Bip001 L UpperArm' 
	LUpperArmSub.transform = (matrix3 [-0.953565,-0.234113,0.000552177] [-0.233803,0.969245,0.0739638] [0.000582039,0.0738083,-0.992542] [33.6422,-5.49629,257.451]) * LUpperArmSub.parent.transform 
	LUpperArmSub.pos.controller = Position_Script()
	LUpperArmSub.pos.controller.addConstant "OBJ_A" $'Bip001 L Forearm'
	LUpperArmSub.pos.controller.addConstant "Def_Angle" -95 
	LUpperArmSub.pos.controller.script = "A_Pos = ( (OBJ_A.transform * (inverse OBJ_A.parent.transform) ).position )

A_Rot = ( ( (OBJ_A.transform * (inverse OBJ_A.parent.transform) ).rotation ) as eulerAngles)



if A_Rot.z < Def_Angle then AX = A_Pos.x + ( degtorad ( A_Rot.z - Def_Angle ) )

else AX = A_Pos.x



if A_Rot.z < Def_Angle then AY = degtorad -( A_Rot.z - Def_Angle )

else AY = 0



[ AX, AY, 0 ]	"
	LUpperArmSub.rotation.controller = rotation_Script() 
	LUpperArmSub.rotation.controller.addConstant "OBJ_A" $'Ab L UpperArm Twist1'
	LUpperArmSub.rotation.controller.script = "A_Rot = ( ( (OBJ_A.transform * (inverse OBJ_A.parent.transform) ).rotation ) as eulerAngles)



AX = A_Rot.x * 0.3

AZ = A_Rot.z



( EulerAngles (AX) (-180) (AZ) )

"
	LUpperArmSub.scale.controller = scale_Script() 
	LUpperArmSub.scale.controller.addConstant "OBJ_A" $'Bip001 L Forearm'
	LUpperArmSub.scale.controller.script = "A_Rot = ( ( (OBJ_A.transform * (inverse OBJ_A.parent.transform) ).rotation ) as eulerAngles)



if A_Rot.z < 0 then AZ = 1 - ( degtorad ( A_Rot.z / 10 ) )

else AZ = 1



[1, 1, AZ]"
)

(--Ab L biceps
	Lbiceps = bonesys.createBone [0,0,1] [0,0,0] [1,0,0]
	Lbiceps.name = "Ab L biceps"
	for i=1 to (getPropNames Lbiceps).count do
	(
		setProperty Lbiceps (getPropNames Lbiceps)[i] #(2.0, 2.0, 0.0, 6.50741, true, 5.0, 11.2, 10.0, false, 10.0, 10.0, 14.0, false, 4.0, 10.0, 10.0, false)[i]
	)
	Lbiceps.parent = $'Bip001 L UpperArm' 
	Lbiceps.transform = (matrix3 [0.801867,0.529056,0.277686] [-0.333829,0.0112454,0.942566] [0.495548,-0.848512,0.185632] [-65.1603,99.5715,109.273]) * Lbiceps.parent.transform 
	Lbiceps.pos.controller = Position_Script()s
	Lbiceps.pos.controller.addConstant "Biceps_Pos" 0.6
	Lbiceps.pos.controller.addConstant "OBJ_A" $'Bip001 L Forearm'
	Lbiceps.pos.controller.addConstant "Def_Angle" -95 
	Lbiceps.pos.controller.script = "A_Pos = ( (OBJ_A.transform * (inverse OBJ_A.parent.transform) ).position )

A_Rot = ( ( (OBJ_A.transform * (inverse OBJ_A.parent.transform) ).rotation ) as eulerAngles)



if A_Rot.z < Def_Angle then AX = ( A_Pos.x * Biceps_Pos ) + ( degtorad ( ( A_Rot.z - Def_Angle ) + A_Rot.z / 5 ) )

else AX = ( A_Pos.x * Biceps_Pos ) + ( degtorad ( A_Rot.z / 5 ) )



if A_Rot.z < 0 then AY = degtorad ( A_Rot.z / 2 )

else AY = 0



[ AX, AY, 0 ]

"
	Lbiceps.rotation.controller = rotation_Script() 
	Lbiceps.rotation.controller.addConstant "OBJ_A" $'Ab L UpperArm Twist1'
	Lbiceps.rotation.controller.script = "A_Rot = ( ( (OBJ_A.transform * (inverse OBJ_A.parent.transform) ).rotation ) as eulerAngles)



AY = -A_Rot.x



( EulerAngles (0) (AY) (-90) )"

)

( -- dm L Trap 
	LTrap = point() 
	LTrap.name = "Dm L Trap" 
	for i=1 to (getPropNames LTrap).count do
	(
		setProperty LTrap (getPropNames LTrap)[i] #(5.0, false, false, false, true, false, false)[i]
	)
	LTrap.parent = SpineNode
	LTrap.transform = (matrix3 [1,0,0] [0,1,0] [0,0,1] [-6.98303,-2.20631,-11.6225]) * LTrap.parent.transform
	
	LTrap.pos.controller = Position_Constraint()
	LTrap.pos.controller.appendTarget $'Bip001 L Clavicle' 50.0
	LTrap.pos.controller.appendTarget $'Bip001 L UpperArm' 50.0
	
	LTrap.rotation.controller = Orientation_Constraint()
	LTrap.rotation.controller.appendTarget SpineNode 50.0
	
)

( --Ab L Deltoid
	LDeltoid = bonesys.createBone [0,0,1] [0,0,0] [1,0,0]
	LDeltoid.name = "Ab L Deltoid"
	for i=1 to (getPropNames LDeltoid).count do
	(
		setProperty LDeltoid (getPropNames LDeltoid)[i] #(2.0, 2.0, 10.0, 9.38383, false, 4.0, 10.0, 10.0, false, 10.0, 10.0, 10.0, true, 5.0, 10.0, 10.0, false)[i]
	)
	LDeltoid.parent = $'Bip001 L Clavicle' 
	LDeltoid.transform = (matrix3 [0.850911,-0.0431382,0.523535] [0.0480779,0.998835,0.00415973] [-0.523105,0.0216309,0.851994] [69.7439,-2.72809,17.0922])* LDeltoid.parent.transform 
	LDeltoid.pos.controller = Position_Script()
	LDeltoid.pos.controller.addConstant "OBJ_A" $'Bip001 L UpperArm'
	LDeltoid.pos.controller.script = "A_Pos = ( (OBJ_A.transform * (inverse OBJ_A.parent.transform) ).position ) /2



[A_Pos.x, A_Pos.y, A_Pos.z]"
	LDeltoid.rotation.controller = Rotation_Script()
	LDeltoid.rotation.controller.addConstant "OBJ_A" $'Dm L UpperArm'
	LDeltoid.rotation.controller.script = "A_Rot = ( ( (OBJ_A.transform * (inverse OBJ_A.parent.transform) ).rotation ) as eulerAngles)



( EulerAngles A_Rot.x A_Rot.y A_Rot.z )"

)

( --Ab L Trap
	LTrap2 = bonesys.createBone [0,0,1] [0,0,0] [1,0,0]
	LTrap2.name = "Ab L Trap"
	for i=1 to (getPropNames LTrap2).count do
	(
		setProperty LTrap2 (getPropNames LTrap2)[i] #(3.0, 3.0, 50.0, 7.46315, false, 10.0, 10.0, 10.0, true, 2.0, 10.0, 10.0, true, 2.0, 10.0, 10.0, false)[i]
	)
	LTrap2.parent = $'Dm L Trap'
	LTrap2.transform = (matrix3 [1,0,0] [0,1,0] [0,0,1] [-8.10623e-06,0.000229836,0.00178528])* LTrap2.parent.transform 
	LTrap2.pos.controller = Position_Script()
	LTrap2.pos.controller.addConstant "OBJ_A" $'Bip001 L Clavicle'
	LTrap2.pos.controller.script = "A_Rot = (OBJ_A.transform.rotation as eulerAngles)

if A_Rot.y < 0 then AX = degtorad ( -A_Rot.y * 5 )
else AX = degtorad ( -A_Rot.y )

[ AX, 0, 0 ] 
"
	LTrap2.rotation.controller = Rotation_Script()
	LTrap2.rotation.controller.addConstant "OBJ_A" $'Dm L Trap'
	LTrap2.rotation.controller.script = "A_Rot = ( ( (OBJ_A.transform * (inverse OBJ_A.parent.transform) ).rotation ) as eulerAngles)



( EulerAngles A_Rot.x A_Rot.y A_Rot.z )"
)




(--Ab L Clavicle
	LClavicle = bonesys.createBone [0,0,1] [0,0,0] [1,0,0]
	LClavicle.name = "Ab L Clavicle"
	for i=1 to (getPropNames LClavicle).count do
	(
		setProperty LClavicle (getPropNames LClavicle)[i] #(2.0, 2.0, 90.0, 16.7439, false, 10.0, 10.0, 10.0, true, 2.0, 10.0, 10.0, false, 2.0, 10.0, 10.0, false)[i]
	)
	LClavicle.pos = [0,0,0]
	LClaEnd = boneSys.createBone [0,0,-LClavicle.length] [0,0,-LClavicle.length-1] [0,0,0]
	LClaEnd.name = "Dm L Clavicle End"
	for i=1 to (getPropNames LClaEnd).count do
	(
		setProperty LClaEnd (getPropNames LClaEnd)[i] #(2.0, 2.0, 90.0, 2.0, false, 10.0, 10.0, 10.0, false, 100.0, 10.0, 10.0, false, 2.0, 10.0, 10.0, false)[i]
	)
	LClaEnd.parent = LClavicle 
	
	LClavicle.parent = $'Ab L UpperArm Twist'
	LClavicle.transform =(matrix3 [-0.741632,-0.19508,-0.641814] [0.0162025,-0.96171,0.273591] [-0.670611,0.192505,0.716396] [6.09536,1.19209e-06,-7.62939e-06]) * LClavicle.parent.transform
	LClavicle.pos.controller = Position_Constraint()
	LClavicle.pos.controller.appendTarget $'Ab L UpperArm Twist' 50.0 
	LClavicle.pos.controller.appendTarget $'Ab L UpperArm Twist1' 50.0
	
	LClavicle.rotation.controller = LookAt_Constraint()
	LClavicle.rotation.controller.appendTarget $'Dm Clavicle Point' 50.0
	LClavicle.rotation.controller.pickUpNode = $'Bip001 L Clavicle'
	LClavicle.rotation.controller.upnode_world = false 
	LClavicle.rotation.controller.viewline_length_abs = false 
	
	LClavicle.boneFreezeLength=false 
	
	LClaEnd.pos = $'Dm Clavicle Point'.pos 
	
	LClaEnd.pos.controller = Position_Constraint()
	LClaEnd.pos.controller.appendTarget $'Dm Clavicle Point' 50.0 

	
	--$'Ab L UpperArm Twist'.Length = $'Ab L UpperArm Twist'.Length * 7.5 -- 예외처리 코드 
)

( -- Dm L Scapula Point
	LScapulaP = Point() 
	LScapulaP.name = "Dm L Scapula Point"
	for i=1 to (getPropNames LScapulaP).count do
	(
		setProperty LScapulaP (getPropNames LScapulaP)[i] #(5.0, false, false, false, true, false, false)[i]
	)
	LScapulaP.parent = $'Bip001 L Clavicle'
	LScapulaP.transform = (matrix3 [1,0,0] [0,1,-0.000795886] [0,0.000795782,1] [9.77516e-06,4.25667,-0.567291]) * LScapulaP.parent.transform 
)

( -- Ab L Scapula
	LScapula = bonesys.createBone [0,0,1] [0,0,0] [1,0,0]
	LScapula.name = "Ab L Scapula"
	for i=1 to (getPropNames LScapula).count do
	(
		setProperty LScapula (getPropNames LScapula)[i] #(2.0, 2.0, 20.0, 8.59027, true, 2.0, 10.0, 10.0, true, 2.0, 10.0, 10.0, false, 2.0, 10.0, 10.0, false)[i]
	)
	LScapula.parent = $'Dm L Scapula Point'
	LScapula.transform = (matrix3 [0.493735,-0.0713102,-0.866684] [0.0289719,0.997427,-0.0655627] [0.86913,0.00726153,0.494531] [-120.689,-0.617413,73.0101]) * LScapula.parent.transform 
	
	LScapula.pos.controller = Position_Script()
	LScapula.pos.controller.addConstant "OBJ_A" $'Dm L UpperArm'
	LScapula.pos.controller.script = "A_Rot = ( (OBJ_A.transform * (inverse OBJ_A.parent.transform) ).rotation ) as eulerAngles



	AZ = degtorad -A_Rot.z
	
	if AZ > 0 then TY = AZ
	else TY = -AZ
	
	[ AZ*2, TY, 0 ]"

	LScapula.rotation.controller = rotation_script()
	LScapula.rotation.controller.addConstant "OBJ_A" $'Bip001 L UpperArm'
	LScapula.rotation.controller.addConstant "OBJ_B" $'Dm L UpperArm'
	LScapula.rotation.controller.script = "A_Rot = ( (OBJ_A.transform * (inverse OBJ_A.parent.transform) ).rotation ) as eulerAngles
	B_Rot = ( (OBJ_B.transform * (inverse OBJ_B.parent.transform) ).rotation ) as eulerAngles
	
	AY = A_Rot.y
	BZ = B_Rot.z
	
	TY = -(-30-(AY/2))
	 
	if BZ > 0 then TZ = BZ/2.5
	else TZ = BZ/5
	
	( EulerAngles (0) (TY) (TZ) )"

)
( --Dm L Side
	LSideD1 = Point()
	LSideD1.position.controller = Position_Constraint()
	LSideD1.position.controller.appendTarget $'Bip001 L UpperArm' 50.0
	LSideD1.position.controller.appendTarget SpineNode 50.0 
	
	LSideD1.rotation.controller = Orientation_Constraint()
	LSideD1.rotation.controller.appendTarget $'Bip001 L UpperArm' 50.0
	LSideD1.rotation.controller.appendTarget SpineNode 50.0 
	
	LSideTM = LSideD1.transform
	
	delete LSideD1 
	
	LSideD1 = Point()
	LSideD1.name = "Dm L Side A"
	for i=1 to (getPropNames LSideD1).count do
	(
		setProperty LSideD1 (getPropNames LSideD1)[i] #(2.0, false, false, true, false, false, false)[i]
	)
	LSideD1.transform = LSideTM
	LSideD1.parent = $'Ab L UpperArm Twist'
	
	LSideD2 = Point()
	LSideD2.position.controller = Position_Constraint()
	LSideD2.position.controller.appendTarget $'Bip001 L UpperArm' 50.0
	LSideD2.position.controller.appendTarget SpineNode 50.0 
	
	LSideD2.rotation.controller = Orientation_Constraint()
	LSideD2.rotation.controller.appendTarget $'Bip001 L UpperArm' 50.0
	LSideD2.rotation.controller.appendTarget SpineNode 50.0 
	
	LSideTM = LSideD2.transform
	
	delete LSideD2
	
	LSideD2 = Point()
	LSideD2.name = "Dm L Side B"
	for i=1 to (getPropNames LSideD2).count do
	(
		setProperty LSideD2 (getPropNames LSideD2)[i] #(2.0, false, false, true, false, false, false)[i]
	)
	LSideD2.parent = SpineNode
	LSideD2.transform = LSideTM
	in coordsys local move LSideD2 [0,0,1]
		
	
	LSideD = point()
	LSideD.name = "Dm L Side"
	LSideD.pos.controller = Position_Constraint()
	LSideD.pos.controller.appendTarget $'Dm L Side A' 50.0
	LSideD.pos.controller.appendTarget $'Dm L Side B' 50.0
	
	LSideD.rotation.controller = Orientation_Constraint()
	LSideD.rotation.controller.appendTarget $'Dm L Side A' 50.0
	LSideD.rotation.controller.appendTarget $'Dm L Side B' 50.0
	LSideD.parent = SpineNode
	
	
	in coordsys local rotate LSideD1 (angleaxis -90 [0,0,1])
	in coordsys local rotate LSideD2 (angleAxis -90 [0,0,1])
	
	in coordsys local rotate LSideD1 (angleaxis 90 [1,0,0])
	in coordsys local rotate LSideD2 (angleaxis 90 [1,0,0])
)



( -- Ab L Side
	LSide = bonesys.createBone [0,0,1] [0,0,0] [1,0,0]
	LSide.name = "Ab L Side"
	
	for i=1 to (getPropNames LSide).count do
	(
		setProperty LSide (getPropNames LSide)[i] #(2.0, 2.0, 0.0, 9.64692, true, 5.0, 11.2, 10.0, false, 10.0, 10.0, 14.0, false, 4.0, 10.0, 10.0, false)[i]
	)
	LSide.parent = $'Dm L Side' 
	
	LSide.pos.controller = Position_Script()
	LSide.pos.controller.addConstant "OBJ_A" $'Bip001 L UpperArm'
	LSide.pos.controller.script = "A_Rot = ( (OBJ_A.transform * (inverse OBJ_A.parent.transform) ).rotation ) as eulerAngles

	if A_Rot.y > 0 then AX = A_Rot.y*5
	else AX = 0
	
	AY = - A_Rot.y / 10
	
	AZ = A_Rot.z
	
	[ degtorad (AX), degtorad (AY), degtorad (AZ) ]"
	
	LSide.rotation.controller = Orientation_Constraint()
	LSide.rotation.controller.appendTarget $'Dm L Side' 50.0
)
----------Limb L ----------------------


