/*macroScript AttachToVertices 
category: "GregoryMaxScript"
buttonText:"AttachToVertices"
icon: #("SW_DynInt", 1)
tooltip: "Attact To Selected Vertices"
*/
(

try DestroyDialog AttachToVertex catch()

rollout AttachToVertex "AttachToVertices" (
	
	local baseGeo 
	
	
   group"Attach"(
	pickbutton PO "Pick Object..." width:120 height:50 tooltip:"Object to attach"
	button ATC "Attach" width:120 height:50 tooltip:"Attach To Selected Vertices"
   )
   
	 button Help "How To Use :)" tooltip:"Help" width:120 height:40
	
	on Help pressed do messagebox "1) Pick Object To Attach. 2) Select Vertices. 3) Click Attach Button" beep:false title: "Help"
	on PO picked obj do (baseGeo = obj; PO.caption = baseGeo.name)
	
	
	on ATC pressed do (
		

	undo on 	(
		
		
								if selection.count==1 then (
									
									
										if classof $ == Editable_Poly then (
											
											if baseGeo!=undefined then (
												
											
												
														numSel = PolyOp.getVertSelection $ as array
														
														  if numSel.count>0 then (
															  
															  
															  if 	baseGeo.isdeleted == true then (PO.caption =="Pick Object...") else (
															  
															  p = point pos:($.pos-10) box:on wirecolor:red
															  
																	  for i = 1 to numSel.count do (
																		  
										
																		  d = instance p 
																		  d.scale.controller = p.scale.controller
																		  d.rotation.controller = p.rotation.controller
																		  d.wirecolor = blue
																		  d.position.controller = position_script()
																	      d.pos.controller.script = ("dependsOn "+"$"+$.name+"\n"+"PolyOp.getVert "+"$"+$.name+" "+(numSel[i] as string))
																	      Geo = instance baseGeo
																		  Geo.pos = d.pos	
																	      Geo.parent = d
																	  
																	  )
																	  
																  )
													
														  ) else messagebox "Select Vertices!" beep:true title:"Vertex Selection"
													  )
										) 
										
										
										if classof $ == Editable_Mesh then (
											
											if baseGeo!=undefined then (
												
											
												        nv = $.selectedVerts.count
												        numSel = #()
												
												
													for i = 1 to nv do	(numSel[i] = $.selectedVerts[i].index)
														
														  if numSel.count>0 then (
															  
															  
															  if 	baseGeo.isdeleted == true then (PO.caption =="Pick Object...") else (
															  
															  p = point pos:($.pos-10) box:on wirecolor:red
															  
																	  for i = 1 to numSel.count do (
																		  
										
																		  d = instance p 
																		  d.scale.controller = p.scale.controller
																		  d.rotation.controller = p.rotation.controller
																		  d.wirecolor = blue
																		  d.position.controller = position_script()
																	      d.pos.controller.script = ("dependsOn "+"$"+$.name+"\n"+"MeshOp.getVert "+"$"+$.name+" "+(numSel[i] as string))
																	      Geo = instance baseGeo
																		  Geo.pos = d.pos	
																	      Geo.parent = d
																	  
																	  )
																	  
																  )
													
														  ) else messagebox "Select Vertices!" beep:true title:"Vertex Selection"
													  )
										) 										
										
								
								
								) else messagebox "Select one object!" beep:false title:"Selection"
								
								
							)		
	
	
	)
	
	
) CreateDialog AttachToVertex 


)