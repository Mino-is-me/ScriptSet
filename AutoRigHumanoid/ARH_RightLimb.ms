
----------Limb R ----------------------
( --Ab R Forearm Sub
	
	RForeArmSub = bonesys.createBone [0,0,1] [0,0,0] [1,0,0]
	RForeArmSub.name = "Ab R Forearm Sub"
	for i=1 to (getPropNames RForeArmSub).count do
	(
		setProperty RForeArmSub (getPropNames RForeArmSub)[i] #(2.0, 2.0, 0.0, 12.1937, true, 5.0, 11.2, 10.0, false, 10.0, 10.0, 14.0, false, 4.0, 10.0, 10.0, false)[i]
	)
	RForeArmSub.parent = $'Bip001 R ForeArm' 
	RForeArmSub.transform = (matrix3 [1.01864,0.00528263,-0.0107066] [-0.00856254,1.00011,0.00448487] [-0.0083499,-0.00279832,1.00487] [1.21627,0.0287986,-1.1861]) * RForeArmSub.parent.transform 
	RForeArmSub.pos.controller = Position_Script()
	RForeArmSub.pos.controller.addConstant "OBJ_A" $'Bip001 R Forearm'
	RForeArmSub.pos.controller.addConstant "Def_Angle" -95 
	RForeArmSub.pos.controller.script = "A_Rot = ( ( (OBJ_A.transform * (inverse OBJ_A.parent.transform) ).rotation ) as eulerAngles)

	if A_Rot.z < Def_Angle then AX = degtorad ( ( -Def_Angle * 2 )+( (Def_Angle-A_Rot.z) * 1.5 ) )
	else AX = degtorad ( -A_Rot.z * 2 )
	
	if A_Rot.z > Def_Angle then AY = degtorad ( A_Rot.z * 1.5 )
	else AY = degtorad ( ( A_Rot.z - ( A_Rot.z - Def_Angle ) * 5) * 1.5 )
	
	[ AX, AY, 0 ]"
	
	RForeArmSub.rotation.controller = Orientation_Constraint() 
	RForeArmSub.rotation.controller.appendTarget $'Bip001 R Forearm' 70.0 
	RForeArmSub.rotation.controller.appendTarget $'Ab R ForeArm Twist' 30.0 
	
	RForeArmSub.scale.controller = scale_script()
	RForeArmSub.scale.controller.addConstant "OBJ_A" $'Bip001 R Forearm'
	RForeArmSub.scale.controller.script = "A_Rot = ( ( (OBJ_A.transform * (inverse OBJ_A.parent.transform) ).rotation ) as eulerAngles)

if A_Rot.z < 0 then AZ = 1 - degtorad ( A_Rot.z / 10 )
else AZ = 1

[1, 1, AZ]"
)

( --Ab R Elbow
	
	RElbow = bonesys.createBone [0,0,1] [0,0,0] [1,0,0]
	RElbow.name = "Ab R Elbow"
	for i=1 to (getPropNames RElbow).count do
	(
		setProperty RElbow (getPropNames RElbow)[i] #(2.0, 2.0, 0.0, 12.1937, true, 5.0, 11.2, 10.0, false, 10.0, 10.0, 14.0, false, 4.0, 10.0, 10.0, false)[i]
	)
	RElbow.parent = $'Bip001 R UpperArm' 
	RElbow.transform = (matrix3 [0.818071,-0.5109,-0.264085] [0.386029,0.147416,0.910632] [-0.426312,-0.846906,0.317819] [46.279,115.98,69.7067]) * RElbow.parent.transform 
	RElbow.pos.controller = Position_Script()
	RElbow.pos.controller.addConstant "OBJ_A" $'Bip001 R Forearm'
	RElbow.pos.controller.script = "A_Pos = ( (OBJ_A.transform * (inverse OBJ_A.parent.transform) ).position )

[ A_Pos.x, 0, 0 ]"
	
	RElbow.rotation.controller = rotation_Script() 
	RElbow.rotation.controller.addConstant "OBJ_A" $'Ab R UpperArm Twist1'
	RElbow.rotation.controller.addConstant "OBJ_B" $'Bip001 R Forearm'
	RElbow.rotation.controller.addConstant "Rot_z_Weight" 0.6
	RElbow.rotation.controller.script = "A_Rot = ( ( (OBJ_A.transform * (inverse OBJ_A.parent.transform) ).rotation ) as eulerAngles)
B_Rot = ( ( (OBJ_B.transform * (inverse OBJ_B.parent.transform) ).rotation ) as eulerAngles)

AZ = (90 + A_Rot.z) + (B_Rot.z * Rot_Z_Weight)

( EulerAngles (0) (0) (AZ) )"
)

