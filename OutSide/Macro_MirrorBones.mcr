/*
macroScript MirrorBones
category: "Animation Tools"
buttontext: "Mirror Bones"
tooltip: "Mirror Selected Bones"
*/
(
	on isEnabled return (selection.count != 0)
	
	on execute do
	(
		rollout MB_UI_rlt "Mirror Bones" width:162 height:246
		(
			local mb_mirroraxis = [-1,1,1]
			local mb_offset = [0,0,0]
			local mb_dir = -1
						
			fn mirrorBones bonerarr mirrorAxis:[-1, 1, 1] offset:[0, 0, 0] =
			(
				local newBoneArr = #()
				local allBoneArr = #()
				local boneArr = $
		
				fn getEndPoint a =
				(
					c=point()
					c.rotation=a.rotation
					c.pos=a.pos 
					in coordsys local move c [a.length,0,0]
					a=c.pos
					delete c
					return a
				)
				
				with redraw off
				(
					undo "Mirror Bones" on
					(
						for b in boneArr do
						(
							if (classof b.baseobject == BoneGeometry) then
							(
								local newb
								
								if b.children.count != 0 then
								(
									startPoint= (mirrorAxis*b.pos) + offset
									endpoint = (mirrorAxis*((b.children[1]).pos)) + offset
									newb=bonesys.createbone startPoint endPoint (mb_dir*(b.dir))
						
								)
								else
								(
									startPoint = (mirrorAxis*b.pos) + offset
									endpoint = (mirrorAxis*getEndPoint b) + offset
									newb = bonesys.createbone startPoint endPoint (mb_dir*(b.dir))
								)
								
								newb.width = b.width
								newb.height = b.height
								newb.taper = b.taper
								newb.sidefins = b.sidefins 
								newb.sidefinssize = b.sidefinssize
								newb.sidefinsstarttaper = b.sidefinsstarttaper
								newb.sidefinsendtaper = b.sidefinsendtaper
								newb.frontfin = b.frontfin
								newb.frontfinsize = b.frontfinsize
								newb.frontfinstarttaper = b.frontfinstarttaper
								newb.frontfinendtaper = b.frontfinendtaper
								newb.backfin = b.backfin
								newb.backfinsize = b.backfinsize 
								newb.backfinstarttaper = b.backfinstarttaper
								newb.backfinendtaper = b.backfinendtaper
								newb.name = b.name + "_mirror"
								
								if b.parent != undefined then
									append newBoneArr newB
									
								append allBoneArr newB
							)
						)
					)
					
					for b in newBoneArr do
					(
						str_ = ("$" + (replace b.name (b.name.count - 6) 7 ""))
						b.parent = execute("$" + ((execute str_).parent.name) + "_mirror")
					)
					
					for b in allBoneArr do 
						b.name = uniquename b.name
					
				)
		
			)	
	
			radiobuttons MB_UI_mirAxs "Mirror Axis" pos:[17,18] width:111 height:46 labels:#("X", "Y", "Z", "XY", "YZ", "ZX") columns:3
			radioButtons MB_UI_mirTyp "Mirror Type" pos:[17,74] width:74 height:46 labels:#("Behavior", "Orientation") columns:1
			spinner MB_UI_offset "Offset" pos:[27,133] width:77 height:16 range:[-9999,9999,0] type:#worldunits
			button MB_UI_OK "OK" pos:[15,164] width:62 height:25
			button MB_UI_Cancel "Cancel" pos:[86,164] width:62 height:25
			
					
			on MB_UI_mirAxs changed stat do
			(
				case stat of
				(
					1: mb_mirroraxis = [-1,1,1]
					2: mb_mirroraxis = [1,-1,1]
					3: mb_mirroraxis = [1,1,-1]
					4: mb_mirroraxis = [-1,-1,1]
					5: mb_mirroraxis = [1,-1,-1]
					6: mb_mirroraxis = [-1,1,-1]
				)
			)
			
			on MB_UI_mirTyp changed state do
			(
				mb_dir = if state == 1 then -1 else 1
				print mb_dir
			)
			
			on MB_UI_offset changed val do
			(
				mb_offset.x = (if mb_mirroraxis.x < 0 then val else 0.0)
				mb_offset.y = (if mb_mirroraxis.y < 0 then val else 0.0)
				mb_offset.z = (if mb_mirroraxis.z < 0 then val else 0.0)
			)
			
			on MB_UI_OK pressed do
			(
				mirrorBones $ mirroraxis:mb_mirrorAxis offset:mb_offset
				destroydialog MB_UI_Rlt
			)
			
			on MB_UI_Cancel pressed do
				destroydialog MB_UI_Rlt
		)
		
		try(destroyDialog MB_UI_Rlt)catch()
		createdialog MB_UI_rlt modal:true
	)
)
