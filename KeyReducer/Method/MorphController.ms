for i in selection do
(
	i.position.controller = position_script()
	i.pos.controller.script ="dependsOn $MorphMesh"+"\n"+"PolyOp.getVert $MorphMesh"+" "+(i.name)
)