( --Ab R UpperArm Sub
	RUpperArmSub = bonesys.createBone [0,0,1] [0,0,0] [1,0,0]
	RUpperArmSub.name = "Ab R UpperArm Sub" 
	for i=1 to (getPropNames RUpperArmSub).count do
	(
		setProperty RUpperArmSub (getPropNames RUpperArmSub)[i] #(2.0, 2.0, 0.0, 12.1937, true, 5.0, 11.2, 10.0, false, 10.0, 10.0, 14.0, false, 4.0, 10.0, 10.0, false)[i]
	)
	RUpperArmSub.parent = $'Bip001 R UpperArm' 
	RUpperArmSub.transform = (matrix3 [-0.990396,0.237824,0.0182735] [0.237507,0.968875,0.072068] [0.0182429,0.0719089,-1.00217] [-36.7103,-5.18681,259.02]) * RUpperArmSub.parent.transform 
	RUpperArmSub.pos.controller = Position_Script()
	RUpperArmSub.pos.controller.addConstant "OBJ_A" $'Bip001 R Forearm'
	RUpperArmSub.pos.controller.addConstant "Def_Angle" -95 
	RUpperArmSub.pos.controller.script = "A_Pos = ( (OBJ_A.transform * (inverse OBJ_A.parent.transform) ).position )
A_Rot = ( ( (OBJ_A.transform * (inverse OBJ_A.parent.transform) ).rotation ) as eulerAngles)

if A_Rot.z < Def_Angle then AX = A_Pos.x + ( degtorad ( A_Rot.z - Def_Angle ) )
else AX = A_Pos.x

if A_Rot.z < Def_Angle then AY = degtorad -( A_Rot.z - Def_Angle )
else AY = 0

[ AX, AY, 0 ]	"
	RUpperArmSub.rotation.controller = rotation_Script() 
	RUpperArmSub.rotation.controller.addConstant "OBJ_A" $'Ab R UpperArm Twist1'
	RUpperArmSub.rotation.controller.script = "A_Rot = ( ( (OBJ_A.transform * (inverse OBJ_A.parent.transform) ).rotation ) as eulerAngles)

AX = A_Rot.x * 0.3
AZ = A_Rot.z

( EulerAngles (AX) (-180) (AZ) )"
	RUpperArmSub.scale.controller = scale_Script() 
	RUpperArmSub.scale.controller.addConstant "OBJ_A" $'Bip001 R Forearm'
	RUpperArmSub.scale.controller.script = "A_Rot = ( ( (OBJ_A.transform * (inverse OBJ_A.parent.transform) ).rotation ) as eulerAngles)



if A_Rot.z < 0 then AZ = 1 - ( degtorad ( A_Rot.z / 10 ) )

else AZ = 1



[1, 1, AZ]"
)

