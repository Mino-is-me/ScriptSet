ar_morphNames = #()
if $CH_NPCLeftilly_Head != undefined then 
(
	morphStack = $CH_NPCLeftilly_Head.morpher
	Origin = $CH_NPCLeftilly_Teeth
	for i=1 to 52 do 
	(
		WM3_MC_SetValue morphStack i 100.0 
        local morphName = WM3_MC_GetName $CH_NPCLeftilly_Head.Morpher i
        append ar_morphNames morphName
		Copied = Copy Origin
		select Copied 

		sleep 0.1

		macros.run "Modifier Stack" "Convert_to_Poly"
		Copied.pos = [20 * i, 0, 0]
		Copied.name = morphName
		select Origin
		WM3_MC_SetValue morphStack i 0.0 
		sleep 0.1
	)
)
else 
(
	messageBox "Select Mesh" 
)


