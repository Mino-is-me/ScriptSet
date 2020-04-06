-------------------------------------------------------------------------------
-- animBoost: change handler for layer v0.8
-- by Changsoo Eun
-------------------------------------------------------------------------------
_getLayersArr()
deleteAllChangeHandlers id:#csAnimBoostLayerOnOffChangeHandlers
when parameters csLayersArr changes id:#csAnimBoostLayerOnOffChangeHandlers layer do (
-- 	local a = timestamp()
	layer.nodes &csTargetNodes
	setWaitCursor() 
	if layer.isHidden == true then(
		_modifierSelectiveOff()
	)
	else
	(
		_modifierSelectiveOn csTargetNodes
	)
	setArrowCursor()
-- 	print(timestamp() - a)
)
print "animBoost: csAnimBoostLayerOnOffChangeHandlers launched!"
_modifierSelectiveOff()