(--Ab R biceps
	Rbiceps = bonesys.createBone [0,0,1] [0,0,0] [1,0,0]
	Rbiceps.name = "Ab R biceps"
	for i=1 to (getPropNames Rbiceps).count do
	(
		setProperty Rbiceps (getPropNames Rbiceps)[i] #(2.0, 2.0, 0.0, 6.50741, true, 5.0, 11.2, 10.0, false, 10.0, 10.0, 14.0, false, 4.0, 10.0, 10.0, false)[i]
	)
	Rbiceps.parent = $'Bip001 R UpperArm' 
	Rbiceps.transform = (matrix3 [-0.990396,0.237824,0.0182735] [0.237507,0.968875,0.072068] [0.0182429,0.0719089,-1.00217] [-36.7103,-5.18681,259.02]) * Rbiceps.parent.transform 
	Rbiceps.pos.controller = Position_Script()s
	Rbiceps.pos.controller.addConstant "Biceps_Pos" 0.6
	Rbiceps.pos.controller.addConstant "OBJ_A" $'Bip001 R Forearm'
	Rbiceps.pos.controller.addConstant "Def_Angle" -95 
	Rbiceps.pos.controller.script = "A_Pos = ( (OBJ_A.transform * (inverse OBJ_A.parent.transform) ).position )

A_Rot = ( ( (OBJ_A.transform * (inverse OBJ_A.parent.transform) ).rotation ) as eulerAngles)



if A_Rot.z < Def_Angle then AX = ( A_Pos.x * Biceps_Pos ) + ( degtorad ( ( A_Rot.z - Def_Angle ) + A_Rot.z / 5 ) )

else AX = ( A_Pos.x * Biceps_Pos ) + ( degtorad ( A_Rot.z / 5 ) )



if A_Rot.z < 0 then AY = degtorad ( A_Rot.z / 2 )

else AY = 0



[ AX, AY, 0 ]

"
	Rbiceps.rotation.controller = rotation_Script() 
	Rbiceps.rotation.controller.addConstant "OBJ_A" $'Ab R UpperArm Twist1'
	Rbiceps.rotation.controller.script = "A_Rot = ( ( (OBJ_A.transform * (inverse OBJ_A.parent.transform) ).rotation ) as eulerAngles)



AY = -A_Rot.x



( EulerAngles (0) (AY) (-90) )"

)

( -- dm R Trap 
	RTrap = point() 
	RTrap.name = "Dm R Trap" 
	for i=1 to (getPropNames RTrap).count do
	(
		setProperty RTrap (getPropNames RTrap)[i] #(5.0, false, false, false, true, false, false)[i]
	)
	RTrap.parent = SpineNode
	RTrap.transform = (matrix3 [1,0,0] [0,1,0] [0,0,1] [-6.98303,2.20629,11.6225]) * RTrap.parent.transform
	
	RTrap.pos.controller = Position_Constraint()
	RTrap.pos.controller.appendTarget $'Bip001 R Clavicle' 50.0
	RTrap.pos.controller.appendTarget $'Bip001 R UpperArm' 50.0
	
	RTrap.rotation.controller = Orientation_Constraint()
	RTrap.rotation.controller.appendTarget SpineNode 50.0
	
)

( --Ab R Deltoid
	RDeltoid = bonesys.createBone [0,0,1] [0,0,0] [1,0,0]
	RDeltoid.name = "Ab R Deltoid"
	for i=1 to (getPropNames RDeltoid).count do
	(
		setProperty RDeltoid (getPropNames RDeltoid)[i] #(2.0, 2.0, 10.0, 9.38383, false, 4.0, 10.0, 10.0, false, 10.0, 10.0, 10.0, true, 5.0, 10.0, 10.0, false)[i]
	)
	RDeltoid.parent = $'Bip001 R Clavicle' 
	RDeltoid.transform = (matrix3 [0.850912,-0.0480784,0.523105] [0.0431378,0.998835,0.0216322] [-0.523535,0.00415826,0.851994] [68.4119,-0.699136,21.98]) * RDeltoid.parent.transform 
	RDeltoid.pos.controller = Position_Script()
	RDeltoid.pos.controller.addConstant "OBJ_A" $'Bip001 R UpperArm'
	RDeltoid.pos.controller.script = "A_Pos = ( (OBJ_A.transform * (inverse OBJ_A.parent.transform) ).position ) /2



[A_Pos.x, A_Pos.y, A_Pos.z]"
	RDeltoid.rotation.controller = Rotation_Script()
	RDeltoid.rotation.controller.addConstant "OBJ_A" $'Dm R UpperArm'
	RDeltoid.rotation.controller.script = "A_Rot = ( ( (OBJ_A.transform * (inverse OBJ_A.parent.transform) ).rotation ) as eulerAngles)



( EulerAngles A_Rot.x A_Rot.y A_Rot.z )"
)

