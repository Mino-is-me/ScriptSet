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
 
ar_eles = getelements selection[1]