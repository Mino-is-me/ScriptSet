-------------------------------------------------------------------------------
-- animBoost: event callbacks v0.8
-- by Changsoo Eun
-------------------------------------------------------------------------------
reload_animBoostLayerOnOffChangeHandlers = ((GetDir #scripts) + "\\animBoost\\animBoostLayerOnOffChangeHandlers.ms")

callbacks.removeScripts id:#csAnimBoostNewLayerCallback
callbacks.addScript #layerCreated "filein reload_animBoostLayerOnOffChangeHandlers" id:#csAnimBoostNewLayerCallback
print "animBoost: csAnimBoostNewLayerCallback added!"


callbacks.removeScripts id:#animBoostFilePostOpenCallback
callbacks.addScript #filePostOpen  "filein reload_animBoostLayerOnOffChangeHandlers" id:#animBoostFilePostOpenCallback
print "animBoost: animBoostFilePostOpenCallback added!"

callbacks.removeScripts id:#animBoostFilePostMergeCallback
callbacks.addScript #filePostMerge  "filein reload_animBoostLayerOnOffChangeHandlers" id:#animBoostFilePostMergeCallback
print "animBoost: animBoostFilePostMergeCallback added!"

callbacks.removeScripts id:#animBoostCategoryCallback
callbacks.addScript #byCategoryDisplayFilterChanged  "_modifierSelectiveOff()" id:#animBoostCategoryCallback
print "animBoost: animBoostCategoryCallback added!"


