d/* Eve Toolset By Minomi*/

--import pytho

global projectDir = "\\\\10.220.70.12\\eve\\ART_Backup\\Script\\"

global backUpDir = "\\\\10.220.70.12\\eve\\ART_Backup\\TA_TestFolder\\CollectedBackUp\\"

include "\\\\10.220.70.12\\eve\\ART_Backup\\Script\\getKeySelector\\SelectedKeyFunc.ms" --selectedKeyReducer Body Include 
include "\\\\10.220.70.12\\eve\\ART_Backup\\Script\\getKeySelector\\selectedKeyBipOpposite.ms" -- Biped Key Mirror Include
include "\\\\10.220.70.12\\eve\\ART_Backup\\Script\\BVHRetargeter\\BVHRetargeter.ms" -- BVH Retargeter Include 
include "\\\\10.220.70.12\\eve\\ART_Backup\\Script\\RootMotionExtracter\\RMAngler.ms" -- Root Motion Rotater Include
include "\\\\10.220.70.12\\eve\\ART_Backup\\Script\\RootMotionExtracter\\RootMotionExtracter.ms" -- Root Motion Extracter Include 
include "\\\\10.220.70.12\\eve\\ART_Backup\\Script\\keyReducer\\SelectedKeyReducer.ms" -- TAZO (Baked Key Cleaner) Include
include "\\\\10.220.70.12\\eve\\ART_Backup\\Script\\RiggerScripts\\AttributesManager.ms"
--include "\\\\10.220.70.12\\eve_\\ART_Backup\\Script\\SkinThief\\SkinThief.ms" -- SkinThief

