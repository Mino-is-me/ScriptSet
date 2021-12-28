for i=1 to 58 do 
(
	local expose = dummy()
	expose.boxSize = [0.1,0.1,0.1]
	expose.pos.controller = position_script()
	sleep 0.1
	expose.pos.controller.addconstant "Base" $Base
	sleep 0.1
	expose.pos.controller.script = "polyOp.getVert Base " + (PolyArray[i] as string)
	sleep 0.1
)


for i=1 to selection.count do 
(
	selection[i].name = (i+29) as string
)


for i=1 to 58 do 
(
	AA=getnodebyname (i as string)
	Apos = AA.pos
	polyop.setVert $ i Apos
)
