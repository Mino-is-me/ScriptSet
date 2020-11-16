FN AnimationDataTo_ExPose =
(
	
	Set AniMate On
	AnimRange = AnimationRange.end As String
	int_AnimRange = AnimRange As Integer
	for i in selection do
	(
		Expose = ExposeTM Size:7 Cross:off AxisTripod:on
		Expose.parent = undefined 
		for j=0 to int_AnimRange do
		(
			SliderTime = j
			Expose.transform = i.transform
			--Expose.parent = i.parent
			Expose.name = i.name + "_expose"
			Expose.exposeNode = i.parent 
		)
	)
)

FN Adoption_animData =
(
	AnimRange = AnimationRange.end As String
	int_AnimRange = AnimRange As Integer
	Set Animate On
	for i in selection do
	(
		ExposeTMs = GetNodeByName (i.name as string + "_expose")
		for j=0 to int_AnimRange do
		(
			SliderTime = j
			i.transform = ExposeTMs.transform 
		)
	)
)

Try(DestroyDialog AniAdopt) Catch()

Rollout AniAdopt "Animation Adopter"
(
	Button btn_makeExTM "Make Expose TM" across:2
	Button btn_setEXTM "Set Expose TM"
	
	on btn_makeExTM pressed do
	(
		AnimationDataTo_ExPose()
	)
	on btn_setEXTM pressed  do 
	(
		Adoption_animData()
	)
	
)CreateDialog AniAdopt 250 30