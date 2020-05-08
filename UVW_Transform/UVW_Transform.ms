fn getThisDir =
	(
		local This = getThisScriptFilename()
		thisPath = getFileNamePath This
		
		return thisPath
	)

	Global this = getThisDir() + "\\image\\"
	Global iUVDivider = 2

	obj  = (selection as array)[1]

	if obj != undefined then
	(
		Max Modify Mode
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
		Try ( obj.modifiers[UVW_modifierID].edit() ) Catch()

		try(destroyDialog UVW_Trans) Catch()

		rollout UVW_Trans "UVW_Transform" width:352 height:400
		(
			groupBox 'grp1' "" pos:[8,8] width:160 height:168 align:#left 
			button 'btn27' "Button" pos:[16,24] width:72 height:72 align:#left images:#(This+"Scale02_2.png", undefined, 1,1,1,1,1)
			button 'btn28' "Button" pos:[88,24] width:72 height:72 align:#left images:#(This+"Scale02_1.png", undefined, 1,1,1,1,1)
			button 'btn29' "Button" pos:[16,96] width:72 height:72 align:#left images:#(This+"Scale02_3.png", undefined, 1,1,1,1,1)
			button 'btn30' "Button" pos:[88,96] width:72 height:72 align:#left images:#(This+"Scale02_4.png", undefined, 1,1,1,1,1)
			groupBox 'grp2' "" pos:[176,8] width:160 height:168 align:#left 
			button 'btn31' "Button" pos:[184,24] width:72 height:72 align:#left images:#(This+"Scale01_2.png", undefined, 1,1,1,1,1)
			button 'btn32' "Button" pos:[256,24] width:72 height:72 align:#left images:#(This+"Scale01_1.png", undefined, 1,1,1,1,1)
			button 'btn33' "Button" pos:[184,96] width:72 height:72 align:#left images:#(This+"Scale01_3.png", undefined, 1,1,1,1,1)
			button 'btn34' "Button" pos:[256,96] width:72 height:72 align:#left images:#(This+"Scale01_4.png", undefined, 1,1,1,1,1)
			groupBox 'grp3' "" pos:[8,184] width:160 height:168 align:#left 
			button 'btn35' "Button" pos:[16,200] width:72 height:72 align:#left images:#(This+"Scale03_3.png", undefined, 1,1,1,1,1)
			button 'btn36' "Button" pos:[88,200] width:72 height:72 align:#left images:#(This+"Scale03_1.png", undefined, 1,1,1,1,1)
			button 'btn37' "Button" pos:[16,272] width:72 height:72 align:#left images:#(This+"Scale03_4.png", undefined, 1,1,1,1,1)
			button 'btn38' "Button" pos:[88,272] width:72 height:72 align:#left images:#(This+"Scale03_2.png", undefined, 1,1,1,1,1)
			groupBox 'grp4' "" pos:[176,184] width:168 height:168 align:#left
			button 'btn39' "Button" pos:[224,200] width:72 height:40 align:#left images:#(This+"move_2.png", undefined, 1,1,1,1,1) --toolTip:"���õ� UVW�� 0.25 ��ŭ ������� �̵� �մϴ�."
			button 'btn43' "Button" pos:[184,235] width:40 height:72 align:#left images:#(This+"move_4.png", undefined, 1,1,1,1,1)
			button 'btn44' "Button" pos:[224,304] width:72 height:40 align:#left images:#(This+"move_1.png", undefined, 1,1,1,1,1)
			button 'btn45' "Button" pos:[296,235] width:40 height:72 align:#left images:#(This+"move_3.png", undefined, 1,1,1,1,1)
			label 'lb1' "MOVE" pos:[245,265]
			Spinner 'divider' "Scaling Divider 1 / : " pos:[16,370] range:[1,10,2] type:#integer

			on divider changed val do 
			(
				iUVDivider = val as float 
			)
			
			/*DownScale diagonal Group*/
			on btn27 pressed do
			(
				$.modifiers[#unwrap_uvw].unwrap2.ScaleSelectedXY (1.0/iUVDivider) (1.0/iUVDivider) [0,1,0]
			)
			on btn28 pressed do
			(
				$.modifiers[#unwrap_uvw].unwrap2.ScaleSelectedXY (1.0/iUVDivider) (1.0/iUVDivider) [1,1,1]
			)
			on btn29 pressed do
			(
				$.modifiers[#unwrap_uvw].unwrap2.ScaleSelectedXY (1.0/iUVDivider) (1.0/iUVDivider) [0,0,0]
			)
			on btn30 pressed do
			(
				$.modifiers[#unwrap_uvw].unwrap2.ScaleSelectedXY (1.0/iUVDivider) (1.0/iUVDivider) [1,0,0]
			)
			/*DownScale diagonal Group*/
			
			
			/*UpScale diagonal Group*/
			on btn31 pressed do
			(
				$.modifiers[#unwrap_uvw].unwrap2.ScaleSelectedXY (1.0*iUVDivider) (1.0*iUVDivider) [0,1,0]
			)
			on btn32 pressed do
			(
				$.modifiers[#unwrap_uvw].unwrap2.ScaleSelectedXY (1.0*iUVDivider) (1.0*iUVDivider) [1,1,1]
			)
			on btn33 pressed do
			(
				$.modifiers[#unwrap_uvw].unwrap2.ScaleSelectedXY (1.0*iUVDivider) (1.0*iUVDivider) [0,0,0]
			)
			on btn34 pressed do
			(
				$.modifiers[#unwrap_uvw].unwrap2.ScaleSelectedXY (1.0*iUVDivider) (1.0*iUVDivider) [1,0,0]
			)
			/*UpScale diagonal Group*/
			
			
			/*DownScale Horizontal Group*/
			on btn35 pressed  do
			(
				$.modifiers[#unwrap_uvw].unwrap2.ScaleSelectedXY 0.5 1.0 [1.0,1.0,0]
			)
			on btn36 pressed  do
			(
				$.modifiers[#unwrap_uvw].unwrap2.ScaleSelectedXY 1 0.5 [0.0,1.0,0]
			)
			on btn37 pressed  do
			(
				$.modifiers[#unwrap_uvw].unwrap2.ScaleSelectedXY 0.5 1.0 [0.0,0.0,0.0]
			)
			on btn38 pressed  do
			(
				$.modifiers[#unwrap_uvw].unwrap2.ScaleSelectedXY 1 0.5 [0.0,0.0,0]
			)
			/*DownScale Horizontal Group*/
			
			
			/* Move Group */
			on btn39 pressed  do
			(
				$.modifiers[#unwrap_uvw].unwrap2.MoveSelected [0,(0.5/iUVDivider),0]
			)
				on btn43 pressed  do
			(
				$.modifiers[#unwrap_uvw].unwrap2.MoveSelected [(-0.5/iUVDivider),0,0]
			)
				on btn44 pressed  do
			(
				$.modifiers[#unwrap_uvw].unwrap2.MoveSelected [0,(-0.5/iUVDivider),0]
			)
				on btn45 pressed  do
			(
				$.modifiers[#unwrap_uvw].unwrap2.MoveSelected [(0.5/iUVDivider),0,0]
			)
			/* Move Group */
		)

		Try( DestroyDialog UVW_Trans) Catch()
		CreateDialog UVW_Trans
	)
	else 
	(
		MessageBox "Please Select One More Editable Poly or Editable Mesh"
	)