ar_keyFrames = #()

selectedKeyOption = 0

fn getSelectedKeys =
(
	for i=1 to $.controller.keys.count do
	(
		if (isKeySelected $.controller i) == true do
		(
			temp = filterString (($.controller.keys[i]) as string) " "
			temp2 = substituteString temp[temp.count] ")" ""
			temp = temp2 as integer
			append ar_keyFrames temp
		)
	)
	sort ar_keyFrames
)
--biped.setSlidingKey $selection 


fn setSelectedKeys =
(
	if selectedKeyOption == 1 then
	(
		for i = 1 to ar_keyFrames.count do
		(	
			sliderTime = ar_keyFrames[i] as time
			print ar_keyFrames[i]
			biped.setFreeKey $
		)
	)
	else if selectedKeyOption == 2 then
	(
		for i = 1 to ar_keyFrames.count do
		(	
			sliderTime = ar_keyFrames[i] as time
			print ar_keyFrames[i]
			biped.setSlidingKey $
		)
	)
	else if selectedKeyOption == 3 then
	(
		for i = 1 to ar_keyFrames.count do
		(	
			sliderTime = ar_keyFrames[i] as time
			print ar_keyFrames[i]
			biped.setPlantedKey $
		)
	)
)

Try(DestroyDialog setKeyForSelected) Catch()

rollout setKeyForSelected "Set Key For Selected"
(
	dropdownlist ddl_keyOption "Key Option" items:#("Free Key", "Sliding Key", "Planted Key")
	Button btn_setKey "Set Keys to Seletion"
	
	on ddl_keyOption selected i do
	(
		print ddl_keyOption.items[i]
		selectedKeyOption = i
	)
	
	on btn_setKey pressed do
	(
		getSelectedKeys()
		setSelectedKeys()
	)
	
)CreateDialog setKeyForSelected