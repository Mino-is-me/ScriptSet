Global Kinda 
Global NodeName
Global NodeProperties
Global NodeParent
Global relativeTransform
Global PosController
Global PosVarName = #() 
Global PosVarValue  = #() 
Global PosScript 
Global RotController
Global RotVarName = #()
Global RotVarValue = #() 
Global RotScript 
Global SclController
Global SclVarName =#()
Global SclVarValue =#() 
Global SclScript 


for i in selection do 
(
	obj = $

	obj_Name = substituteString $.name " " "_"

	if ( classof obj ) == BoneGeometry then 
	(
		kinda = obj_Name + "." + "KindaNode" + "=" + "bonsys.createBone [0,0,1] [0,0,0] [1,0,0]" 
	)
	else if ( classof obj ) == Point then 
	(
		kinda = obj_Name + "." + "KindaNode" + "=" + "Point()" 
	)
	else if ( classof obj ) == Dummy then 
	(
		kinda = obj_Name + "." + "KindaNode" + "=" + "Dummy()" 
	)
	-- RigNode Properties 수집 
	arProperties = getPropNames obj
	arPropValues = #()
	for i=1 to arProperties.count do 
	(
		append arPropValues (getProperty obj arProperties[i])
	)
	print "----------"
	NodeName = obj_Name + "." + "NodeName" + "=$'" + obj.name + "'"

	NodeProperties = obj_Name + "." + "NodeProperties" + "=" + ( arPropValues as string ) 

	NodeParent = obj_Name + "." + "NodeParent" + "=$'" + obj.parent.name + "'"

	relativeTransform = obj_Name + "." + "relativeTransform" + "=" + ((inverse obj.transform * obj.parent.transform) as string) 
	print "----------"
	-- 수집 완료 

	PosController = obj_Name + "." + "PosController" + "=" + (obj.pos.controller as String) + "()"

	isPosScript = isKindOf obj.position.controller position_Script 
	if isPosScript == true then  
	(
		PosScript = obj.position.controller.Script
		posNumVar = obj.position.controller.NumVariables() 
		for i=5 to posNumVar do 
		(
			local valueName = $.position.controller.getName i 
			local valueVar = $.position.controller.getValue valueName  
			append arPosValueName valueName 
			append arPosValueVar valueVar 
		)
	)






	arProperties = getPropNames obj
	for i=1 to arPropValues.count do 
	(
		setProperty obj arProperties[i] arPropValues[i] 
	)



	arPositionContraintTarget = #() 
	arPositionConstraintWeight = obj.pos.controller.weight
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
	arOrienationConstraintWeight = obj.rotation.controller.weight
	for i=1 to 5 do 
	(
		local target = obj.rotation.controller.getNode i
		if target != undefined do 
		(
			append arOrientationContraintTargets target 
		)
		arOrientationContraintTargets.count 
	)
)