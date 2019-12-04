
Try(DestroyDialog monsterGradientRollout) Catch
	--SCRIPT THAT CREATES A GRADIENT BITMAP ON A MODEL FROM TOP TO BOTTOM
	rollout monsterGradientRollout "Gradient Map Tool"
	(

		--SAVES ALL CONTROLS TO AN INI
		fn SaveControlSettings thisRol thisINI =
		(
			for c in thisRol.controls do
			(
				case classof c of
				(
					SpinnerControl : setINISetting thisINI thisRol.name c.name (c.value as string)
					EditTextControl : setINISetting thisINI thisRol.name c.name c.text
					CheckboxControl : setINISetting thisINI thisRol.name c.name (c.checked as string)
					ComboBoxControl : setINISetting thisINI thisRol.name c.name (c.selection as string)
					ColorPickerControl : setINISetting thisINI thisRol.name c.name (c.color as string)
				)
			)
		)

		--LOADS ALL CONTROLS FROM AN INI
		fn LoadControlSettings thisRol thisINI =
		(
			if doesFileExist thisINI do
			(
				for c in thisRol.controls do
				(
					if classof c != GroupStartControl and classof c != GroupEndControl do
					(
						local controlValue = getINISetting thisINI thisRol.name c.name

						if controlValue != "" and controlValue != undefined do
						(
							case classof c of
							(
								SpinnerControl : c.value = controlValue as number
								EditTextControl : c.text = controlValue
								CheckboxControl : c.checked = controlValue as BooleanClass
								ComboBoxControl : c.selection = controlValue as number
								ColorPickerControl : c.color = execute (controlValue)
							)
						)
					)
				)
			)
		)

		group "Render Options"
		(
			spinner spnX "Width" range:[32,8192,1024] type:#integer align:#right
			spinner spnY "Height" range:[32,8192,1024] type:#integer align:#right
			spinner spnPadding "Padding" range:[0,32,4] type:#integer align:#right
			spinner spnChannel "UV Channel" range:[1,99,1] type:#integer align:#right
			colorPicker colBackground "Background" color:(color 0 0 0) align:#right
			checkbox chkHack "Use Wide Texture Hack?" checked:true align:#right
		)

		group "Gradient Colors"
		(
			colorPicker colGradient3 "Top" color:(color 255 255 255) align:#right
			colorPicker colGradient2 "Middle" color:(color 128 128 128) align:#right
			colorPicker colGradient1 "Bottom" color:(color 0 0 0) align:#right
			button btnreverse "Reverse Colors" align:#Right --Minomi edited
		)

		group "Output"
		(
			checkbox chkDisplay "Open After Render?" checked:true align:#left
			label lblOutput "Output to..." align:#left
			editText edtOutputPath "" text:"$temp\\" readOnly:true width:148 align:#center
			button btnOutputPath "Browse..." width:65 align:#center across:2
			button btnOutputTemp "Reset" width:65 align:#center
		)

		button btnRender "Render Gradient Map" width:148 height:32

		on monsterGradientRollout open do
		(
			clearlistener()
			LoadControlSettings monsterGradientRollout "$temp/monsterGradientRollout.ini"
		)
		--Minomi edited
		on btnreverse pressed do 
		(
			topColor = monsterGradientRollout.colGradient3.color
			botColor = monsterGradientRollout.colGradient1.color
			monsterGradientRollout.colGradient3.color = botColor
			monsterGradientRollout.colGradient1.color = topColor
		)
		--Minomi edited


		on monsterGradientRollout close do
		(
			SaveControlSettings monsterGradientRollout "$temp/monsterGradientRollout.ini"
		)

		on btnOutputTemp pressed do
		(
			edtOutputPath.text = "$temp\\"
			chkHack.checked = true
			spnChannel.value = 1
			spnPadding.value = 4
			spnX.value = 1024
			spnY.value = 1024
			colBackground.color = (color 0 0 0)
			colGradient3.color = (color 255 255 255)
			colGradient2.color = (color 128 128 128)
			colGradient1.color = (color 0 0 0)
		)

		on btnOutputPath pressed do
		(
			outPath = getSavePath caption:"Render Files To..." initialDir:maxfilepath
			if outPath != undefined do
			(
				edtOutputPath.text = outPath + "\\"
			)
		)

		on btnRender pressed do
		(
			proceed = true

			--COLLECT OBJECTS WITH NO UV CHANNELS ON THE TARGET CHANNEL
			noMapObjs = for obj in selection where (meshop.getNumMaps obj.mesh) - 1 < spnChannel.value collect obj.name

			--STOP THE PROCESS IF ANY INVALID CHANNELS ARE PRESENT
			if noMapObjs.count != 0 do
			(
				proceed = false
				str = "The specified mapping channel doesn't exist on objects:\n"

				for o in noMapObjs do
				(
					str += (o + "\n")
				)

				messageBox str title:"No Mapping Channel"
			)

			--STOP THE PROCESS IF NOTHING IS SELECTED
			if selection.count == 0 do
			(
				proceed = false
			)

			--CONTINUE WITH REDRAW OFF
			if proceed do with redraw off
			(
				max create mode
				max hold

				clearlistener()

				outPath = edtOutputPath.text

				--SAVE THIS SETTING AND ENABLE IT TO ALLOW CANCELING
				saveEscape = escapeEnable
				escapeEnable = true

				--SETUP THE SCENE
				unhide objects dolayer:true
				hide objects
				unhide selection

				--FIX POSSIBLE ERRORS
				resetxform selection
				collapsestack selection

				selection.backfacecull = on

				--CREATE A MATERIAL AND A GRADIENT ON IT'S DIFFUSE
				newMaterial = StandardMaterial()
				newMaterial.selfIllumAmount = 100

				gradientMap = gradient()

				newMaterial.diffuseMap = gradientMap

				gradientMap.coords.U_angle = 90
				gradientMap.coords.mappingType = 0
				gradientMap.coords.mapping = 2
				gradientMap.color1 = colGradient1.color
				gradientMap.color2 = colGradient2.color
				gradientMap.color3 = colGradient3.color

				--HACK TO FIX TEXTURES WIDE NOT RENDERING PROPERLY
				if spnX.value > spnY.value and chkHack.checked do
				(
					tileAmount = spnX.value as float / spnY.value as float
					vTile = (spnY.value as float / spnX.value as float)
					vOffset =  vTile / 2.0

					xFormMod = uvw_xform()
					xFormMod.V_Tile = vTile
					xFormMod.V_Offset = 1.0 - vTile
					addModifier selection xFormMod
				)

				--APPLY MATERIAL TO SELECTION
				selection.material = newMaterial

				--SET UP THE RENDER
				renderers.current = Default_Scanline_Renderer()
				backgroundColor = colBackground.color
				ambientColor = color 255 255 255


				for obj in selection do
				(
					obj.removeAllBakeElements()

					--DELETE THE FILE IF IT EXISTS
					gMapName = (outPath + obj.name + "_gr.tga")
					deleteFile gMapName

					--CREATE THE DIFFUSE BAKE ELEMENT
					difElement = DiffuseMap()
					difElement.enabled = true
					difElement.filenameUnique = false
					difElement.fileType = gMapName
					difElement.lightingOn = false
					difElement.shadowsOn = false
					difElement.filterOn = true
					difElement.outputSzX = spnX.value
					difElement.outputSzY = spnY.value


					--SETUP THE OBJ FOR BAKING
					bobj = obj.INodeBakeProperties
					bobj.addBakeElement difElement
					bobj.bakeEnabled = true
					bobj.bakeChannel = spnChannel.value
					bobj.nDilations = spnPadding.value
				)

				render renderType:#bakeSelected frame:#current vfb:off progressBar:true outputwidth:spnX.value outputheight:spnY.value outputSize:[spnX.value,spnY.value]

				--COLLECT MAPS FOR DISPLAY
				bmpList = for obj in selection collect obj.name


				--RESTORE THE ESCAPE SETTING AND RELOAD THE FILE
				escapeEnable = saveEscape
				fetchmaxfile quiet:true

				--DISPLAY ALL RENDERED MAPS
				if chkDisplay.checked do
				(
					--TRY TO RELOAD THE TEXTURES FROM DISK
					freescenebitmaps()
					gc()

					for obj in bmpList do
					(
						local bmpGradient = openbitmap (outPath + obj + "_gr.tga")
						if bmpGradient != undefined do
						(
							--ROUND ABOUT WAY OF FORCING A RELOAD ON THE BMP
							bmpTex = bitmaptexture bitmap:bmpGradient
							bmpTex.reload()
							display bmpGradient
						)
					)
				)
			)

			forcecompleteredraw()

		)
	)

	createDialog monsterGradientRollout