( --Ab R Trap
	RTrap2 = bonesys.createBone [0,0,1] [0,0,0] [1,0,0]
	RTrap2.name = "Ab R Trap"
	for i=1 to (getPropNames RTrap2).count do
	(
		setProperty RTrap2 (getPropNames RTrap2)[i] #(3.0, 3.0, 50.0, 7.46315, false, 10.0, 10.0, 10.0, true, 2.0, 10.0, 10.0, true, 2.0, 10.0, 10.0, false)[i]
	)
	RTrap2.parent = $'Dm R Trap'
	RTrap2.transform = (matrix3 [1,0,0] [0,1,0] [0,0,1] [-9.53674e-06,-0.00022006,-0.00184631]) * RTrap2.parent.transform 
	RTrap2.pos.controller = Position_Script()
	RTrap2.pos.controller.addConstant "OBJ_A" $'Bip001 R Clavicle'
	RTrap2.pos.controller.script = "A_Rot = (OBJ_A.transform.rotation as eulerAngles)

if A_Rot.y < 0 then AX = degtorad ( -A_Rot.y * 5 )
else AX = degtorad ( -A_Rot.y )

[ AX, 0, 0 ] 
"
	RTrap2.rotation.controller = Rotation_Script()
	RTrap2.rotation.controller.addConstant "OBJ_A" $'Dm R Trap'
	RTrap2.rotation.controller.script = "A_Rot = ( ( (OBJ_A.transform * (inverse OBJ_A.parent.transform) ).rotation ) as eulerAngles)



( EulerAngles A_Rot.x A_Rot.y A_Rot.z )"
)




(--Ab R Clavicle
	RClavicle = bonesys.createBone [0,0,1] [0,0,0] [1,0,0]
	RClavicle.name = "Ab R Clavicle"
	for i=1 to (getPropNames RClavicle).count do
	(
		setProperty RClavicle (getPropNames RClavicle)[i] #(2.0, 2.0, 90.0, 16.7439, false, 10.0, 10.0, 10.0, true, 2.0, 10.0, 10.0, false, 2.0, 10.0, 10.0, false)[i]
	)
	RClavicle.pos = [0,0,0]
	RClaEnd = boneSys.createBone [0,0,-RClavicle.length] [0,0,-RClavicle.length-1] [0,0,0]
	RClaEnd.name = "Dm R Clavicle End"
	for i=1 to (getPropNames RClaEnd).count do
	(
		setProperty RClaEnd (getPropNames RClaEnd)[i] #(2.0, 2.0, 90.0, 2.0, false, 10.0, 10.0, 10.0, false, 100.0, 10.0, 10.0, false, 2.0, 10.0, 10.0, false)[i]
	)
	RClaEnd.parent = RClavicle 
	
	RClavicle.parent = $'Ab R UpperArm Twist'
	RClavicle.transform =(matrix3 [-0.741632,-0.19508,-0.641814] [0.0162025,-0.96171,0.273591] [-0.670611,0.192505,0.716396] [6.09536,1.19209e-06,-7.62939e-06]) * RClavicle.parent.transform
	RClavicle.pos.controller = Position_Constraint()
	RClavicle.pos.controller.appendTarget $'Ab R UpperArm Twist' 50.0 
	RClavicle.pos.controller.appendTarget $'Ab R UpperArm Twist1' 50.0
	
	RClavicle.rotation.controller = LookAt_Constraint()
	RClavicle.rotation.controller.appendTarget $'Dm Clavicle Point' 50.0
	RClavicle.rotation.controller.pickUpNode = $'Bip001 R Clavicle'
	RClavicle.rotation.controller.upnode_world = false 
	RClavicle.rotation.controller.viewline_length_abs = false 
	RClavicle.boneFreezeLength=false 
	
	RClaEnd.pos = $'Dm Clavicle Point'.pos 
	
	RClaEnd.pos.controller = Position_Constraint()
	RClaEnd.pos.controller.appendTarget $'Dm Clavicle Point' 50.0 
	
	
	--$'Ab R UpperArm Twist'.Length = $'Ab R UpperArm Twist'.Length * 7.5 -- ����ó�� �ڵ� 
)

