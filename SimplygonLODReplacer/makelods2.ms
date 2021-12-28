(




	try(destroyDialog roll_makeLODs )catch()
	
	global LODobject_Name = try($.name)catch(LODobject_Name="object to LOD")
	
				if (isSceneRedrawDisabled() == true) do
		(
			enableSceneRedraw()
			)
	clearListener()
			
			valUp = 0
						global canWeGo = false
						global detected = false
			global arr_makeLODs = #(true, true, true, true, false)
			global arr_lodVal = #(100, 75, 50, 25, 15)
						global workObject = try($)catch()
						global tempObject
						global arr_lodObjects = #()
			global arr_lodObjectsNames =#()
			global lodObjectStartVerts =0
			global arr_lodObjectsEndVerts = #()
			global lodObjectStartFaces = 0
			global arr_lodObjectsEndFaces = #()
			
			
			
						global debugTitle = "..."
						global labelDebugText = ("How to use:\n1. Select object you want to make LODs for. Should be editable_poly. \n"  + 
															"2. Click on GET OBJECT TO MAKE LODS button. \n"  +
															"3. Set desired settings, adjust LOD percentages if needed. \n"  +
															"4. Click ITS GO TIME to start generation process. \n" +
															"Unless you unchecked backup option, if something go wrong, \nyou can restore by using right button. \n"    							
							
							
							
							)			
			
			

			
		rollout roll_makeLODs "makeLODs 0.3" width:410 height:710
	(
		label lbl1 "LOD Object:" align:#left
		edittext edt_LODobject "" text:LODobject_Name
		button btn_GetObject "Get Object to make LODs" pos:[25,50]
		checkbox cbx_makeCopy "Work on copy?" checked:true tooltip:"Will create copy of current model, hide it and add _LOD0 to duplicate name." pos:[185,55]
		checkbox cbx_makeBackup "Backup scene?" checked:true tooltip:"Will create copy of current scene just in case something go wrong. In case of fail, run  this script again, and hit RESTORE." pos:[285,55]
		checkbox cbx_triangulate "Triangulate?" checked:false tooltip:"Will triangulate model after LOD creation." pos:[10,240]
		checkbox cbx_autosmooth "Autosmooth?" checked:true tooltip:"Will autosmooth with desired angle after LOD creation." pos:[150,240]
		spinner autosmooth_spinner "Autosmooth angle" enabled: true range:[0,180,33] type:#integer pos:[240,241] fieldwidth:40 toolTip:"Set percentage  of original mesh triangles."
		
		slider percentage_slider1 "LOD0" orient:#vertical ticks:15 range: [0,100,100] pos:[10,80] type:#float toolTip:"Set percentage  of original mesh triangles."
		slider percentage_slider2 "LOD1" orient:#vertical ticks:15 range: [0,100,75] pos:[80,80] type:#float toolTip:"Set percentage  of original mesh triangles."
		slider percentage_slider3 "LOD2" orient:#vertical ticks:15 range: [0,100,50] pos:[150,80]  type:#float toolTip:"Set percentage  of original mesh triangles."
		slider percentage_slider4 "LOD3" orient:#vertical ticks:15 range: [0,100,25] pos:[220,80]  type:#float toolTip:"Set percentage  of original mesh triangles."
		slider percentage_slider5 "LOD4" orient:#vertical ticks:15 range: [0,100,15] pos:[290,80] type:#float toolTip:"Set percentage  of original mesh triangles."
		
		spinner percentage_spinner1 "" range:[0,100,100] type:#float pos:[10,180] fieldwidth:40 toolTip:"Set percentage  of original mesh triangles."
		spinner percentage_spinner2 "" range:[0,100,75] type:#float pos:[80,180] fieldwidth:40 toolTip:"Set percentage  of original mesh triangles."
		spinner percentage_spinner3 "" range:[0,100,50] type:#float pos:[150,180] fieldwidth:40 toolTip:"Set percentage  of original mesh triangles."
		spinner percentage_spinner4 "" range:[0,100,25] type:#float pos:[220,180] fieldwidth:40 toolTip:"Set percentage  of original mesh triangles."
		spinner percentage_spinner5 "" range:[0,100,15] type:#float pos:[290,180] fieldwidth:40 toolTip:"Set percentage  of original mesh triangles."
		
		button btn_defaults "Default Values" checked:false pos:[340, 100] width:60 height:60 tooltip:"Enable // Disable LOD creation of this level."
		checkbutton cbx_is_enable_1 "-LOD0-" checked:true pos:[10, 200] tooltip:"Enable // Disable LOD creation of this level."
		checkbutton cbx_is_enable_2 "-LOD1-" checked:true pos:[80, 200] tooltip:"Enable // Disable LOD creation of this level."
		checkbutton cbx_is_enable_3 "-LOD2-" checked:true pos:[150, 200] tooltip:"Enable // Disable LOD creation of this level."
		checkbutton cbx_is_enable_4 "-LOD3-" checked:true pos:[220, 200] tooltip:"Enable // Disable LOD creation of this level."
		checkbutton cbx_is_enable_5 "-LOD4-" checked:false pos:[290, 200] tooltip:"Enable // Disable LOD creation of this level."
		
		button btn_makeLODs "ITS GO TIME" checked:false pos:[150, 280] width:100 height:100 tooltip:"MAKE LODS!"
		button btn_restore "restore scene" checked:false pos:[250, 280] width:50 height:50 tooltip:"restore scene from previously fetched backup."
		button btn_deleteLODs "delete LODs" checked:false pos:[250, 330] width:50 height:50 tooltip:"restore scene from previously fetched backup."
		
		
	
		label debugLog "..." fieldWidth:400 height:240 labelOnTop:false pos:[25, 430] align:#left enabled:true
		label labelDebug "Debug log:" pos:[25,410] align:#left enabled:true
		label label6 "" pos:[10, 410] align:#middle enabled:true
		label label7 "pro.piro@gmail.com for IronbellyStudios" pos:[10,690] align:#left enabled:false

		
		
	    timer clock20 "testClock" interval:250 -- 10 sekund (10 000 ms)
		
		
		fn fn_checkForWorkingObject =
(
	if detected == false do
	(
		if workObject != undefined then
		(
			btn_makeLODs.enabled=true
detected = true
			)
		else  
			(
				btn_makeLODs.enabled=false
			)
	)
	
	)
	
	fn fn_getOriginalMeshData obj =
	(
			lodObjectStartVerts =(polyop.getNumVerts obj ) as float

			lodObjectStartFaces =(polyop.getNumFaces obj) as float
	)
	
		fn fn_backupOriginalMesh obj =
		(
			result = #()

maxOps.cloneNodes workObject offset:[0,0,0] cloneType:#copy actualNodeList:#() newNodes:&result
tempObject = result[1]
					tempObject.name = (workObject.name + "_org")
					labelDebugText = ("Mesh copied as: " + tempObject.name as string )
			)
			
fn fn_copyOriginalMesh index =
(
				resultLOD = #()
maxOps.cloneNodes workObject offset:[0,0,0] cloneType:#copy actualNodeList:#() newNodes:&resultLOD[index]
arr_lodObjects[index] = resultLOD[index]

	
	
	)	
fn fn_decimateLOD lodNumber =
(

	select arr_lodObjects[lodNumber]

	modPanel.addModToSelection(MultiRes())
	$.modifiers[#MultiRes].vertexPercent = arr_lodVal[lodNumber]
	$.modifiers[#MultiRes].multiVertNorm = true
	$.modifiers[#MultiRes].creaseAngle = 75
	$.modifiers[#MultiRes].reqGenerate = false
		
		
	arr_lodObjects[lodNumber].name = (LODobject_Name + "_LOD" + (lodNumber-1) as string)
		
			if (cbx_autosmooth.checked == true) then 
		(
			smoothMod = smooth autosmooth:true threshold:autosmooth_spinner.value
			modPanel.addModToSelection(smoothMod)
			
			
			)	
		
			if (cbx_triangulate.checked == true) then 
		(
			triangulateMod = Turn_to_Poly limitPolySize:true maxPolySize:3 removeMidEdgeVertices:false
			modPanel.addModToSelection(triangulateMod)
			
			
			)	
		
		
	maxOps.CollapseNodeTo $ 1 true	
	converttopoly $	
		
	arr_lodObjectsEndVerts[lodNumber] =  polyop.getNumVerts $
	arr_lodObjectsEndFaces[lodNumber] =  polyop.getNumFaces $
		
    arr_lodObjectsNames[lodNumber] = (LODobject_Name + "_LOD" + (lodNumber-1) as string)
		

		)
	
		
		
		
		on clock20 tick do
		(
			fn_checkForWorkingObject()
			debugLog.text = labelDebugText			

		
			
			
			valUp = valUp+1
				if valUp == 1 then ( label6.text = ("|")) else
				if valUp == 2 then ( label6.text = ("/")) else
				if valUp == 3 then ( label6.text = ("-")) else
				if valUp == 4 then ( label6.text = ("\\")) else
-- 				if valUp == 5 then ( label6.text = ("+")) else
-- 				if valUp == 6 then ( label6.text = (".....")) else
-- 				if valUp == 7 then ( label6.text = ("......")) else
-- 				if valUp == 8 then ( label6.text = (".......")) else
-- 				if valUp == 9 then ( label6.text = ("........")) else
-- 				if valUp == 10 then ( label6.text = (".........")) else
-- 				if valUp == 11 then ( label6.text = ("..........")) else
-- 				if valUp == 12 then ( label6.text = ("...........")) else
-- 				if valUp == 13 then ( label6.text = ("............")) else
-- 				if valUp == 14 then ( label6.text = (".............")) else
				if valUp >= 4 then (valUp = 1
					label6.text = ("|")
					)

				)
			
			
		
		
	on cbx_is_enable_1 changed state1 do
	(
		arr_makeLODs[1] = state1
		labelDebugText = ("make LOD0: " + arr_makeLODs[1] as string )
		
	)
		on cbx_is_enable_2 changed state2 do
	(
		arr_makeLODs[2] = state2			
	)
		on cbx_is_enable_3 changed state3 do
	(
		arr_makeLODs[3] = state3			
	)
		on cbx_is_enable_4 changed state4 do
	(
		arr_makeLODs[4] = state4			
	)
		on cbx_is_enable_5 changed state5 do
	(
		arr_makeLODs[5] = state5			
	)
				
on percentage_spinner1 changed val1spinner do 
		(
			percentage_slider1.value = val1spinner
			labelDebugText = ("LOD0 reduction percentage: " + percentage_slider1.value as string )

		)
				on percentage_slider1 changed val1slider do 
		(
			percentage_spinner1.value = val1slider
						labelDebugText = ("LOD0 reduction percentage set to: " + percentage_spinner1.value as string )


		)
		
		on percentage_spinner2 changed val2spinner do 
		(
			percentage_slider2.value = val2spinner
						labelDebugText = ("LOD1 reduction percentage: " + percentage_slider2.value as string )


		)
				on percentage_slider2 changed val2slider do 
		(
			percentage_spinner2.value = val2slider
									labelDebugText = ("LOD1 reduction percentage set to: " + percentage_spinner2.value as string )


		)
		on percentage_spinner3 changed val3spinner do 
		(
			percentage_slider3.value = val3spinner
									labelDebugText = ("LOD2 reduction percentage: " + percentage_slider3.value as string )

			

		)
				on percentage_slider3 changed val3slider do 
		(
			percentage_spinner3.value = val3slider
												labelDebugText = ("LOD2 reduction percentage set to: " + percentage_spinner3.value as string )

		)
		on percentage_spinner4 changed val4spinner do 
		(
			percentage_slider4.value = val4spinner
												labelDebugText = ("LOD3 reduction percentage: " + percentage_slider4.value as string )


		)
				on percentage_slider4 changed val4slider do 
		(
			percentage_spinner4.value = val4slider
												labelDebugText = ("LOD3 reduction percentage set to: " + percentage_spinner4.value as string )

		)
		on percentage_spinner5 changed val5spinner do 
		(
			percentage_slider5.value = val5spinner
												labelDebugText = ("LOD4 reduction percentage: " + percentage_slider5.value as string )


		)
				on percentage_slider5 changed val5slider do 
		(
			percentage_spinner5.value = val5slider
												labelDebugText = ("LOD4 reduction percentage set to: " + percentage_spinner5.value as string )


		)
		on btn_defaults pressed do
		(
				percentage_slider1.value = 	percentage_spinner1.value = arr_lodVal[1] as float


								percentage_slider2.value = 	percentage_spinner2.value = arr_lodVal[2] as float

								percentage_slider3.value = 	percentage_spinner3.value = arr_lodVal[3] as float

											percentage_slider4.value = 	percentage_spinner4.value = arr_lodVal[4] as float

											percentage_slider5.value = 	percentage_spinner5.value = arr_lodVal[5] as float


				labelDebugText = (
					"LOD0 reduction percentage set to default: " + arr_lodVal[1] as string + "%" +"\n" +
					"LOD1 reduction percentage set to default: " + arr_lodVal[2] as string + "%" +"\n" +
					"LOD2 reduction percentage set to default: " + arr_lodVal[3] as string + "%" +"\n" +
					"LOD3 reduction percentage set to default: " + arr_lodVal[4] as string + "%" +"\n" +
					"LOD4 reduction percentage set to default: " + arr_lodVal[5] as string + "%" +"\n" 
					
				)
					
					
				
			
			
			

		)
		
		on btn_GetObject pressed do
		(
						workObject = try($)catch(messageBox "I'll now crash, bad / deleted / not editable poly object"
results = undefined)
try(fn_getOriginalMeshData(workObject))catch(messageBox "I'll now crash, bad / deleted / not editable poly object"
results = undefined)
			
	LODobject_Name = try(workObject.name)catch(LODobject_Name="none selected.")
			try(edt_LODobject.text = LODobject_Name
								labelDebugText = ("Working mesh set to: \n" + workObject.name as string + ", \nwe can continue!")
				)
				catch (labelDebugText = ("Working mesh NOT SET, we cant continue!"))

		)
		
		on btn_restore pressed do
		(
			
			max fetch
			labelDebugText = ("Scene restored,\ndont forget to pick your object again!")
			)
		
on btn_makeLODs pressed do
		(
			clearListener()
			if cbx_makeBackup.checked == true then
			(
				max hold				
			)
			
			if cbx_makeCopy.checked == true then
			(
				fn_backupOriginalMesh (workObject)
			)
			for i=1 to arr_makeLODs.count do
			(
				 windows.processPostedMessages()

				if (arr_makeLODs[i] == true) then
				(
				print("arr_makeLODs " +i as string + " is " + arr_makeLODs[i] as string)
					fn_copyOriginalMesh(i)
				)
			)	
			labelDebugText =""

			
			for j=1 to arr_makeLODs.count do
			(
							if (arr_makeLODs[j] == true) then
				(
					fn_decimateLOD(j)
					
									print("LOD " +j as string + " is now " + arr_lodObjectsNames[j] as string + " and is decimated from \n" +  lodObjectStartFaces as string +
											" to " + arr_lodObjectsEndFaces[j] as string +"(" +((arr_lodObjectsEndFaces[j] / lodObjectStartFaces )*100 ) as string + "%) faces , and " +
										lodObjectStartVerts as string +" to " + arr_lodObjectsEndVerts[j] as string +"(" +((arr_lodObjectsEndVerts[j] / lodObjectStartVerts)*100 ) as string + "%) verts .\n"+
										"---------------------------------------------------------------------------------------" )
										
										labelDebugText += ("LOD" +j as string+": \n[" +  lodObjectStartFaces as string +" -> " + arr_lodObjectsEndFaces[j] as string +"(" +((arr_lodObjectsEndFaces[j] / lodObjectStartFaces )*100 ) as string + "%) faces] \n[" +
										lodObjectStartVerts as string +" -> " + arr_lodObjectsEndVerts[j] as string +" (" +((arr_lodObjectsEndVerts[j] / lodObjectStartVerts)*100 ) as string + "%) verts]\n" 
										)
					
					
				
										windows.processPostedMessages()
										
				

				)
			)

			
						
		)
		
		
		
		
		
		
		
		
		
	)

	createdialog roll_makeLODs
)
