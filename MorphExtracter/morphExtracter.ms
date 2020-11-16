

fn extractOmake  morphname morphpos bDo=
(
	if bDo do 
	(
		for i in omakes do
		( 
			copied = copy i 
			select copied
			macros.run "Modifier Stack" "Convert_to_Poly"
			Copied.pos = morphpos
			Copied.name = morphName

		)
		select Origin
	)
)

ar_morphNames = #()
if $ != undefined then 
(
	morphStack = $.morpher
	Origin = $
	for i=1 to 52 do 
	(
		WM3_MC_SetValue morphStack i 100.0 
        local morphName = WM3_MC_GetName $.Morpher i
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

		extractOmake morphName Copied.pos  false 
	)
)
else 
(
	messageBox "Select Mesh" 
)

/*
sleep 0.1 

select Origin 

macros.run "Modifier Stack" "Convert_to_Poly"
sleep 0.1 

modPanel.addModToSelection (Morpher ()) ui:on



for i=1 to ar_morphNames.count do 
(
    WM3_MC_BuildFromNode Origin.morpher i ar_morphNames[i]

)*/