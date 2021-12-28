select $*end 

endBones = #()
endBoneParents  = #()

endBones = selection as array 

endBoneParents = for i=1 to endbones.count collect endBones[i].parent 

--endBoneParentTMRow1 = for i=1 to endBoneParents.count collect edBoneParents[i].stretchTM.row1 

endBoneParentTMRow1Xs = #()


-------------------------Stretch Transform Hooking Complete------------------------------------------
for i=1 to endBoneParents.count do
(
	endBoneParentTMRow1Xs[i] = #()
)


/*
for i=1 to endBoneParents.count do 
(
    append endBoneParentTMRow1Xs[i] endBoneParents[i].stretchTM.row1.x
)
*/
cnt = 1 

SliderTime = AnimationRange.start 
for j=animationRange.start to animationRange.end do 
(
		SliderTIme = j 
		for i=1 to endBoneParentTMRow1Xs.count do 
		(
			append endBoneParentTMRow1Xs[i] endBoneParents[i].stretchTM.row1.x
		)
)
-------------------------Stretch Transform Hooking Complete------------------------------------------

-------------------------Modify Bone Scale-------------------------------------------------------

undo on 
(
	delete endBones 


	SliderTIme = animationRange.start 
	with animate on 
	(
		cnt = 1
		for j=animationRange.start to animationRange.end do 
		(
			SliderTIme = j 
			for i=1 to endBoneParents.count do 
			(
				endBoneParents[i].scale = endBoneParents[i].scale * endBoneParentTMRow1Xs[i][cnt]

			)
			cnt = cnt + 1 
		)
	)
)
-------------------------Modify Bone Scale-------------------------------------------------------