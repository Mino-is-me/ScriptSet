--macroScript SelectUVW category:"SelectUVW"

	local SelectUVW_path = (getdir #scripts) + "\\Select_UVW\\Select_UVW_Transform.ms"
	local obj  = (selection as array)[1]
	local UVW_modifierID = 0
	for i=1 to obj.modifiers.count do
	(
		local current_modifier = obj.modifiers[i]
		if classof current_modifier == Unwrap_UVW do UVW_modifierID = i
	)
	if UVW_modifierID == 0 do
	(
		addModifier obj (Unwrap_UVW ())
		UVW_modifierID = 1
	)
	obj.modifiers[UVW_modifierID].edit()
	filein SelectUVW_path 
--end script