( -- Dm R Scapula Point
	RScapulaP = Point() 
	RScapulaP.name = "Dm R Scapula Point"
	for i=1 to (getPropNames RScapulaP).count do
	(
		setProperty RScapulaP (getPropNames RScapulaP)[i] #(5.0, false, false, false, true, false, false)[i]
	)
	RScapulaP.parent = $'Bip001 R Clavicle'
	RScapulaP.transform = (matrix3 [0.999998,-0.000234911,-0.00180867] [0.00023635,1,0.000795588] [0.00180848,-0.000796124,0.999998] [-0.253796,4.47924,-0.573471]) * RScapulaP.parent.transform 
)

( -- Ab R Scapula
	RScapula = bonesys.createBone [0,0,1] [0,0,0] [1,0,0]
	RScapula.name = "Ab R Scapula"
	for i=1 to (getPropNames RScapula).count do
	(
		setProperty RScapula (getPropNames RScapula)[i] #(2.0, 2.0, 20.0, 8.59027, true, 2.0, 10.0, 10.0, true, 2.0, 10.0, 10.0, false, 2.0, 10.0, 10.0, false)[i]
	)
	RScapula.parent = $'Dm R Scapula Point'
	RScapula.transform = (matrix3 [0.493735,-0.0713102,-0.866684] [0.0289719,0.997427,-0.0655627] [0.86913,0.00726153,0.494531] [-120.689,-0.617413,73.0101]) * RScapula.parent.transform 
	
	RScapula.pos.controller = Position_Script()
	RScapula.pos.controller.addConstant "OBJ_A" $'Dm R UpperArm'
	RScapula.pos.controller.script = "A_Rot = ( (OBJ_A.transform * (inverse OBJ_A.parent.transform) ).rotation ) as eulerAngles

	AZ = degtorad -A_Rot.z
	
	if AZ > 0 then TY = AZ
	else TY = -AZ
	
	[ AZ*2, TY, 0 ]"

	RScapula.rotation.controller = rotation_script()
	RScapula.rotation.controller.addConstant "OBJ_A" $'Bip001 R UpperArm'
	RScapula.rotation.controller.addConstant "OBJ_B" $'Dm R UpperArm'
	RScapula.rotation.controller.script = "A_Rot = ( (OBJ_A.transform * (inverse OBJ_A.parent.transform) ).rotation ) as eulerAngles
	B_Rot = ( (OBJ_B.transform * (inverse OBJ_B.parent.transform) ).rotation ) as eulerAngles
	
	AY = A_Rot.y
	BZ = B_Rot.z
	
	TY = -(30-(AY/2))
	 
	if BZ > 0 then TZ = BZ/2.5
	else TZ = BZ/5
	
	
	( EulerAngles (0) (TY) (TZ) )"

)

