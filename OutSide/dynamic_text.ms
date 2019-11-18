rollout dynamicText "Dynamic Text" width:136 height:296
(
	spinner spStartFrame "Start frame" pos:[8,8] width:120 height:16 range:[-999999,999999,0] type:#integer
	spinner spEndFrame "End frame" pos:[16,24] width:112 height:16 range:[-999999,999999,100] type:#integer
	spinner spStartValue "Start value" pos:[12,49] width:116 height:16 range:[-999999,999999,0] type:#float
	spinner spEndValue "End value" pos:[18,64] width:110 height:16 range:[-999999,999999,100] type:#float
	spinner spPrecision "Precision" pos:[23,88] width:105 height:16 range:[0,9,2] type:#integer
	checkbox chRound "No zeros when round" pos:[8,108] width:123 height:15 checked:true
	edittext etPrefix "prefix:" text:"Now " pos:[8,136] width:120 height:17
	edittext etSuffix "suffix:" text:"th frame" pos:[9,154] width:119 height:17
	label lbl1 "50" pos:[8,184] width:56 height:16
	label lbl2 "50.5" pos:[8,200] width:56 height:16
	label lbl3 "50.555555555" pos:[8,216] width:56 height:16
	label lbl11 "" pos:[72,184] width:56 height:16
	label lbl21 "" pos:[72,200] width:56 height:16
	label lbl31 "" pos:[72,216] width:56 height:16
	button bCurve "Open curve editor" pos:[8,240] width:96 height:16
	button bDelete "X" pos:[112,240] width:16 height:16
	checkbox chData "" pos:[13,270] width:16 height:16 enabled:false checked:false
	button bApply "Apply" pos:[35,267] width:88 height:21
	
	fn setDefaults =
	(
		spStartFrame.value = 0
		spEndFrame.value = 100
		spStartValue.value = 0
		spEndValue.value = 100
		spPrecision.value = 2
		etPrefix.text = "Now "
		etSuffix.text = "th frame"
		chRound.checked = true
	)
	
	local spEdit = false
	
	fn getProps script:false =
	(
		find = false
		spStartFrame.enabled = spStartValue.enabled = spEndFrame.enabled = spEndValue.enabled = true
		for o in selection where classOf o.baseObject == text do 
		(
			conL = if classOf o.baseObject.size.controller == float_list then o.baseObject.size.controller[#Dynamic_text] else undefined
			conS = undefined
			conC = undefined
			if conL != undefined do
			(
				conS = conL[1].controller
				conC = conL[2].controller
				if conS != undefined and conC != undefined do
				(
					if spEdit != true do
					(
						if conC.keyable then
						(
							if conC.keys.count > 0 do
							(
								spStartFrame.value = conC.keys[1].time
								spStartValue.value = conC.keys[1].value
							)
							if conC.keys.count > 1 do
							(
								spEndFrame.value = conC.keys[conC.keys.count].time
								spEndValue.value = conC.keys[conC.keys.count].value
							)
						)
						else spStartFrame.enabled = spStartValue.enabled = spEndFrame.enabled = spEndValue.enabled = false
					)
					if script != true do
					(
						etPrefix.text = conS.GetConstant "prefix"
						etSuffix.text = conS.GetConstant "suffix"
						spPrecision.value = conS.GetConstant "digitsAfterPoint"
						chRound.checked = conS.GetConstant "noPointThenRound"
					)
					find = true
					exit
				)
			)
		)
		chData.checked = find
		--if find == false then setDefaults()
	)
	
	fn roundFloatValue val sharpness noPointThenRound =
	(
		mult = 10.0 ^ sharpness
		f = ((floor ((val * mult) + 0.5)) / mult) as string
		if noPointThenRound then
		(
			if (filterString f ".")[2] == "0" do return ((f as integer) as string)
		)
		else
		(
			arr = filterString f "."
			if arr[2].count < sharpness do
			(
				for i = 1 to sharpness - arr[2].count do f += "0"
			)
			if sharpness == 0 do f = (f as integer) as string
		)
		return f
	)
	
	fn preview =
	(
		lbl11.text = roundFloatValue 50 spPrecision.value chRound.checked
		lbl21.text = roundFloatValue 50.5 spPrecision.value chRound.checked
		lbl31.text = roundFloatValue 50.555555555 spPrecision.value chRound.checked
	)
	
	fn prePreview =
	(
		spEdit = true
		preview()
	)
	
	fn selectionChange =
	(
		spEdit = false
		getProps()
	)
	
	on dynamicText open do
	(
		setDefaults()
		preview()
		getProps()
		callbacks.removeScripts #selectionSetChanged id:#dynamicSelectionSetChanged
		callbacks.addScript #selectionSetChanged "dynamicText.selectionChange()" id:#dynamicSelectionSetChanged
	)
	
	on spStartFrame changed arg do prePreview()
	on spEndFrame changed arg do prePreview()
	on spStartValue changed arg do prePreview()
	on spEndValue changed arg do prePreview()
	on spPrecision changed arg do preview()
	on chRound changed arg do preview()
	
	on bApply pressed do
	(
		undo "Dynamic Text" on
		(
			if selection.count > 0 do
			(
				for o in selection where classOf o.baseObject == text do
				(
					max motion mode
					conL = if classOf o.baseObject.size.controller == float_list then o.baseObject.size.controller[#Dynamic_text] else undefined
					conS = undefined
					conC = undefined
					if conL == undefined then
					(
						o.baseObject.size.controller = bezier_float()
						conL = float_list()
						o.baseObject.size.controller = conL
						conL.available.controller = float_list()
						conL.setName 2 "Dynamic_text"
						conL = conL[2].controller
						conL.available.controller = float_script()
						conS = conL[1].controller
						conL.setName 1 "Dynamic_text_script"
						conL.available.controller = bezier_float()
						conC = conL[2].controller
						conL.setName 2 "Dynamic_text_curve"
						conL[#weights][2].value = 0.0
					)
					else
					(
						conS = conL[1].controller
						conC = conL[2].controller
					)
					
					if conC.keyable then
					(
						spStartFrame.enabled = spStartValue.enabled = spEndFrame.enabled = spEndValue.enabled = true
						if conC.keys.count > 0 then
						(
							conC.keys[1].time = spStartFrame.value
							conC.keys[1].value = spStartValue.value
						)
						else
						(
							addNewKey conC spStartFrame.value
							conC.keys[1].inTangentType = #linear
							conC.keys[1].outTangentType = #linear
							conC.keys[1].value = spStartValue.value
						)
						if conC.keys.count > 1 then
						(
							conC.keys[conC.keys.count].time = spEndFrame.value
							conC.keys[conC.keys.count].value = spEndValue.value
						)
						else
						(
							addNewKey conC spEndFrame.value
							conC.keys[conC.keys.count].inTangentType = #linear
							conC.keys[conC.keys.count].outTangentType = #linear
							conC.keys[conC.keys.count].value = spEndValue.value
						)
					)
					else spStartFrame.enabled = spStartValue.enabled = spEndFrame.enabled = spEndValue.enabled = false
					
					conS.addNode "self" o
					conS.addConstant "prefix" (etPrefix.text as string)
					conS.addConstant "suffix" (etSuffix.text as string)
					conS.addConstant "digitsAfterPoint" spPrecision.value
					conS.addConstant "noPointThenRound" chRound.checked
					
					txt = ""
					txt += "fn roundFloatValue val sharpness noPointThenRound = \n"
					txt += "( \n"
					txt += "mult = 10.0 ^ sharpness \n"
					txt += "f = ((floor ((val * mult) + 0.5)) / mult) as string \n"
					txt += "if noPointThenRound then \n"
					txt += "( \n"
					txt += "if (filterString f \".\")[2] == \"0\" do return ((f as integer) as string) \n"
					txt += ") \n"
					txt += "else \n"
					txt += "( \n"
					txt += "arr = filterString f \".\" \n"
					txt += "if arr[2].count < sharpness do \n"
					txt += "( \n"
					txt += "for i = 1 to sharpness - arr[2].count do f += \"0\" \n"
					txt += ") \n"
					txt += "if sharpness == 0 do f = (f as integer) as string \n"
					txt += ") \n"
					txt += "return f \n"
					txt += ") \n"
					txt += " \n"
					txt += "con = self.baseObject.size.controller[#Dynamic_text][2].controller \n"
					txt += "if con != undefined do \n"
					txt += "( \n"
					txt += "t = con.value \n"
					txt += "t = roundFloatValue t digitsAfterPoint noPointThenRound \n"
					txt += "self.text = prefix + (t as string) + suffix \n"
					txt += "try(dynamicText.getProps script:true)catch() \n"
					txt += ")\n"
					txt += "0"
					
					conS.script = txt
					conS.update()
					
					chData.checked = true
				)
				spEdit = false
			)
		)
	)
	
	on bCurve pressed do
	(
		for o in selection where classOf o.baseObject == text do 
		(
			conL = if classOf o.baseObject.size.controller == float_list then o.baseObject.size.controller[#Dynamic_text] else undefined
			conS = undefined
			conC = undefined
			if conL != undefined do
			(
				conS = conL[1].controller
				conC = conL[2].controller
			)
			if conC != undefined do
			(
				trackView.open "Dynamic Text"
				track = trackviews.getTrackView "Dynamic Text"
				trackviews.current.ui.loadLayout "Function Curve Layout"
				track.zoomOnTrack conC 1
				track.selectTrack conC true
				--actionMan.executeAction 1 "40002"
				track.zoomSelected()
				exit
			)
		)
	)
	
	on bDelete pressed do
	(
		if queryBox "Delete Dynamic from selection?" do
		(
			undo "Dynamic Text" on
			(
				for o in selection where classOf o.baseObject == text do 
				(
					conL = if classOf o.baseObject.size.controller == float_list then o.baseObject.size.controller[#Dynamic_text] else undefined
					if conL != undefined do
					(
						--conL[1].controller.update()
						tmp = o.baseObject.text
						o.baseObject.size.controller = bezier_float()
						o.baseObject.text = tmp
					)
				)
			)
		)
	)
	
)
createDialog dynamicText