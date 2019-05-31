fn getThisDir =
(
	local This = getThisScriptFilename()
	thisPath = getFileNamePath This
	
	return thisPath
)

Global this = getThisDir()

obj  = (selection as array)[1]
UVW_modifierID = 0
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

Try(DestroyDialog UVW_Transform) Catch()
rollout UVW_Transform "UVW_Trans" width:281 height:281
(
	button  btn2 "Button" pos:[10,5] width:72 height:72 align:#left images:#(This+"Scale02_2.png", undefined, 1,1,1,1,1)
	button btn3 "Button" pos:[75,5] width:64 height:64 align:#left images:#(This+"Scale02_1.png", undefined, 1,1,1,1,1)
	button btn4 "Button" pos:[10,70] width:64 height:64 align:#left images:#(This+"Scale02_3.png", undefined, 1,1,1,1,1)
	button btn5 "Button" pos:[75,70] width:64 height:64 align:#left images:#(This+"Scale02_4.png", undefined, 1,1,1,1,1)
	button btn10 "Button" pos:[145,5] width:64 height:64 align:#left images:#(This+"Scale01_2.png", undefined, 1,1,1,1,1)
	button btn11 "Button" pos:[210,6] width:64 height:64 align:#left images:#(This+"Scale01_1.png", undefined, 1,1,1,1,1)
	button btn12 "Button" pos:[145,71] width:64 height:64 align:#left images:#(This+"Scale01_3.png", undefined, 1,1,1,1,1)
	button btn13 "Button" pos:[210,71] width:64 height:64 align:#left images:#(This+"Scale01_4.png", undefined, 1,1,1,1,1)
	button btn18 "Button" pos:[11,140] width:64 height:64 align:#left images:#(This+"Scale03_3.png", undefined, 1,1,1,1,1)
	button btn19 "Button" pos:[76,141] width:64 height:64 align:#left images:#(This+"Scale03_1.png", undefined, 1,1,1,1,1)
	button btn20 "Button" pos:[11,206] width:64 height:64 align:#left images:#(This+"Scale03_4.png", undefined, 1,1,1,1,1)
	button btn21 "Button" pos:[76,206] width:64 height:64 align:#left images:#(This+"Scale03_2.png", undefined, 1,1,1,1,1)
	button btn22 "Button" pos:[180,140] width:64 height:32 align:#left images:#(This+"move_2.png", undefined, 1,1,1,1,1)
	button btn23 "Button" pos:[180,240] width:64 height:32 align:#left images:#(This+"move_1.png", undefined, 1,1,1,1,1)
	button btn24 "Button" pos:[245,175] width:32 height:64 align:#left images:#(This+"move_3.png", undefined, 1,1,1,1,1)
	button btn25 "Button" pos:[145,175] width:32 height:64 align:#left images:#(This+"move_4.png", undefined, 1,1,1,1,1)
)
CreateDialog UVW_Transform



