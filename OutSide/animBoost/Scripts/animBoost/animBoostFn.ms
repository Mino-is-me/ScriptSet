-------------------------------------------------------------------------------
-- animBoost: funtion library v0.8
-- by Changsoo Eun
-- 0.8 : bugfix - when you unhide Mesher/Frost/SuperMesher. They are still off. 
-- 0.7 : add support for Mesher/Frost/SuperMesher
-------------------------------------------------------------------------------
global csLayersArr
fn _getLayersArr = (
	csLayersArr = for i = 0 to (LayerManager.count - 1) collect  ((layermanager.getlayer i).layerAsRefTarg)
	print("animBoost: animBoost is building a layer array.")
	csLayersArr	
)
fn _offModifierInViewport argNode = (
	for m in argNode.modifiers do (
		if m.enabledInViews == true do (
			m.enabledInViews = false 
		)
	)
)
fn _onModifierInViewport argNode = (
	for m in argNode.modifiers do (
		if m.enabledInViews == false do (
			m.enabledInViews = true 
		)
	)
)
fn _offBaseObjInViewport argNode = (
	local nodeBaseObj = argNode.baseObject
	local nodeBaseObjClass= classof nodeBaseObj
	if nodeBaseObjClass == Frost do nodeBaseObj.enableViewportMesh = false
	if nodeBaseObjClass == Mesher do nodeBaseObj.renderTimeOnly = true
	if nodeBaseObjClass == SuperMesher do nodeBaseObj.showCache = false	
)		
fn _onBaseObjInViewport argNode = (
	local nodeBaseObj = argNode.baseObject
	local nodeBaseObjClass= classof nodeBaseObj
	if nodeBaseObjClass == Frost do nodeBaseObj.enableViewportMesh = true
	if nodeBaseObjClass == Mesher do nodeBaseObj.renderTimeOnly = false
	if nodeBaseObjClass == SuperMesher do nodeBaseObj.showCache = true	
)	
fn _getGeomDependents argNode = (
	local dependentsArr= refs.dependents argNode
	local geomDependants = for o in dependentsArr where ((superclassof o) == GeometryClass ) collect o --GeometryClass
-- 	print(dependentsArr)
-- 	print(argNode.name)
-- 	print(geomDependants)
	geomDependants	
)
fn _IsAnMemberInSet argSetArr argMembersArr = (
	local foundMember = false
	for mb in argMembersArr while not foundMember do (
		if (findItem argSetArr mb) > 0 do foundMember = true
	)
	foundMember
)
fn _modifierOnOffCore argSets argNode argModeBool = (
	local NodesDependantsArr = #()
	NodesDependantsArr = (_getGeomDependents argNode)
	
	if argModeBool == false then(
		if (_IsAnMemberInSet argSets NodesDependantsArr) == false do(
			_offModifierInViewport argNode
			_offBaseObjInViewport	argNode
		)
	)
	else(
		if (_IsAnMemberInSet argSets NodesDependantsArr) == true do(
			_onModifierInViewport argNode
			_onBaseObjInViewport	argNode			
		)
	)
	
)
fn _modifierSelectiveOff = (
	local allVisibleNds = for o in objects where not o.isHiddenInVpt collect o
	
	local hiddenNds = for o in geometry where o.isHiddenInVpt collect o
	for o in hiddenNds do (
-- 		if o.modifiers.count > 0 do (
			if allVisibleNds.count == 0 then(
				_offModifierInViewport o
				_offBaseObjInViewport	o
			)
			else(
				_modifierOnOffCore allVisibleNds o false
			)
-- 		)
	)
	
	for n in allVisibleNds do (
		_onModifierInViewport n
		_onBaseObjInViewport	n
	)
)
fn _modifierSelectiveOn argTargetArr = ( 
	for n in argTargetArr do (
		_onModifierInViewport n
		_onBaseObjInViewport	n			
	)
	
	local hiddenNds = for o in geometry where o.isHiddenInVpt collect o
	for o in hiddenNds do (
-- 		if o.modifiers.count > 0 do (
			_modifierOnOffCore argTargetArr o true
-- 		)
	)
)

_modifierSelectiveOff()
print("animBoost: animBoost function loaded.")