/*------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- version 1.4
-- Script Navigator GUI
-- By ken turner
-- www.designimage.co.uk
-- last changed 12th aug 2017
-- dot net reference http://www.scriptspot.com/bobo/mxs9/dotNet/dotNetObject_System.Windows.Forms.TabControl.html

open Windows Explorer at the file notepad.exe inside the Windows root directory. 
ShellLaunch "explorer.exe" "/e,/select,\"c:\\windows\\notepad.exe\""

12/08/2017 v1.4 added more script file types mse mcr
31/07/2015	v1.3	add show button to show the location of the select script in windows explorer
13/01/2012	v1.2	changed path functions to fix bugs that cause not userscript paths to break.
13/01/2012	v1.1	Added function to change the name in the list.
03/01/2012	v1.0	First release.
*/------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	
	fileIn ( "$userscripts/KenzorsScripts/Common/stringStreamStruct.ms" )
	
	--Floater Panel-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	if 	NavigatorFloater != undefined then CloseRolloutFloater NavigatorFloater
	NavigatorFloater = NewRolloutFloater "Kenzors Script Navigator" 300 490
	
	----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- ScriptListStruct
	struct ScriptListStruct  -- Contains details for single script
	(
		SName = "",
		SPath = "",
		SInfo = "",
		SExist = false,
		SEditable = false,
		
		fn Fullpath  fpath  = 
		(
			fpath = trimLeft fpath
			if fpath[1] == "\\" do
			(
				--- this fixes lists in the original form where the #userscripts part was truncated from the path string
				fpath = (getdir #userscripts) as string + fPath
			)
			fpath
		),
		fn ListMe = if SExist then SName else (SName  + " ... Bad Path"),
		fn fixPath =
		(
			pathTokenList = #("userScripts","scripts")
			for pathToken in pathTokenList do
			(
				scriptPath = (getdir ( pathToken as Name ) ) as string 
				findStringIndex = undefined
				if ( findStringIndex = (findString SPath scriptPath) ) != undefined then 
				(
					tokenString = "$" + pathToken
					SPath = replace SPath findStringIndex scriptPath.count tokenString 
				)
			)
		),
		fn isEditable =
		(
			fileEnding =  (toLower( getFilenameType SPath ) )
			print fileEnding
			SExist and ( fileEnding == ".ms" or fileEnding == ".mcr")
		),
		fn readme sStream =
		(
			SName = sStream.ReadToDelimitChar ","
			SPath = Fullpath ( sStream.ReadToDelimitChar "," )
			SInfo = sStream.ReadToDelimitChar "\n"
			SExist = (doesFileExist SPath )
		),
		/*
		fn getPathAndReplaceUserPath =
		(
			scriptPath = (getdir #userscripts) as string 
			replace SPath 1 scriptPath.count ""
		),
		*/
		fn WriteMe f =
		(
			fixPath()
			-- outPath = getPathAndReplaceUserPath()
			format "%,%,%\n" SName SPath SInfo to:f
		),
		fn RunMe = if SExist then filein SPath else messagebox "bad Path",

		fn EditMe = if isEditable() then edit SPath else messagebox "bad Path",
		fn OpenBrowserToFindMyFile =
		(
			SPath  = getOpenFileName "locate script" types:"script(*.ms)|*.ms|(*.mse)|*.mse|(*.mcr)|*.mcr|"
			SExist = (SPath != undefined)
			
			if SExist then 
			( 
				SName  = getFilenameFile SPath
				fixPath()
			)
		),
		fn SelectMeInExplorer =
		(
			explorerPath = mapPaths.getFullFilePath SPath 
			explorerPath = "/e,/select,\"" + explorerPath + "\""
			
			ShellLaunch "explorer.exe" explorerPath
			print explorerPath
		)
	)
	-------------------------------------------------------------------------------------------------------------------------------------------------------------------------end of: ScriptListStruct
	----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	
	
	
	----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- ScriptArrayStruct
	struct ScriptArrayStruct
	(
		ListPath , LScripts = #(), Lchanged = False, CanWrite = true,
		theFileHeadLineString = "Kenzors Script Navigator list v", dataVersionNumber = "1.2",
		fn getName = getFilenameFile ListPath,
		fn ListMe = For i in LScripts collect i.ListMe(),
		fn ChangeNameTo theNewName =
		(
			newListPath = ( getFilenamePath ListPath ) + theNewName + ( getFilenameType ListPath )
			renameFile ListPath newListPath
			ListPath = newListPath
		),
		fn ReadmeFromStringStream sStream =
		(
			sStream.checkHeadlineIs theFileHeadLineString
			sStream.ReadNameString()
			CanWrite = sStream.ReadToDelimitCharAndTypeCast "\n" asClass:booleanClass
			LScripts = sStream.collectStructArrayToEOF ScriptListStruct
		),
		fn LoadMe =
		(
			if (listPath != undefined) then 
			( 
				if (doesFileExist listPath ) then
				(
					f = openfile listPath
					ReadmeFromStringStream ( StringStreamStruct f )
					close f
					true
				)else false
			)else false
		),
		fn ListUp A B =
		(
			stricmp A.Sname B.Sname 
		),
		fn sortList =
		(
			QSort LScripts ListUp 
			LChanged = True
		),
		fn EditInfo i txt =
		(
			LScripts[i].SInfo = txt
			LChanged = True
		),
		fn setScriptNameTo txt atIndex: =
		(
			if atIndex > 0 and atIndex <= LScripts.count do
			(
				LScripts[atIndex].SName = txt
				LChanged = True
			)
		),
		fn WriteMe =
		(
			If CanWrite do
			(
				f = createFile ListPath
				format "%,%\n" theFileHeadLineString dataVersionNumber to:f
				format "%,%\n" "#Allow_User_Edit " CanWrite to:f
				for Scpt in LScripts do Scpt.writeMe f
				Close f
			)
		),
		fn AddScript =
		(
			Scpt = ScriptListStruct()
			Scpt.OpenBrowserToFindMyFile()
			if Scpt.SExist then
			(
				append LScripts Scpt
				LChanged = True
			)
		),
		fn RemoveScript i=
		(
			If CanWrite do
			(
				DeleteItem LScripts i
				LChanged = True
			)
		),
		fn reportTxt i =
		(
			if i > LScripts.count or ( i < 1 ) then #("","","") else
			(
				maxStringLengthForGui = 50
				reportPath = LScripts[i].Spath
				if reportPath.count > maxStringLengthForGui then 
				(
					reportPath = "..." + ( substring reportPath ( reportPath.count - maxStringLengthForGui ) reportPath.count )
				) 
			#(LScripts[i].SName,LScripts[i].SInfo,reportPath)
			)
		)
	)
	--------------------------------------------------------------------------------------------------------------------------------------------------------------------- End Of: ScriptArrayStruct
	----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	
	
	
	----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ RollNavigator
	rollout RollNavigator "Script Navigator"
	(
		local ScriptArray = #()
		local ScriptList = undefined
		Local Lchanged = False
		Local writeIndex = 1
		
		hyperlink wwwDesignimage "www.designimage.co.uk" color:blue address:"www.designimage.co.uk" align:#center
		label lblTab "Enter name of new script list tab" enabled:false visible:false
		Edittext EdtTab "Name" fieldWidth:180 align:#Left enabled:false visible:false
		button btnCancelEditTab "cancel" Width:50 align:#Right enabled:false visible:false offset:[0,-25]
		
		Edittext EdtName fieldWidth:255 offset:[0,-45] 
		Edittext EdtInfo fieldWidth:255 
		Label lblScriptPath "" align:#center
		
		dotNetControl dnTabs "system.windows.forms.tabControl" height:25 
		listbox lbx "Double Click To Run" Height:22
		
		button ButR "Run" across:6 tooltip:"click to run the selected script"
		button ButE "Edit" tooltip:"open the selected script in the MAXscript editor"
		button ButSelect "Show" tooltip:"Show the selected script in windows explorer"
		Button ButAdd "Add" tooltip:"open a browser to add a new script to the list"
		Button ButDel "Remove" tooltip:"remove the script from the list."
		Button BtnSort "Sort" tooltip:"sort the list in alphabetical order"
		fn Fullpath = ((getdir #userscripts) as string + ListPath)
		fn initTabs =
		(
			--Clear any existing tabs incase we do an update of them at some point. 
			dnTabs.tabPages.clear()
			dnTabs.ShowToolTips = true
			labelsTxt = #("+")  + ( for theList in ScriptArray collect theList.getName() )
			--Loop through all the labels that we pass to the function and add a tab by the same name. 
			for tabName in labelsTxt do dnTabs.tabPages.add tabName
			if ScriptArray.count > 0 then dnTabs.SelectTab writeIndex
			for i = 0 to ( ScriptArray.count -  1) do
			(
				tipTxt = if i == 0 then "click to add empty list" else "right click to change the list name"
				dntabs.tabpages.item[i].tooltiptext = 	tipTxt
			)
		)
		fn refreshEditTextAndLabel =
		(
			InfoText = ScriptList.reportTxt ( lbx.selection )
			EdtName.text = InfoText[1]
			EdtInfo.text = InfoText[2]
			lblScriptPath.text = InfoText[3]
		)
		fn RefreshList =
		( 
			oldListBoxIndex = lbx.selection
			ButE.enabled = ButAdd.enabled = ButDel.enabled = BtnSort.enabled = ScriptList.canwrite
			EdtInfo.readOnly = EdtName.readOnly =  not ScriptList.canwrite
			lbx.items = ScriptList.listme()
			refreshEditTextAndLabel()

		)
		fn SetMeUp =
		(
			txtFileList = ( getfiles ("$userscripts/KenzorsScripts/common/Script Navigator Directories/*.txt") )
			ScriptArray = for txtFile  in txtFileList collect ( ScriptArrayStruct txtFile )
			for i in ScriptArray do i.LoadMe()
			ScriptList = ScriptArray[writeIndex]
			initTabs()
			RefreshList()
		)
		fn sortList =
		(
			ScriptList.sortList()
			RefreshList() 
		)
		
		fn WriteMe = for i in ScriptArray do i.WriteMe()
		
		fn closeMe =
		(
			test = false 
			for i in ScriptArray where ( i.LChanged ) do test = true
			if test do if queryBox "Save Changes" do 
			(
				for i in ScriptArray where ( i.LChanged ) do i.writeme()
			)
		)
		on RollNavigator open do SetMeUp()
		
		on EdtInfo entered txt do 
		(
			ScriptList.EditInfo (lbx.selection) txt
			RefreshList() 
		)
		
		on lbx selected i do 
		(
			refreshEditTextAndLabel()
		)
		on lbx doubleclicked i do 
		(
			ScriptList.LScripts [i].RunMe()
			CloseRolloutFloater NavigatorFloater
		)
		on ButR Pressed do 
		(
			ScriptList.LScripts [(lbx.selection)].RunMe()
			CloseRolloutFloater NavigatorFloater
		)
		on ButE Pressed do ScriptList.LScripts[(lbx.selection)].EditMe()
		
		on ButSelect Pressed do ScriptList.LScripts[(lbx.selection)].SelectMeInExplorer()
		
		On ButAdd Pressed do
		(
			ScriptList.AddScript()
			RefreshList()
		)
		On ButDel Pressed do
		(
			ScriptList.RemoveScript (lbx.selection) 
			RefreshList()
		)
		On BtnSort Pressed do sortList()
		
		On RollNavigator close do closeMe()
		
		fn enableTabTextEdit isEditable=
		(
			--dntabs.visible = not isEditable
			if  isEditable then dntabs.Hide() else dntabs.show() 
			dntabs.Invalidate()
			lblTab.enabled = lblTab.visible = btnCancelEditTab.visible = btnCancelEditTab.enabled = EdtTab.visible = EdtTab.enabled = isEditable
			lbx.enabled = ButR.enabled = ButE.enabled = ButAdd.enabled =  ButDel.enabled =  BtnSort.enabled = not isEditable
			edtName.enabled = edtName.visible = edtInfo.enabled = edtInfo.visible = not isEditable
		)
		fn setListWriteIndexTo theIndex =
		(
			writeIndex = theIndex
			ScriptList = ScriptArray[writeIndex]
			RefreshList()
		)
		on dnTabs MouseUp senderArg arg do
		(
			--showProperties  arg
			--showMethods arg
			--showEvents arg
			if  senderArg.SelectedIndex > 0 then 
			(
				(
					setListWriteIndexTo senderArg.SelectedIndex
				)
				if  arg.button == arg.button.Right and ScriptArray[writeIndex].canWrite then
				(
					initTabs()
					EdtTab.text = ""
					enableTabTextEdit true
				)
			)else
			(
				writeIndex = 0
				EdtTab.text = ""
				enableTabTextEdit true
			)
		)
		on btnCancelEditTab pressed do
		(
			enableTabTextEdit false
		)
		fn filterChar c = 
		(
			BadCharList = ",.\/"
			c =  if (findString BadCharList c ) != undefined then "" else c
		)
		fn createValidFileNameFrom theString =
		(
			newTxt = ""
			for i =1 to theString.count  do
			(
				newTxt += filterChar theString[i]
			)
			newTxt
		)
		on EdtName entered newNameTxt do
		(
			newValidName = createValidFileNameFrom newNameTxt
			ScriptList.setScriptNameTo newValidName atIndex:  (lbx.selection) 
			RefreshList() 
		)

		on EdtTab entered txtName do
		(
			newValidName = createValidFileNameFrom txtName 
			if writeIndex == 0 then
			(
				theNamePath = "$userscripts/KenzorsScripts/common/Script Navigator Directories/"+txtName+".txt"
				append ScriptArray (ScriptArrayStruct theNamePath )
				setListWriteIndexTo ScriptArray.count 
			)else
			(
				ScriptArray[writeIndex].ChangeNameTo txtName
			)
			initTabs()
			enableTabTextEdit false
		)

	)
	--------------------------------------------------------------------------------------------------------------------------------------------------------------------------- End Of: RollNavigator
	----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	
	
	
	----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	-------------------------------------------------------------
	addRollout RollNavigator NavigatorFloater
