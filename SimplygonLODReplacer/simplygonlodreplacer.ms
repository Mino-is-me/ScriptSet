
Global Frame 
Global importOptions
Global fbxFiles =#()
Global selectedPath
	
Fn FBXgetMultipleFiles =
(
	theDialog = dotNetObject "System.Windows.Forms.OpenFileDialog" --create a OpenFileDialog 
	theDialog.title = "PLEASE Select One Or More Files" --set the title
	theDialog.Multiselect = true --allow multiple files to be selected
	theDialog.Filter = "All Files (*.*)|*.*|FBX Files (*.fbx)|*.fbx" --specify the filter
	theDialog.FilterIndex = 2 --set the filter drop-down list to All Files
	result = theDialog.showDialog() --display the dialog, get result into variable
	result.ToString() --when closed, convert the result to string
	result.Equals result.OK --returns TRUE if OK was pressed, FALSE otherwise
	result.Equals result.Cancel --returns TRUE if Cancel was pressed, FALSE otherwise
	theFilenames = theDialog.fileNames --the selected filenames will be returned as an array
	return theFilenames
)

Fn getSubPaths paths =
(
	temp = #()
	s = 1
	subFolders = getDirectories (paths + "/*")
	t = subFolders.count
		while s < t do
		(
			for i = s to t do
			(
				temp = getDirectories (subFolders[i]+"*")
				for j = 1 to temp.count do
				(
					subFolders[subFolders.count+1] = temp[j] 
				)
			)
			s = t
			t = subFolders.count
		)
		sort subFolders
	return subFolders
)

Fn getExportPath =
(
	selectedExportPath = getSaveFileName \
	types:"FBX Files (*.fbx)|*.fbx" \
	caption:"Please select a export filename" \
	return selectedExportPath
)

Fn getMultipleFolders =
(
	selectedPaths = getSavePath \
	caption:"Please select a directory" \
	initialDir: "C:\EVE_Simplygon_Tool\Output"
	return selectedPaths
)

Fn makeAsLODObject =
(
	tempSelection = getCurrentSelection()
	for i = 1 to tempSelection.count do
	(
		s = tempSelection[i] as string
		if (findString s "UCX") != undefined then
		(
			deselect(tempSelection[i])
		)
	)
		thegroup = group selection name: ("LOD_Group")
		select thegroup
		max Utility mode
		UtilityPanel.OpenUtility Level_of_Detail
		panel = (windows.getChildHWND #max "Create New Set")
		CreateNewSetButton = (windows.getChildHWND (UIAccessor.GetParentWindow panel[3]) "Create New Set")
		UIAccessor.PressButton CreateNewSetButton[1]
)

Try(closeRolloutFloater Frame) Catch()
rollout importOptions "Export Options"
(
	button btn_openFolder "Open Folder" width:100 height:50 pos:[10,0]
	
	button btn_preparingExcute "Process Simplygon Batch Tool" width:250 height:50 pos:[120,0]

	button btn_selectFolder "Select Folder" width:100 height:50 pos:[380,0]

	editText editText_exportPath "Selected export directory:" \
	labelOnTop:true

	listBox listBox_selectedFolders "Selected directory:"
	items:#("Please select a folders.")

	button btn_excute "Excute" width:470 height:35
	
	on btn_openFolder pressed do 
	(
		doscommand "explorer \"C:\\EVE_Simplygon_Tool"
    )
	
	
	on btn_selectFolder pressed do 
	( 
		selectedExportPath = getExportPath()
		importOptions.editText_exportPath.text = selectedExportPath

		selectedPath = getMultipleFolders()
		importOptions.listBox_selectedFolders.items = getSubPaths(selectedPath)
    )
	
	on btn_excute pressed do 
	(
		resetMaxFile #noPrompt
		ucxCount = 0

		for k = 1 to importOptions.listBox_selectedFolders.items.count do
		(
			files = getFiles (importOptions.listBox_selectedFolders.items[k]+"*.fbx")
			for f in files do
			(
				importFile(f) #noPrompt using:FBXIMP

				tempSelection = getCurrentSelection()
				for i = 1 to tempSelection.count do
				(
					tempSelection[i].name = tempSelection[i].name+"_LOD"+((k-1) as string)
				)
			)
		)
		max select all
		tempsecSelection = getCurrentSelection()

		for v = 1 to tempsecSelection.count do
		(
			s = tempsecSelection[v] as string
			if (findString s "UCX") != undefined then
			(
				delete(tempsecSelection[v])
			)
		)
		makeAsLODObject()

		max select all

		exportFile(importOptions.editText_exportPath.text) #noPrompt selectedOnly:true
	)
	
	on btn_preparingExcute pressed do
	(
		ShellLaunch "C:\EVE_Simplygon_Tool\\Input\\InitializeFBX.bat" ""
		ShellLaunch "C:\EVE_Simplygon_Tool\\EVE_Simplygon_Tool.bat" ""
	)
)
Frame=newRolloutFloater "Simplygon LOD Replacer Tool" 500 320
addRollout importOptions Frame


/* 

12월 1일 체크사항 

1. UCX 리덕션 돌려줄것 
	code : For i in $* do delete $UCX*

2. LOD0 제대로 돌게 확인 해주고 

3. 선택 (Xcopy copy로 폴더 로컬에다 이동시키면 좋아요 )

*/ 