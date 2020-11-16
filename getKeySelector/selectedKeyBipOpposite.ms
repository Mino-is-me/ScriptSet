--global ar_keyFrames = #()

-- selectedKeyOption = 1

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
--biped.setSlidingKey $selection 


fn bipPastePosture bOpposite bnSelectedBones = /* input1->Bool input2->BoneObject*/
(
    local iNumCopy = biped.numCopies bnSelectedBones.controller #posture 
    local strPostureName = biped.getCopyName bnSelectedBones.controller #posture iNumCopy 
    biped.pastePosture bnSelectedBones.controller #posture bOpposite strPostureName 
   --  return strPostureName 
)

fn wrappedPastePostureToSelection bOpposite =/* input1->Bool*/
(
    for i in selection do 
    (
        local arKeys = getSelectedKeys i 
        
        for j=1 to arKeys.count do 
        (
            sliderTime = arKeys[j] as time 
            bipPastePosture bOpposite i 

        )

    )
)

rollout rBipCopytoSel "Biped Paster For Selected Keys"
(
	
    Button 'btn_Paste' "Paste Posture" across:2
    BUtton 'btn_PasteOpposite' "Paste Posture Opposite" 

    on btn_Paste pressed do
    (
        ar_keyFrames = #() 
        set Animate on 
        wrappedPastePostureToSelection false 
        set Animate off 
    )

    on btn_PasteOpposite pressed do
    (
        ar_keyFrames = #() 
        set Animate on
        wrappedPastePostureToSelection true 
        set Animate off 
    )

)
--createDialog 'rBipCopytoSel' 400 100