( --Dm R Side
	RSideD1 = Point()
	RSideD1.position.controller = Position_Constraint()
	RSideD1.position.controller.appendTarget $'Bip001 R UpperArm' 50.0
	RSideD1.position.controller.appendTarget SpineNode 50.0 
	
	RSideD1.rotation.controller = Orientation_Constraint()
	RSideD1.rotation.controller.appendTarget $'Bip001 R UpperArm' 50.0
	RSideD1.rotation.controller.appendTarget SpineNode 50.0 
	
	RSideTM = RSideD1.transform
	
	delete RSideD1 
	
	RSideD1 = Point()
	RSideD1.name = "Dm R Side A"
	for i=1 to (getPropNames RSideD1).count do
	(
		setProperty RSideD1 (getPropNames RSideD1)[i] #(2.0, false, false, true, false, false, false)[i]
	)
	RSideD1.transform = RSideTM
	RSideD1.parent = $'Ab R UpperArm Twist'
	
	RSideD2 = Point()
	RSideD2.position.controller = Position_Constraint()
	RSideD2.position.controller.appendTarget $'Bip001 R UpperArm' 50.0
	RSideD2.position.controller.appendTarget SpineNode 50.0 
	
	RSideD2.rotation.controller = Orientation_Constraint()
	RSideD2.rotation.controller.appendTarget $'Bip001 R UpperArm' 50.0
	RSideD2.rotation.controller.appendTarget SpineNode 50.0 
	
	RSideTM = RSideD2.transform
	
	delete RSideD2
	
	RSideD2 = Point()
	RSideD2.name = "Dm R Side B"
	for i=1 to (getPropNames RSideD2).count do
	(
		setProperty RSideD2 (getPropNames RSideD2)[i] #(2.0, false, false, true, false, false, false)[i]
	)
	RSideD2.parent = SpineNode
	RSideD2.transform = RSideTM
	in coordsys local move RSideD2 [0,0,1]
		
	
	RSideD = point()
	RSideD.name = "Dm R Side"
	RSideD.pos.controller = Position_Constraint()
	RSideD.pos.controller.appendTarget $'Dm R Side A' 50.0
	RSideD.pos.controller.appendTarget $'Dm R Side B' 50.0
	
	RSideD.rotation.controller = Orientation_Constraint()
	RSideD.rotation.controller.appendTarget $'Dm R Side A' 50.0
	RSideD.rotation.controller.appendTarget $'Dm R Side B' 50.0
	RSideD.parent = SpineNode
	
	
	in coordsys local rotate RSideD1 (angleaxis -90 [0,0,1])
	in coordsys local rotate RSideD2 (angleAxis -90 [0,0,1])
	
	in coordsys local rotate RSideD1 (angleaxis 90 [1,0,0])
	in coordsys local rotate RSideD2 (angleaxis 90 [1,0,0])
)



( -- Ab R Side
	RSide = bonesys.createBone [0,0,1] [0,0,0] [1,0,0]
	RSide.name = "Ab R Side"
	
	for i=1 to (getPropNames RSide).count do
	(
		setProperty RSide (getPropNames RSide)[i] #(2.0, 2.0, 0.0, 9.64692, true, 5.0, 11.2, 10.0, false, 10.0, 10.0, 14.0, false, 4.0, 10.0, 10.0, false)[i]
	)
	RSide.parent = $'Dm R Side' 
	
	RSide.pos.controller = Position_Script()
	RSide.pos.controller.addConstant "OBJ_A" $'Bip001 R UpperArm'
	RSide.pos.controller.script = "A_Rot = ( (OBJ_A.transform * (inverse OBJ_A.parent.transform) ).rotation ) as eulerAngles

	if A_Rot.y < 0 then AX = -A_Rot.y*5
	else AX = 0
	
	AY = - A_Rot.y / 10
	
	AZ = A_Rot.z
	
	[ degtorad (AX), degtorad (AY), degtorad (AZ) ]"
	
	RSide.rotation.controller = Orientation_Constraint()
	RSide.rotation.controller.appendTarget $'Dm R Side' 50.0
)
----------Limb R --------------------