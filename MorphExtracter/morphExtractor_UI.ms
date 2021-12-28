global points = #()

fn getNumMorpher Base = -- count number of morph targets
(
    local morphModi = Base.Morpher

    for i=1 to 100 do 
    (
        local isValidMorphName = WM3_MC_GetName morphModi i
        if isValidMorphName == "- empty -" then exit with return (i-1)

    )

)

select BaseNode 
        
morphcnt = getNumMorpher $
morphstack = $.morpher


undo on
(
	with animate on 
	(
		for i=1 to morphcnt do 
		(
			sliderTime = i 
			(
				for j=1 to morphcnt do 
				(
					if i == j then
					(
						WM3_MC_SetValue morphStack j 100.0 
						morphName = WM3_MC_GetName morphStack j

					)
					else 
					(
						WM3_MC_SetValue morphStack j 0.0

					)
				)
			)
			local copied = copy DeformNode 
			copied.name = morphName
			select copied 
			macros.run "Modifier Stack" "Convert_to_Poly"
			$.pos = [20*i,0,20]
			deleteKeys $
		)
	)
)

sliderTime = 0f