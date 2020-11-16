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

Try(DestroyDialog UVW_Transform) CATCH()

rollout UVW_Transform "Unwrap_UVW Transform" width:328 height:328
(
	button btn1 "Up.L 1/2" pos:[32,32] width:64 height:64 toolTip:"좌측 상단을 기준으로 선택된 UVW의 Scale을 1/2만큼 줄입니다."
	button btn2 "Up.R 1/2" pos:[232,32] width:64 height:64 toolTip:"우측 상단을 기준으로 선택된 UVW의 Scale을 1/2만큼 줄입니다."
	button btn3 "Dw.L 1/2" pos:[32,232] width:64 height:64 toolTip:"좌측 하단을 기준으로 선택된 UVW의 Scale을 1/2만큼 줄입니다."
	button btn4 "Dw.R 1/2" pos:[232,232] width:64 height:64 toolTip:"우측 하단을 기준으로 선택된 UVW의 Scale을 1/2만큼 줄입니다."
	button btn5 "Up.L 2/1" pos:[96,96] width:64 height:64 toolTip:"좌측 상단을 기준으로 선택된 UVW의 Scale을 2/1만큼 늘려줍니다."
	button btn6 "Up.R 2/1" pos:[168,96] width:64 height:64 toolTip:"우측 상단을 기준으로 선택된 UVW의 Scale을 2/1만큼 늘려줍니다."
	button btn7 "Dw.L 2/1" pos:[96,168] width:64 height:64 toolTip:"좌측 하단을 기준으로 선택된 UVW의 Scale을 2/1만큼 늘려줍니다."
	button btn8 "Dw.R 2/1" pos:[168,168] width:64 height:64 toolTip:"우측 하단을 기준으로 선택된 UVW의 Scale을 2/1만큼 늘려줍니다."
	button btn9 "LEFT" pos:[32,96] width:64 height:136 toolTip:"선택된 UVW를 0.25 만큼 좌측으로 이동 합니다."
	button btn10 "UP" pos:[96,32] width:136 height:64 toolTip:"선택된 UVW를 0.25 만큼 상단으로 이동 합니다."
	button btn11 "RIGHT" pos:[232,96] width:64 height:136 toolTip:"선택된 UVW를 0.25 만큼 우측으로 이동 합니다."
	button btn12 "DOWN" pos:[96,232] width:136 height:64 toolTip:"선택된 UVW를 0.25 만큼 하단으로 이동 합니다."
	button btn13 "U.1/2" pos:[0,32] width:32 height:264 toolTip:"좌측을 기준으로 선택된 UVW의 U Scale을 1/2만큼 줄입니다."
	button btn14 "V.1/2" pos:[32,0] width:264 height:32 toolTip:"상단을 기준으로 선택된 UVW의 V Scale을 1/2만큼 입니다."
	button btn15 "U.1/2" pos:[296,32] width:32 height:264 toolTip:"우측을 기준으로 선택된 UVW의 U Scale을 1/2만큼 줄입니다."
	button btn16 "V.1/2" pos:[32,296] width:264 height:32 toolTip:"하단을 기준으로 선택된 UVW의 V Scale을 1/2만큼 줄입니다."
	on btn1 pressed  do
	(
		$.modifiers[#unwrap_uvw].unwrap2.ScaleSelectedXY 0.5 0.5 [0,1,0]
	)
		on btn5 pressed  do
	(
		$.modifiers[#unwrap_uvw].unwrap2.ScaleSelectedXY 2.0 2.0 [0,1,0]
	)
		on btn6 pressed  do
	(
		$.modifiers[#unwrap_uvw].unwrap2.ScaleSelectedXY 2.0 2.0 [1,1,1]
	)
		on btn7 pressed  do
	(
		$.modifiers[#unwrap_uvw].unwrap2.ScaleSelectedXY 2.0 2.0 [0,0,0]
	)
		on btn8 pressed  do
	(
		$.modifiers[#unwrap_uvw].unwrap2.ScaleSelectedXY 2.0 2.0 [1,0,0]
	)
		on btn2 pressed  do
	(
		$.modifiers[#unwrap_uvw].unwrap2.ScaleSelectedXY 0.5 0.5 [1,1,1]
	)
		on btn3 pressed  do
	(
		$.modifiers[#unwrap_uvw].unwrap2.ScaleSelectedXY 0.5 0.5 [0,0,0]
	)
		on btn4 pressed  do
	(
		$.modifiers[#unwrap_uvw].unwrap2.ScaleSelectedXY 0.5 0.5 [1,0,0]
	)
		on btn12 pressed  do
	(
		$.modifiers[#unwrap_uvw].unwrap2.MoveSelected [0,-0.25,0]
	)
		on btn9 pressed  do
	(
		$.modifiers[#unwrap_uvw].unwrap2.MoveSelected [-0.25,0,0]
	)
		on btn11 pressed  do
	(
		$.modifiers[#unwrap_uvw].unwrap2.MoveSelected [0.25,0,0]
	)
		on btn10 pressed  do
	(
		$.modifiers[#unwrap_uvw].unwrap2.MoveSelected [0,0.25,0]
	)
	on btn14 pressed  do
	(
	$.modifiers[#unwrap_uvw].unwrap2.ScaleSelectedXY 1 0.5 [0.0,1.0,0]
	)
	on btn16 pressed  do
	(
	$.modifiers[#unwrap_uvw].unwrap2.ScaleSelectedXY 1 0.5 [0.0,0.0,0]
	)
	on btn15 pressed  do
	(
	$.modifiers[#unwrap_uvw].unwrap2.ScaleSelectedXY 0.5 1.0 [1.0,1.0,0]
	)
	on btn13 pressed  do
	(
	$.modifiers[#unwrap_uvw].unwrap2.ScaleSelectedXY 0.5 1.0 [0.0,0.0,0.0]
	)
)
CreateDialog UVW_Transform