Global BodyNodes ="\\\\10.220.70.12\\eve\\ART_Backup\\Script\\Exporter\\BodyNodes.ms" --get EVE Body Nodes "USE ONLY Body 1~4"
Global BodyNodes_new = "\\\\10.220.70.12\\eve\\ART_Backup\\Script\\Exporter\\BodyNodes_new.ms"
Global weaponNodes = "\\\\10.220.70.12\\eve\\ART_Backup\\Script\\Exporter\\weaponNodes.ms" -- get Weapon Nodes
Global FacialNodes = "\\\\10.220.70.12\\eve\\ART_Backup\\Script\\Exporter\\FacialNodes.ms" -- "NO USE" now we use BlendShape Only
Global LastExportPath = ( (GetDir #userScripts) + "\\" + "LastExportPath.ms" ) -- get UserOwn Last Export Path
Global eveLogoBMP = "//10.220.70.12/eve/ART_Backup/Script/Logo/eveLogo.bmp" -- get EVELOGO image
Global underConstructionPNG = "//10.220.70.12/eve/ART_Backup/Script/Logo/underConstruction.png"
Global rolloutSetting = ( (getDir #userScripts) + "\\" + "personalSetting.ini" ) -- get UserOWN Exporter setting ini

Global exportWithMorph = false 
Global exportWithRootMotion = false

Global hasProp = false 
Global hasXtraProp = false 

Global leftWeaponAnim = false 


fn grabchildren aBone childArray:#() getSelf:true = 
(
	for cBone in aBone.children do
	(
		append childArray cBone		
		if cBone.children.count !=0 do 
		(
			grabchildren cBone childArray:childArray 
		)
	)
	
	if getSelf do childArray = #(aBone)+childArray
	
	return childArray
)--Code by FScreen 

fn makeExportogDir =
(
	local userName = sysInfo.username
	local userLogDir = "\\\\10.220.70.12\\eve\\ART_Backup\\CollectedLog\\" + userName
	if (doesDirectoryExist userLogDir) != true then 
	(
		makeDir userLogDir
	)
	return userLogDir
)

fn collectUserLog logDir fileName = 
(
	local txtfileName = fileName + ".txt"
	file = logDir + "\\" + txtfileName 
	createFile file 
)


fn animationExportSetUp frameVal isWithMorph =
(
	FbxExporterSetParam "Animation" true
	
	FbxExporterSetParam "UseSceneName" true
	
	FbxExporterSetParam "BakeAnimation" true
	FbxExporterSetParam "BakeFrameStart" animationRange.start
	FbxExporterSetParam "BakeFrameEnd" animationRange.end
	FbxExporterSetParam "BakeFrameStep" 1
	FbxExporterSetParam "BakeResampleAnimation" true
	FbxExporterSetParam "Resampling" frameVal
	FbxExporterSetParam "FilterKeyReducer" false
	FbxExporterSetParam "Skin" true	
	FbxExporterSetParam "Shape" isWithMorph
	
	FbxExporterSetParam "SmoothingGroups" true	 	--Export With Smoothing Group
	
	FbxExporterSetParam "UpAxis" #z						 	--Up Axis -> +Z
	FbxExporterSetParam "Lights" false					 	--Export WithOut Light
	FbxExporterSetParam "ASCII" true						 	--FBX Format -> ASCII
	FbxExporterSetParam "ConvertUnit" #custom unit	--unit Size -> Custom
	
	
	
) -- from FBX Export Parameter Selection


Fn fn_getMultipleFiles =
(
	theDialog = dotNetObject "System.Windows.Forms.OpenFileDialog" --create a OpenFileDialog 
	theDialog.title = "PLEASE Select One Or More Files" --set the title
	theDialog.Multiselect = true --allow multiple files to be selected
	theDialog.Filter = "All Files (*.*)|*.*|max Files (*.max)|*.max" --specify the filter
	theDialog.FilterIndex = 2 --set the filter drop-down list to All Files
	result = theDialog.showDialog() --display the dialog, get result into variable
	result.ToString() --when closed, convert the result to string
	result.Equals result.OK --returns TRUE if OK was pressed, FALSE otherwise
	result.Equals result.Cancel --returns TRUE if Cancel was pressed, FALSE otherwise
	theFilenames = theDialog.fileNames --the selected filenames will be returned as an array
	return theFilenames
)

fn getFileNodes File= 
(	
	--File = BodyNodes
	fileSTM = openFile File
	ar_selection = #()

	deselect $*
	while not eof fileSTM do
	(
		try
		(
			txt = readLine fileSTM 
			nodeName = getNodeByName txt
			append ar_selection nodeName 
		)
		Catch(print nodeName)
	)
	close fileSTM
	deselect $* 
	for i in ar_selection do 
	(
		try 
		(
			selectMore i 
		)
		catch()
	)
	
	--UndefinedNodeinScene = findItem ar_selection undefined 
	--deleteItem ar_Selection UndefinedNodeinScene
	--select ar_Selection

	/*
	if UndefinedNodeinScene == 0 then
	(
		select ar_Selection
	)
	else 
	(
		messageBox "This file(Scene) doesn't seem to be \nthe right file of PC(EVE) " title:"Script Alert"
		format "undefined Node num : %" UndefinedNodeinScene
		--exit 
	)
	*/
) -- NodeName parsing from txt file


fn getFacialNodes = 
(	
	File = FacialNodes
	fileSTM = openFile File
	ar_selection = #()
	deselect $*
	while not eof fileSTM do
	(
		try
		(
			txt = readLine fileSTM 
			nodeName = getNodeByName txt
			append ar_selection nodeName
		)
		Catch(print nodeName)
	)
	close fileSTM
	select ar_Selection
	--selectMore $Bip001*
) -- NodeName parsing from txt file


fn getLastExportPath =
(
	
	isLastExportPath = doesFileExist ( (GetDir #userScripts) + "\\" + "LastExportPath.ms" )
	
	if isLastExportPath != True then
	(
		file = createFile ( (GetDir #userScripts) + "\\" + "LastExportPath.ms" )
		LastExportPath = ( (GetDir #userScripts) + "\\" + "LastExportPath.ms" )
	)
	
	else 
	(
		file = LastExportPath
		fileSTM = openFile File
		while not eof fileSTM do
		(
			try
			(
				txt = readLine fileSTM
				ExportPath = txt
			)
			Catch()
		)
	)
	Close fileSTM
	
	if ExportPath == undefined do
	(
		ExportPath = ""
	)
	return ExportPath
)

fn makeNewINIFile =
(
	local isPersonalSettingFile = doesFileExist ( (getDir #userScripts) + "\\" + "personalSetting.ini")

	if isPersonalSettingFile != True then
	(
		local file = createFile( (getDir #userScripts) + "\\" + "personalSetting.ini" )
		local PersonalSetting = ( (getDir #userScripts) + "\\" + "personalSetting.ini" )
		Format "\n New iniFile : % \n" PersonalSetting

		setINISetting PersonalSetting "personalSetting" "Species" "1"
		setINISetting PersonalSetting "personalSetting" "ExportOption" "1"
	) 
)

fn getSkinObjs =
(
	local objs = $*
	local skinObjs = #()
	for obj in objs do
	(
		for i=1 to obj.modifiers.count do if classof obj.modifiers[i] == Skin do append skinObjs obj
	)
	return skinObjs
)

fn getMeshObjs = 
(
	local objs = $*
	local meshObjs = #()
	for obj in objs do
	(
		if Classof obj == PolyMeshObject do 
		(
			append MeshObjs obj
		)
	)
	return meshObjs 
)

fn getSkinBone obj = 
(		
	select obj
	setCommandPanelTaskMode mode:#modify  		
	
	local skinModifierID=0
	for i=1 to obj.modifiers.count do if classof obj.modifiers[i] == Skin do skinModifierID=i
	
	if skinModifierID != 0 then
	(	
		local skinModifier =  Obj.modifiers[skinModifierID]       
		local boneCount = skinOps.GetNumberBones skinModifier	--skin?? ????? Bone ?????? ????
		
		local result = for i in 1 to boneCount collect getNodeByName (skinOps.GetBoneName skinModifier i 1)		
		return result
	)
	else
	(
		return #()
	)
)

fn isRootNodeisRoot =
(
	local bRootisValid = isValidNode $Root 

	if bRootisValid == true then 
	(
		if( $Bip001.parent == $Root ) then
		(
			isRoot = True
		)
		else 
		(
			isRoot = false
			$Bip001.parent = $Root 
		)
	)
	else 
	(
		local bnRootNode = boneSys.createBone [ 0, 0, 0 ] [ 20, 0, 0 ] [ 0, 0, 1 ] -- Root를 +X를 Front로 놓고 생성 
		bnRootNode.name = "Root"
		$Bip001.parent = bnRootNode 
		bnRootNode.sidefins = true 
		bnRootNode.backfin = false 
		bnRootNode.frontfin = false 
		bnRootNode.sidefinssize = 4.0

		print "Root Node Created"
	)

	Return isRoot 
)

fn selectMeshesOnly = --wrappingCode 
(
	isRootHere = isValidNode $Root
	local isSkin = false 

	if not isRootHere do 
	(
		root = Dummy()
		
		root.name = "Root"
	)
	
	for i in selection do 
	(
		if i.modifiers.count == 0 then 
		(
			addModifier i (Skin())
			skinOps.addBone i.modifiers[#Skin] $Root 1
		)
		else 
		(
			for j=1 to i.modifiers.count do 
			(
				local hasSkin = isKindof i.modifiers[j] Skin
				if hasSkin do 
				(
					isSkin = true 
				)
			)
			if not isSkin do 
			(
				addModifier i (Skin())
				skinOps.addBone i.modifiers[#Skin] $Root 1
			)
		)
	)
)


fn makeRootXFront = 
(
	$Bip001.parent = undefiend
	$Root.rotation = quat 0 0 0.707107 0.707107

	$Bip001.parent = $Base
	
	$Root.rotation = quat 0 0 0 1
	
)

fn setTrianglePelvis =
(
	isTri = $Bip001.controller.trianglePelvis 
	if isTri do 
	(
		numLayer = biped.numLayers $Bip001.controller

		if numLayer > 0 do
		(
			biped.setCurrentLayer $Bip001.controller 0 
		)
		$Bip001.controller.figureMode = True 
		$Bip001.controller.trianglePelvis = False 
		$Bip001.controller.figureMode = False 
		biped.setCurrentLayer $Bip001.controller numLayer
		
	)
)


Global ar_MaxFiles =#()
Global BatchDir = getLastExportPath()
Global b_FacialOnly = false

Global Species = (getINISetting rolloutSetting "personalSetting" "Species") as integer 
Global exportOption = (getINISetting rolloutSetting "personalSetting" "exportOption") as integer
Global facialSetting = 1
Global cnt = 0

Global ar_skinObjs = #()
Global ar_meshObjs = #()
Global ar_skinBones = #()
Global specificName = ""

fn selectSkinBones = --wrappingCode 
(
	ar_skinBones = #()
	ar_skinObjs = getSkinObjs()
	for i=1 to ar_SkinObjs.count do
	(
		local skinBone = getSkinBone ar_skinObjs[i]
		append ar_skinBones skinBone
	)
	for i in ar_skinBones do selectMore i
)

fn selectBeforeExport =
(
	hasProp = isValidNode $'Bip001 Prop1'
	hasXtraProp = isValidNode $'Bip001 Prop2'
	case species of
	(
		1 : --when Export PC Species
		(
			
			getFileNodes BodyNodes-- get Bone Object 
			if hasXtraProp == true do selectMore $'Bip001 Prop2'
			if hasProp == true do selectMore $'Bip001 Prop1'
			Case exportOption of
			(
				1 : --when Export bones and Mesh 
				(
					ar_skinObjs = getSkinObjs()
					selectMore ar_skinObjs
					
					Try ( selectMore $SC_WeaponConstraint ) catch()

					selectmore $'Ab TL HairB09'
					--selectmore $'Ab TL hairC11'
					--selectmore $'Ab Tl HairA10'
					
					format "select Bones and Mesh PC[EVE]\n"
				)
				2 : -- when Export Bones Only 
				(
					Try ( selectMore $SC_WeaponConstraint ) catch()
					if facialSetting == 2 do -- Export facialNodes Only 
					(							
						deselect $* 
						getFacialNodes()
					)

					Try
					( -- breast bone exception 
						Deselect $DM_L_Breast_Point
						Deselect $DM_L_Breast
						Deselect $Ab_L_Breast_Link
						Deselect $Ab_L_Breast
						Deselect $DM_R_Breast_Point
						Deselect $DM_R_Breast
						Deselect $Ab_R_Breast_Link
						Deselect $Ab_R_Breast
					)
					Catch()


					if leftWeaponAnim == true do 
					(
						Try
						(
							BuSC = Dummy()
							BuSC.parent = $'Bip001 L Hand' 
							BuSC.name = "SC_BurstStanceConstraint"

						)	
						catch()

						with animate on 
						(
							for i=animationRange.start to animationRange.end do 
							(
								sliderTime = i 
								$'SC_BurstStanceConstraint'.transform = $'Bip001 prop2'.transform
							)
						)

						selectMore $SC_BurstStanceConstraint

					)
				) 
				3 : --when Export Meshes Only 
				(
					selectMeshesOnly()
					getSkinObjs()
					--ddl_facialSetting.enabled = false
				)
			)
		)
		2 : --when export Mob Species 
		(
			Case exportOption of 
			(
				1 : --when Export Bones and Mesh 
				(
					selectSkinBones()

					isPC = FindString MaxFileName "CH_P_EVE_"
					isVLConst = isValidNode $SC_BurstStanceConstraint
					if isPC != undefined do 
					(
						if not isVLConst do 
						(
							LConst = Dummy()
							LConst.name = "SC_BurstStanceConstraint"
							LConst.parent = $'Bip001 L Hand'
							LConst.transform = (matrix3 [0.94881,0.0150123,0.31549] [0.286194,0.381689,-0.878867] [-0.133613,0.924169,0.357854] [33.9202,-11.5206,86.8161])
						)
					)
					selectMore ar_skinObjs 
					Try
					(
						SelectMore $Bip001 
						SelectMore $Root 
						SelectMore $SC_BurstStanceConstraint
					)
					Catch()

					

					if hasProp == true do
					(
						selectMore $'Bip001 Prop1'
					)
					if hasXtraProp == true do 
					(
						selectMore $'Bip001 Prop2'
					)
					if (isValidNode $SC_LinkTarget) == true do
					(
						selectMore $'SC_LinkTarget'
					)

				)
				2 : --when Export Bones Only 
				(
					selectSkinBones()
					if hasProp == true do
					(
						selectMore $'Bip001 Prop1'
					)
					if hasXtraProp == true do 
					(
						selectMore $'Bip001 Prop2'
					)

					if (isValidNode $SC_LinkTarget) == true do
					(
						selectMore $'SC_LinkTarget'
					)
				)
				3 : --when Export Meshes Only 
				(
					selectMeshesOnly()
					getSkinObjs()
				)
			)
					
		)
		3 : --when Export Weapon Species 
		(

			if MultiWeaponExporter.mlb_weaponList.items.count >= 1 then 
			(
				for i in MultiWeaponExporter.mlb_weaponList.items do 
				(
					local validedNode = getNodeByName i 
					local SkinnedBones = getSkinBone validedNode

					for i in SkinnedBones do 
					(
						if i.parent.name == "Weapon_Root" do 
						(
							select i.parent 
						)
					)

					weaponRoot = $Weapon_Root
					weaponRoot.parent = undefined
					weaponRoot.position.controller = Position_XYZ()
					weaponRoot.rotation.controller = Euler_XYZ()
					weaponRoot.transform = $Root.transform 

					select (grabchildren weaponRoot)
				)
				
			)
			else 
			(
				weaponRoot = $Weapon_Root
				weaponRoot.parent = undefined
				weaponRoot.position.controller = Position_XYZ()
				weaponRoot.rotation.controller = Euler_XYZ()
				weaponRoot.transform = $Root.transform 

			


				Case exportOption of 
				(
					1 : --when Export Bones and Mesh 
					(	
						select (grabchildren weaponRoot)
					)
					2 : --when Export Bones On;y 
					(
						select (grabchildren weaponRoot)
					)
					3 : -- when Export Meshes Only 
					(
						select (grabchildren weaponRoot)
					)
				)
			)
		)
		4 : --Temp export 
		(
			selectSkinBones()
			ar_skinObjs = getSkinObjs()
			selectMore ar_skinObjs
			selectMore $Root
			selectMore $Bip001
			selectMore $Bip001_Pelvis
			selectMore $Bip001_Spine
			selectMore $Bip001_Spine1
			selectMore $Bip001_Spine2
			selectMore $Bip001_Neck
			selectMore $Bip001_Head
		)
		5 : --Camera export 
		(
			deselect $*
			select $Root 
			selectMore $Camera_Bone
		)
	)
	if exportOption == 4 do
	(
		deselect $*
		select $*
	)

	if isvalidNode $SC_WeaponConstraint do
	(
		selectMore $SC_WeaponConstraint
	)
	if isvalidNode $SC_WeaponConstraintL do 
	(
		selectMore $SC_WeaponConstraintL
	)
	if isvalidNode $SC_LinkTarget do 
	(
		selectMore $SC_LinkTarget
	)
)	

fn ExtractFile = --code Wrap
(
	local exportPath = BatchDir + "\\"
	if MaxFileName != undefined then 
	(
		if specificName == "" then
		(
			local exportName = substituteString MaxFileName ".max" ".fbx"
			local exportFileName = exportPath + exportName 
		)
		else 
		(
			local exportName = specificName + ".fbx"
			local exportFileName = exportPath + exportName
		)

		format "\nExportFileName : %\n" exportFileName
		/*BackUp File*/
		saveMaxFile (backUpDir + MaxFileName) quiet:true useNewFile:false
		/*BackUp File*/ 
		exportFile exportFileName #noPrompt selectedOnly:True using:FBXEXPORTER
		fileName = getFilenameFile exportFileName 
		--setclipboardText "\n"exportFileName
		return exportFileName
	)
	else
	(
		--exportName = ""
		mesaageBox "first, save this Scene\nAnd Redo."	title:"script Alert"
	)
	--fileName = getFilenameFile exportName 
)

fn convertPropR = --convert prop bone to heirachied dummy
(

	if not (isValidNode $SC_WeaponConstraint) do 
	(
		--Initialise R node start 
		SC_WeaponConstraint = dummy()
		SC_WeaponConstraint.name = "SC_WeaponConstraint"
		--SC_WeaponConstraint.transform  = $'Bip001 R Hand'.transform 
		SC_WeaponConstraint.pos.controller = position_constraint()
		SC_WeaponConstraint.rotation.controller = Orientation_Constraint()
		--Initialise node end 

		isUsingCTRL = isValidNode $'Bip001 Ctrl Prop1' 
		if isUsingCTRL then
		(
			--KCJ / 21.0511 Prop Error Fix
			--SC_WeaponConstraint.parent = $'Bip001 R Hand Ctrl'
			SC_WeaponConstraint.parent = $'Bip001 R Hand'
			SC_WeaponConstraint.pos.controller.appendTarget $'Bip001 Ctrl Prop1' 100.0
			SC_WeaponConstraint.rotation.controller.appendTarget $'Bip001 Ctrl Prop1' 100.0
		)
		else 
		(
			SC_WeaponConstraint.parent = $'Bip001 R Hand'
			SC_WeaponConstraint.pos.controller.appendTarget $'Bip001 Prop1' 100.0
			SC_WeaponConstraint.rotation.controller.appendTarget $'Bip001 Prop1' 100.0
		)
	)
)
fn convertPropL = 
(

	if not (isValidNode $SC_WeaponConstraintL) do
	(
		--Initialise L node start 
		SC_WeaponConstraintL = dummy()
		SC_WeaponConstraintL.name = "SC_WeaponConstraintL"
		--SC_WeaponConstraint.transform  = $'Bip001 R Hand'.transform 
		SC_WeaponConstraintL.pos.controller = position_constraint()
		SC_WeaponConstraintL.rotation.controller = Orientation_Constraint()
		--Initialise node end 

		isUsingCTRL = isValidNode $'Bip001 Ctrl Prop2' 
		if isUsingCTRL then
		(
			--KCJ / 21.0511 Prop Error Fix
			--SC_WeaponConstraint.parent = $'Bip001 L Hand Ctrl'
			SC_WeaponConstraintL.parent = $'Bip001 L Hand'
			SC_WeaponConstraintL.pos.controller.appendTarget $'Bip001 Ctrl Prop2' 100.0
			SC_WeaponConstraintL.rotation.controller.appendTarget $'Bip001 Ctrl Prop2' 100.0
		)
		else 
		(
			SC_WeaponConstraintL.parent = $'Bip001 L Hand'
			SC_WeaponConstraintL.pos.controller.appendTarget $'Bip001 Prop2' 100.0
			SC_WeaponConstraintL.rotation.controller.appendTarget $'Bip001 Prop2' 100.0
		)
	)
)	-- KCJ Add Skin
	/*
	geoList = for obj in objects where (classof obj == PolyMeshObject) collect obj
	skinOps.addBone geoList[1].modifiers[#Skin] SC_WeaponConstraint 1
	*/ --Set commented by MINOMI 2021/05/11

Try(closeRolloutFloater theFloater) Catch()

rollout 'Exporter' "Exporter 2.0" width:505 height:723
(
	button 'btn_selectFiles' "Select Files" pos:[19,21] width:158 height:90 align:#left
	button 'eveLogo' "11" pos:[195,21] width:90 height:90 images:#(eveLogoBMP, eveLogoBMP,1, 1,1,1,1,1)
	--button 'eveLogo' "11" pos:[195,21] width:90 height:90 images:#(underConstructionPNG, underConstructionPNG,1, 1,1,1,1,1)
	listBox 'mlb_FileNames' "File List" pos:[28,139] width:433 height:16 align:#left
	button 'btn_FilePath' "Select Export Path" pos:[24,394] width:93 height:34 align:#left
	editText 'et_FilePath' "" pos:[120,393] width:343 height:35 align:#left
	dropDownList 'ddl_Species' "Species" pos:[20,461] width:448 height:41 items:#("PC(EVE)", "MOB(NA)", "Weapon(WP)", "Parts(EVE)", "CAM") align:#left selection:Species
	dropDownList 'ddl_exportOption' "Export Option" pos:[20,500] width:448 height:41 items:#("Skeletal Mesh", "Animation", "Selected Mesh Only", "All", "Selected", "Seperated") selection:exportOption align:#left
	button 'btn_export' "Export" pos:[305,20] width:158 height:90 align:#left
	groupBox 'grp1' "Import / Export" pos:[9,5] width:467 height:118 align:#left
	progressBar 'pgb_process' "Exporting..." pos:[22,660] width:440 height:20 align:#left
	checkBox 'chk_leftWeaponAnim' "Left Hand Anim" pos:[22,700] align:#left
	checkBox 'chk_propConvert' "Use Prop System -> " pos:[150,700] align:#left
	checkBox 'chk_propLeft' "Left" pos:[260,700] align:#left enabled:false
	checkBox 'chk_propRight' "Right" pos:[305,700] align:#left enabled:false
	--edittext 'et_processText' "" pos:[17,650] width:447
	edittext 'et_exportName' "Export Name : " pos:[20,565] width:250
	--checkBox 'chx_isMultiExport' "Multi Export?" pos:[20,600] tooltip:"if unchecked, Export Scene objects"
	checkBox 'chk_withMorph' "Morph?" pos:[145,600] width:50 checked:false 
	checkBox 'chk_BaseRemover' "Remove Key of Base Node?" pos:[200,600] checked:false 
	Button 'btn_multiWeapon' "Has Multi Weapon" pos:[350,595] checked:false --enabled:false
	--checkBox 'chk_pelvTri' "SET OFF Pelvis Triangle" pos:[20,600]
	--checkBox 'chk_xfront' "Force X Front" pos:[350,600]
	groupBox 'grp2' "" pos:[12,126] width:468 height:314 align:#left
	groupBox 'grp3' "" pos:[13,453] width:468 height:170 align:#left -- export Option GroupBox
	groupBox 'grp4' "Progress" pos:[13,635] width:468 height:90 align:#left
	
	
	On Exporter open do
	(
		et_FilePath.text = ( BatchDir as string )
		--ddl_FacialSetting.enabled = false
		--et_processText.text = "Preparing for the export..."
		--makeExportogDir()
		--Species = getINISetting rolloutSetting "personalSetting" "Species"
		--exportOption = getINISetting rolloutSetting "personalSetting" "exportOption"

		--messageBox "[UPDATE] : Morph Modifier Reset after Export" title:"Update Note from MINOMI <2021.05.18>"
	)
	on btn_multiWeapon pressed do 
	(
		filein "Z:\ART_Backup\Script\Exporter\WeaponExporter.ms"
	)
	on chk_propConvert changed val do 
	(
		chk_propRight.enabled = val 
		chk_propLeft.enabled = val 
		chk_propRight.checked = val 
	)
	on eveLogo pressed do
	(
		--ShellLaunch "http://dev.shiftup.co.kr/jira" ""
		fileIn (projectDir + "\\CharacterChange\\CharacterChange.ms")
	)
	on chk_leftWeaponAnim changed state do 
	(
		leftWeaponAnim = state 
	)
	On btn_selectFiles Pressed do
	(
		ar_MaxFiles = fn_getMultipleFiles multi:true fileFilter:"MAX Files (*.max)|*.max"
		mlb_FileNames.items = ar_MaxFiles
		--chx_isMultiExport.checked = true
	)
	
	On ddl_Species selected i do
	(
		if i != 1 then
		(
			--ddl_FacialSetting.enabled = false
			facialSetting = 0
		)
		else if i == 3 then 
		(
			chk_multiWeapon.enabled = true 
		)
		else BatchDir
		(
			--ddl_FacialSetting.enabled = true
			facialSetting = 1
		)
		Species = i
		setINISetting rolloutSetting "personalSetting" "Species" ( Species as string )
	)
	
	On ddl_exportOption selected i do
	(
		if i == 3 or i == 4 then
		(
			ddl_Species.enabled = false
			--ddl_FacialSetting.enabled = false
		)
		else if i == 1 then 
		(
			ddl_Species.enabled = true
			--ddl_FacialSetting.enabled = false
		)
		else
		(
			ddl_Species.enabled = true
			--ddl_FacialSetting.enabled = true
		)
		exportOption = i
		setINISetting rolloutSetting "personalSetting" "ExportOption" ( exportOption as string )
	)
	
	On chk_withMorph changed state do
	(
		exportWithMorph = state

	)
	
	On et_exportName changed txt do
	(
		specificName = txt 
	)
	On btn_FilePath Pressed do
	(
		local savePath = getSavePath "Set Output Path"
		if savePath != undefined then 
		(
			et_FilePath.text = savePath
		)
		else 
		(
			et_FilePath.text = ""
		)
		BatchDir = et_FilePath.text
		File = createFile LastExportPath
		Format BatchDir to:File
		close File
	)
	on btn_export Pressed do
	(
		--et_processText.text = "Exporting..."
		cnt = 0 
		
		if ( ddl_Species.enabled != true ) then Species = 0
		else Species = ddl_Species.selection
		--if ( ddl_FacialSetting.enabled != True ) then FacialSetting = 0
		--else FacialSetting = ddl_FacialSetting.selection

		format "\n%,%,%\n" Species exportOption facialSetting
		animationExportSetUp (frameRate as float) exportWithMorph


		

		if ar_MaxFiles.count != 0 then --do Multi Export 
		(
			disableSceneRedraw()
			specificName = ""
			et_exportName.text = specificName
			
			for i in ar_MaxFiles do 
			(
				loadMaxFile i quiet:true
				units.systemScale = 1

				if exportWithRootMotion == true do 
				(
					if RootMotionMaker.Species.Selection == 1 then 
					(
						fileIn "\\\\10.220.70.12\\eve\\ART_Backup\\Script\\RootMotionExtracter\\RootMotionTest.ms"
					)
					else if RootMotionMaker.Species.Selection == 2 then 
					(
						fileIn "\\\\10.220.70.12\\eve\\ART_Backup\\Script\\RootMotionExtracter\\RootMotion_MultiLegs.ms"
					)
				)
				if Exporter.chk_BaseRemover.checked do 
				(
					filein "\\\\10.220.70.12\\eve\\ART_Backup\\Script\\RootMotionExtracter\\BaseExtracter.ms"
				)
				/*
				if chk_pelvTri.checked do 
				(
					setTrianglePelvis()
				)
				if chk_xfront.checked do 
				(
					makeRootXFront()
				)
				*/
				--hideByCategory.none()
				--unhide $*
				--isRootNodeisRoot() -- Root노드가 없으면 Root노드를 생성, hierachy도 맞춰줌 
				if Exporter.chk_propConvert.checked do 
				(
					if Exporter.chk_propRight.checked do convertPropR()
					if Exporter.chk_propLeft.checked do convertPropL()
					--convertProp Exporter.chk_propRight.checked 
				)			
				
				undo on 
				(
					if exportWithMorph do 
					(
						validMorphers = for i in $* where ( (classof i.modifiers[2]) == Morpher ) collect i 
						for i in validMorphers do
						(
							basedMorpher = i.modifiers[2]
							addModifier i basedMorpher 
							deleteModifier i 3
							--morphShuffle = true 
						)
					)-- if exportWithMorph is avaiable, collect meshes which have morph as 2nd modifier and reverse with 1st modifier(mostly skin) 
				)

				selectBeforeExport()

				animationExportSetUp (frameRate as float) exportWithMorph

				fileName = ExtractFile()

				if exportWithMorph do (max undo)


				--logDir = makeExportogDir()
				--collectUserLog logDir fileName  
				cnt += 1
				pgb_process.value = (100.0 / ar_MaxFiles.count ) * cnt
			)
			if pgb_process.value == 100.0 OR cnt == ar_MaxFiles.count do
			(
				--messageBox "Export Process Compelete" Title:"Script Alert" 
				--et_processText.text = "Export Process Complete"
			)
			EnableSceneRedraw()
		)
		else -- do Scene Export 
		(

			units.SystemScale = 1

			if exportWithRootMotion == true do 
			(
				makeRootMotion RootMotionMaker.Species.Selection
			)
			if Exporter.chk_BaseRemover.checked do 
			(
				filein "\\\\10.220.70.12\\eve\\ART_Backup\\Script\\RootMotionExtracter\\BaseExtracter.ms"
			)
			/*
			if chk_pelvTri.checked do 
			(
				setTrianglePelvis()
			)
			if chk_xfront.checked do 
			(
				makeRootXFront()
			)
			*/
			--isRootNodeisRoot() -- Root노드가 없으면 Root노드를 생성, hierachy도 맞춰줌 
			if Exporter.chk_propConvert.checked do 
			(
				if Exporter.chk_propRight.checked do convertPropR()
				if Exporter.chk_propLeft.checked do convertPropL()
				--convertProp Exporter.chk_propRight.checked 
			)
			
			
			--Morph Shuffle 
			undo on 
			(
				if exportWithMorph do 
				(
					validMorphers = for i in $* where ( (classof i.modifiers[2]) == Morpher ) collect i 
					for i in validMorphers do
					(
						basedMorpher = i.modifiers[2]
						addModifier i basedMorpher 
						deleteModifier i 3
						--morphShuffle = true 
					)
				)-- if exportWithMorph is avaiable, collect meshes which have morph as 2nd modifier and reverse with 1st modifier(mostly skin) 
			)
			
			selectBeforeExport()
			
			fileName = ExtractFile()
			setclipboardText fileName
			if exportWithMorph do (max undo)
			--max undo
			--logDir = makeExportogDir()
			--collectUserLog logDir fileName  
			pgb_process.value = 100
			if pgb_process.value == 100 do 
			(
				--messageBox "Export Process Compelete" Title:"Script Alert" 
				--et_processText.text = "Export Process Complete"
			)

			
			if exportOption == 6 do 
			(
				resetMaxFile #noprompt
				importfile fileName #noPrompt using:FBXIMP

				$Bip001_Head.parent = Undefiend

				sleep 0.5
				$Bip001_Head.transform = (matrix3 [0,3.13916e-07,1] [-3.96569e-06,-1,3.13916e-07] [1,-3.96569e-06,0] [0,0,0])
				objs = getSkinObjs()
				bones = getSkinBone objs[1]

				select objs 
				selectMore bones

				$Bip001_Head.transform = (matrix3 [0,3.13916e-07,1] [-3.96569e-06,-1,3.13916e-07] [1,-3.96569e-06,0] [0,0,0])

				exportFile fileName #noPrompt selectedOnly:True using:FBXEXPORTER 

			)
			
			/*
			if morphShuffle do 
			(
				validMorphers = for i in $* where ( (classof i.modifiers[2]) == Skin ) collect i 
				for i in validMorphers do
				(
					basedSkin = i.modifiers[2]
					addModifier i basedSkin 
					deleteModifier i 3
					morphShuffle = false
				)
			
			)
			*/
		)
	)
)

rollout awesomeTools "Awesome Tools!(BETA)"
(
	button btn_ctrlGlue "Controller Glue" across:4
	button btn_somi "SOMI"
	button btn_backupFolder "BackUpFolder"
	button btn_FaceMerger "FaceMerger"
	button btn_bakeCam "CameraBaker" across:4
	button btn_skinTheif "SkinTheif"
	button btn_scaleMaster "Scene Scaling"
	on btn_ctrlGlue pressed do 
	(
		filein (projectDir + "ControllerGlue\\ControllerGlue.ms")
		filein (projectDir + "ControllerGlue\\RolloutHandler.ms")
	)

	on btn_somi pressed do 
	(
		filein (projectDir + "SOMI\\somi.ms")
	)

	on btn_backupFolder pressed do
	(
		ShellLaunch "\\\\10.220.70.12\\eve\\ART_Backup\\TA_TestFolder\\CollectedBackUp\\" ""
	)

	on btn_FaceMerger pressed do
	(
		filein (projectDir + "CinemaFacialTool\\FaceMerger.ms")
	)

	on btn_bakeCam pressed do 
	(
		filein (projectDir + "LinkSkill_CamBoneMaker\\cameraBaker.ms")
	)
	on btn_skinTheif pressed do 
	(
		filein (projectDir + "SkinThief\\SkinTheif.ms")
	)
	on btn_scaleMaster pressed do 
	(
		filein (projectDir + "ScaleMaster\\scaleMaster.ms")
	)
)

rollout cinemaArtists "Production"
(
	button btn_pressme1 "Facial Maker" across:3
	button btn_pressme2 "Show Maker"
	button btn_pressme3 "Rule Move Maker"
	on btn_pressme1 pressed do 
	(
		filein "Z:\\ART_Backup\\Script\\FacialMaker\\Visage.ms"
	)

	on btn_pressme2 pressed do
	(
		filein "Z:\\ART_Backup\\Script\\ShowMaker\\showMaker.ms"
	)

	on btn_pressme3 pressed do
	(
		fileIn "Z:\\ART_Backup\\Script\\RuleMoveMaker\\ruleMoveMaker.ms"
	)
)

theFloater = newRolloutFloater "EVE Tool" 505 960

addRollout 'Exporter' theFloater rolledUp:false
addRollout 'RootMotionMaker' theFloater rolledUp:false
addrollout 'rltKeyReducer' theFloater rolledUp:true
addRollout 'setKeyForSelected' theFloater rolledUp:true
addRollout 'rBipCopytoSel' theFloater rolledUp:true 
addRollout 'BVHRetargeter' theFloater rolledUp:true 
addRollout 'LocoMocapRotator' theFloater rolledUp:true 
addrollout 'awesomeTools' theFloater rolledUp:false
addRollout 'attrManager' theFloater rolledUp:false 
addrollout 'cinemaArtists' theFloater rolledUp:false
--createDialog rltKeyReducer 400 80
--addRollout 'showMaker' theFloater rolledUp:true 
