global ar_keyFrames = #()

selectedKeyOption = 1

fn getSelectedKeys bSelectedBones = /* input1->BoneObject */
(
	for i=1 to bSelectedBones.controller.keys.count do
	(
		if (isKeySelected bSelectedBones.controller i) == true do
		(
			temp = filterString ((bSelectedBones.controller.keys[i]) as string) " "
			temp2 = substituteString temp[temp.count] ")" ""
			temp = temp2 as integer
			append ar_keyFrames temp
        )
        
	)
    sort ar_keyFrames
    
    return ar_keyFrames 
)


fn setSelectedKeys =
(
	if selectedKeyOption == 1 then
	(
		for i = 1 to ar_keyFrames.count do
		(	
			sliderTime = ar_keyFrames[i] as time
			--print ar_keyFrames[i]
			biped.setFreeKey $
		)
	)
	else if selectedKeyOption == 2 then
	(
		for i = 1 to ar_keyFrames.count do
		(	
			sliderTime = ar_keyFrames[i] as time
			--print ar_keyFrames[i]
			biped.setSlidingKey $
		)
	)
	else if selectedKeyOption == 3 then
	(
		for i = 1 to ar_keyFrames.count do
		(	
			sliderTime = ar_keyFrames[i] as time
			--print ar_keyFrames[i]
			biped.setPlantedKey $
		)
	)
)

--Try(DestroyDialog setKeyForSelected) Catch()

rollout setKeyForSelected "Set Key For Selected"
(
	Button btn_free "Free Key" across:3
	Button btn_Sliding "Sliding Key"
	Button btn_Planted "Planted Key"
	

	on btn_free pressed do 
	(
		Nodes = selection as array
		ar_keyFrames = #()
		for i in Nodes do 
		(
			select i
			getSelectedKeys $
			selectedKeyOption = 1
			setSelectedKeys()
		)

	)
	on btn_sliding pressed do 
	(
		Nodes = selection as array
		ar_keyFrames = #()
		for i in Nodes do 
		(
			select i 
			getSelectedKeys $
			selectedKeyOption = 2
			setSelectedKeys()
		)
	)
	on btn_Planted pressed do 
	(
		Nodes = selection as array
		ar_keyFrames = #()
		for i in Nodes do 
		(
			select i 
			getSelectedKeys $
			selectedKeyOption = 3
			setSelectedKeys()
		)
	)
	
)--CreateDialog setKeyForSelected