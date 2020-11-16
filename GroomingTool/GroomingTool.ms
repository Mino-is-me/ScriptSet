fn getelements obj=
(

	f=obj.numfaces
	eles=#()
	done=#()
	for i=1 to f do
	(
		if (finditem done i)==0 then
		(
			case (classof obj) of
			(
				editable_mesh:(faces=(meshop.getElementsUsingFace obj #(i)) as array)
				editable_poly:(faces=(polyop.getElementsUsingFace obj #(i)) as array)
			)
		append eles faces
		join done faces
		)
	)	
	return eles
)

obj = $
BB = obj.modifiers[#Skin] 
obj.modifiers[#Skin].enabled = false 

arElements = getelements obj

numBones = skinOps.GetNumberBones obj.modifiers[#Skin]


for i = 1 to arElements.count do 
(
	for j = 1 to arElements[i].count do 
	(
		for k=1 to numBones do 
		(
			if j == 1 do 
			(
				VertexWeightData = skinOps.GetVertexWeight obj.modifiers[#Skin] arElements[i][j] k
				--skinOps.SetVertexWeights obj.modifiers[#Skin] arElements[i][j] k VertexWeightData 
			)
			skinOps.SetVertexWeights obj.modifiers[#Skin] arElements[i][j] k VertexWeightData 
		)
	)
)