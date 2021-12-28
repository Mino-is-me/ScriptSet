--pluginManager.loadClass FbxImporter
--findDir = getDir #import + @"\"
--rootDir = getSavePath initialDir:findDir
--tileDirs = GetDirectories (rootDir+"\\Tile*")

	--group now.
	thegroup = group $* name: ("Lod_Group")
	select thegroup

	--Now Level Of Detail, and add set.
	max utility mode
	UtilityPanel.OpenUtility Level_of_Detail
	panel = (windows.getChildHWND #max "Level of Detail")
	CreateNewSetButton = (windows.getChildHWND (UIAccessor.GetParentWindow panel[3]) "Create New Set")
	UIAccessor.PressButton CreateNewSetButton[1]

	/*
	--Also select the UCX_ object, for collision, if it exists.
	obj = getnodebyname ("UCX_" + exportlist[1].name)
	if obj != undefined then selectMore obj

	--Export only selected to FBX.
	dirname = (filterString (filenameFromPath theDir) "\\") [1]
	FBXSavePath = (rootDir+"\\"+dirname+"_Lod.fbx")
	print FBXSavePath
	FbxExporterSetParam "Animation" True
	FbxExporterSetParam "EmbedTextures" True
	FbxExporterSetParam "SmoothingGroups" True
	exportFile FBXSavePath #noPrompt selectedOnly:true using:FBXEXP 
	*/
)