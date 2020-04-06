-------------------------------------------------------------------------------
-- animBoost v0.8
-- by Changsoo Eun
-------------------------------------------------------------------------------
macroScript animBoost_On category:"animBoost"	toolTip:"turn on animBoost"
(
	local csAnimBoostRoot =  ((GetDir #scripts) + "\\animBoost\\")
	local csAnimBoostScriptsArr = #("animBoostFn.ms",
		"animBoostLayerOnOffChangeHandlers.ms",
		"animBoostLayerCallback.ms",
		"animBoostNodeCallback.ms"
	)

	for abstms in csAnimBoostScriptsArr do (
		filein (csAnimBoostRoot + abstms)
	)
	print ("animBoost launched!")
)