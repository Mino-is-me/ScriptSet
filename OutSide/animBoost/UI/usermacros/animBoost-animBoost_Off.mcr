-------------------------------------------------------------------------------
-- animBoost v0.8
-- by Changsoo Eun
-------------------------------------------------------------------------------
macroScript animBoost_Off category:"animBoost"	toolTip:"turn off animBoost"
(
	deleteAllChangeHandlers id:#csAnimBoostLayerOnOffChangeHandlers
	
	csAnimBoostNodeHideChangeCallback = undefined
	gc light:true
	
	callbacks.removeScripts id:#csAnimBoostNewLayerCallback
	callbacks.removeScripts id:#animBoostFilePostOpenCallback
	callbacks.removeScripts id:#animBoostFilePostMergeCallback
	callbacks.removeScripts id:#animBoostCategoryCallback
	
	-- turn on all modifiers
	include "$Scripts\animBoost\animBoostFn.ms"
	for o in objects do (
		_onModifierInViewport o
		_onBaseObjInViewport o	
	)
	print ("animBoost removed!")
)