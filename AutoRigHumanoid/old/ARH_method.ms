
fileIn "\\\\10.220.70.12\\eve\\ART_Backup\\Script\\Library\\stella.ms"
--stella Library Include--
Global arBoneSets = #(2,2,2,2)
Global arStates = #(true,true,true)

obj = $
arProperties = getPropNames obj
for i=1 to arProperties.count do 
(
	setProperty obj arProperties[i] Ab_L_Forearm_Sub.NodeProperties[i] 
)



arPositionContraintTarget = #() 
for i=1 to 5 do 
(
	local target = obj.rotation.controller.getNode i 
	if target != undefined do 
	(
		append arPositionContraintTarget target 
		arPositionContraintTarget.count 
	)
)

arOrientationContraintTargets = #()
for i=1 to 5 do 
(
	local target = obj.rotation.controller.getNode i
	if target != undefined do 
	(
		append arOrientationContraintTargets target 
	)
	arOrientationContraintTargets.count 
)

undo on 
(
	TBSetFunction arBoneSets arStates 
) 

select $Bone* 

for i=1 to selection.count do 
(
	selection[i].name = substituteString selection[i].name "Bone" "Ab"
)

deselect $*

struct RigNode --RiggedNode를 Struct로 재정의 0
(
	KindaNode, -- 종류 
	NodeName, -- 이름 
	NodeProperties, -- 프로퍼티 
	NodeParent, -- 부모노드 
	relativeTransform, -- 분해된 상대 트랜스폼 
	PosController,-- #(Controller, Variable or Target , Script or Weight)
	PosVarName, -- #(#(Var,Target),#(Var,Target)) 
	PosVarValue,
	PosScript,
	RotController, -- #(Controller, Variable or Target , Script or Weight) 
	RotVarName, -- #(#(Var,Target),#(Var,Target)) 
	RotVarValue,
	RotScript,
	SclController, -- #(Controller, Variable or Target , Script or Weight) 
	SclVarName, -- #(#(Var,Target),#(Var,Target)) 
	SclVarValue,
	SclScript
	
)
-- L Limb Start--
Ab_L_Forearm_Sub = RigNode()
	Ab_L_Forearm_Sub.KindaNode = bonsys.createBone [0,0,1] [0,0,0] [1,0,0] 
	Ab_L_Forearm_Sub.nodeName = "Ab L Forearm Sub"
	Ab_L_Forearm_Sub.NodeProperties = #(2.0, 2.0, 0.0, 12.1937, true, 5.0, 11.2, 10.0, false, 10.0, 10.0, 14.0, false, 4.0, 10.0, 10.0, false)
	Ab_L_Forearm_Sub.NodeParent = $'Bip001 L Forearm'
	Ab_L_Forearm_Sub.relativeTransform = (matrix3 [0.999976,0.00683945,-0.00117663] [-0.00684363,0.99997,-0.00359495] [0.0011521,0.00360295,0.999993] [-0.334976,-0.159534,0.392288])
	Ab_L_Forearm_sub.PosController = Position_Script()
	Ab_L_Forearm_sub.PosVariables = #("OBJ_A", $'Bip001 L Forearm')
	Ab_L_Forearm_sub.RotController = Orientation_Constraint() 
	Ab_L_Forearm_sub.RotVariables = #( #($'Bip001 L Foream', 70.0),#($'Ab L ForeArm Twist',30.0)
	Ab_L_Forearm_sub.SclController = ScaleXYZ() 
	Ab_L_Forearm_sub.SclVariables = #()

Ab_L_UpperArm_Sub = RigNode()
	Ab_L_UpperArm_Sub.nodeName ="Ab L UpperArm Sub"
	Ab_L_UpperArm_Sub.nodeProperties = #(2.0, 2.0, 0.0, 12.1908, true, 5.0, 11.2, 10.0, false, 10.0, 10.0, 14.0, false, 4.0, 10.0, 10.0, false)
	Ab_L_UpperArm_Sub.NodeParent =$'Bip001 L UpperArm'
	Ab_L_UpperArm_Sub.relativeTransform = (matrix3 [-0.953565,-0.234113,0.000552177] [-0.233803,0.969245,0.0739638] [0.000582039,0.0738083,-0.992542] [33.6422,-5.49629,257.451])

