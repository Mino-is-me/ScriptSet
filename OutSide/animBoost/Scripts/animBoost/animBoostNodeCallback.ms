-------------------------------------------------------------------------------
-- animBoost: node event callbacks v0.8
-- by Changsoo Eun
-------------------------------------------------------------------------------
fn csAnimBoostNodeHideChangeCallbackFn ev nd = (
-- 	local a = timestamp()
	setWaitCursor() 
	_modifierSelectiveOff()
	redrawViews() 	 
	setArrowCursor() 
-- 	print(timestamp() - a)
)
csAnimBoostNodeHideChangeCallback = undefined
gc light:true
csAnimBoostNodeHideChangeCallback = NodeEventCallback hideChanged:csAnimBoostNodeHideChangeCallbackFn
print "animBoost: csAnimBoostNodeHideChangeCallback launched!"