Ab_L_Elbow = RigNode() 
	Ab_L_Elbow.nodeName="Ab L Elbow"
	Ab_L_Elbow.nodeProperties=#(2.0, 2.0, 0.0, 4.74855, false, 5.0, 11.2, 10.0, false, 5.0, 10.0, 14.0, true, 5.0, 10.0, 10.0, false)
	Ab_L_Elbow.NodeParent=$'Bip001 L UpperArm'
	Ab_L_Elbow.relativeTransform=(matrix3 [0.81807,-0.386027,0.426314] [0.510902,0.147416,-0.846905] [0.264083,0.910632,0.317819] [-39.8032,-98.4396,95.7997])
	
Ab_L_biceps = RigNode() 
	Ab_L_biceps.nodeName="Ab L biceps"
	Ab_L_biceps.nodeProperties=#(2.0, 2.0, 0.0, 6.50741, true, 5.0, 11.2, 10.0, false, 10.0, 10.0, 14.0, false, 4.0, 10.0, 10.0, false)
	Ab_L_biceps.NodeParent=$'Bip001 L UpperArm' 
	Ab_L_biceps.relativeTransform=(matrix3 [0.801867,0.529056,0.277686] [-0.333829,0.0112454,0.942566] [0.495548,-0.848512,0.185632] [-65.1603,99.5715,109.273])
-- L Limb End--	
	

-- R Limb Start--
Ab_R_Forearm_Sub = RigNode()
	Ab_R_Forearm_Sub.nodeName = "Ab R Forearm Sub"
	Ab_R_Forearm_Sub.NodeProperties = #(2.0, 2.0, 0.0, 12.1937, true, 5.0, 11.2, 10.0, false, 10.0, 10.0, 14.0, false, 4.0, 10.0, 10.0, false)
	Ab_R_Forearm_Sub.NodeController = ""
	Ab_R_Forearm_Sub.NodeParent = $'Bip001 L Forearm'
	Ab_R_Forearm_Sub.relativeTransform = (matrix3 [0.999976,0.00683945,-0.00117663] [-0.00684363,0.99997,-0.00359495] [0.0011521,0.00360295,0.999993] [-0.334976,-0.159534,0.392288])

Ab_R_UpperArm_Sub = RigNode()
	Ab_R_UpperArm_Sub.nodeName ="Ab R UpperArm Sub"
	Ab_R_UpperArm_Sub.nodeProperties = #(2.0, 2.0, 0.0, 12.1908, true, 5.0, 11.2, 10.0, false, 10.0, 10.0, 14.0, false, 4.0, 10.0, 10.0, false)
	Ab_R_UpperArm_Sub.NodeController = 
	Ab_R_UpperArm_Sub.NodeParent =$'Bip001 R UpperArm'
	Ab_R_UpperArm_Sub.relativeTransform = (matrix3 [-0.953565,-0.234113,0.000552177] [-0.233803,0.969245,0.0739638] [0.000582039,0.0738083,-0.992542] [33.6422,-5.49629,257.451])

Ab_R_Elbow = RigNode() 
	Ab_R_Elbow.nodeName="Ab R Elbow"
	Ab_R_Elbow.nodeProperties=#(2.0, 2.0, 0.0, 4.74855, false, 5.0, 11.2, 10.0, false, 5.0, 10.0, 14.0, true, 5.0, 10.0, 10.0, false)
	Ab_R_Elbow.NodeController=
	Ab_R_Elbow.NodeParent=$'Bip001 R UpperArm'
	Ab_R_Elbow.relativeTransform=(matrix3 [0.81807,-0.386027,0.426314] [0.510902,0.147416,-0.846905] [0.264083,0.910632,0.317819] [-39.8032,-98.4396,95.7997])
	
Ab_R_biceps = RigNode() 
	Ab_R_biceps.nodeName="Ab R biceps"
	Ab_R_biceps.nodeProperties=#(2.0, 2.0, 0.0, 6.50741, true, 5.0, 11.2, 10.0, false, 10.0, 10.0, 14.0, false, 4.0, 10.0, 10.0, false)
	Ab_R_biceps.NodeController=
	Ab_R_biceps.NodeParent=$'Bip001 R UpperArm'
	Ab_R_biceps.relativeTransform=(matrix3 [0.801867,0.529056,0.277686] [-0.333829,0.0112454,0.942566] [0.495548,-0.848512,0.185632] [-65.1603,99.5715,109.273])
-- R Limb End--	
	
	
	
