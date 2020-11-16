FN AnimationDataTo_ExPose =
(
	
	Set AniMate On
	AnimRange = AnimationRange.end As String
	int_AnimRange = AnimRange As Integer
	for i in selection do
	(
		Expose = ExposeTM Size:7 Cross:off AxisTripod:on
		Expose.parent = undefined 
		for j=0 to int_AnimRange do
		(
			SliderTime = j
			Expose.transform = i.transform
			--Expose.parent = i.parent
			Expose.name = i.name + "_expose"
			Expose.exposeNode = i.parent 
		)
	)
)
FN Adoption_animData =
(
	AnimRange = AnimationRange.end As String
	int_AnimRange = AnimRange As Integer
	Set Animate On
	for i in selection do
	(
		ExposeTMs = GetNodeByName (i.name as string + "_expose")
		for j=0 to int_AnimRange do
		(
			SliderTime = j
			i.transform = ExposeTMs.transform 
		)
	)
)

fn getMultipleFiles =
(
	theDialog = dotNetObject "System.Windows.Forms.OpenFileDialog" --create a OpenFileDialog 
	theDialog.title = "PLEASE Select One Or More Files" --set the title
	theDialog.Multiselect = true --allow multiple files to be selected
	theDialog.Filter = "All Files (*.*)|*.*|MAX Files (*.max)|*.max" --specify the filter
	theDialog.FilterIndex = 2 --set the filter drop-down list to All Files
	result = theDialog.showDialog() --display the dialog, get result into variable
	result.ToString() --when closed, convert the result to string
	result.Equals result.OK --returns TRUE if OK was pressed, FALSE otherwise
	result.Equals result.Cancel --returns TRUE if Cancel was pressed, FALSE otherwise
	theFilenames = theDialog.fileNames --the selected filenames will be returned as an array
	return theFilenames
)

fn makeBipFileName maxSceneName = 
(
    local bipName = substituteString maxSceneName ".max" ".bip"

    return bipName 
)

fn makeMaxFileName bipName = 
(
    local maxName = substituteString bipName ".bip" ".max"
    return maxName 
)

fn makePastedBoneName strNodeName = 
(
    if ( findString strNodeName " R " != undefined ) then 
        local strOppositeNodeName = substituteString strNodeName " R " " L "

    else if ( findString strNodeName " L " != undefined ) then 
        local strOppositeNodeName = substituteString strNodeName " L " " R "

    else 
		local strOppositeNodeName = strNodeName
    return strOppositeNodeName 
)

fn retargetBone = --Write Down Custom Retarget Setting
(
	SliderTime = 1f
	set Animate On 
-- Bip Finger Retarget -- 
	if (isValidNode $'Bip001 L Finger0') == True do 
	(
		in coordsys local rotate $'Bip001 L Finger0' (eulerAngles 90 0 0)
		in coordsys local rotate $'Bip001 L Finger0' (eulerAngles 0 0 25)	
	)	
	if (isValidNode $'Bip001 R Finger0') == true do 
	(
		in coordsys local rotate $'Bip001 R Finger0' (eulerAngles 90 0 0)
		in coordsys local rotate $'Bip001 R Finger0' (eulerAngles 0 0 -25)	
		in coordsys local rotate $'Bip001 R Finger0' (eulerAngles 0 -20 0)	
		in coordsys local rotate $'Bip001 R Finger0' (eulerAngles 0 0 5)	
	)

	-- Bip Clavicle Retarget --
	in coordsys local rotate $'Bip001 R Clavicle' (eulerAngles 0  7.5 0)
	in coordsys local rotate $'Bip001 L Clavicle' (eulerAngles 0 -7.5 0)
-- Bip Head Retarget --
	in coordsys local rotate $'Bip001 Head' (eulerAngles 0 0 -10)
-- Bip Spine4 retarget --
	in coordsys local rotate $'Bip001 Spine4'(EulerAngles 0 0 -10)
--Bip UpperArm retarget
	in coordsys local rotate $'Bip001 R UpperArm'(EulerAngles 0 10 0)
	in coordsys local rotate $'Bip001 L UpperArm'(EulerAngles 0 -10 0)
	
	set Animate off 
)

fn makeBipFileName savePath FileName =
(
	local getFileName = getFileNameFile FileName
	
	return (savePath + "\\" + getFileName + ".bip")
)

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
	close file 
)


fn animationExportSetUp =
(
	FbxExporterSetParam "Animation" true
	
	FbxExporterSetParam "UseSceneName" true
	
	FbxExporterSetParam "BakeAnimation" true
	FbxExporterSetParam "BakeFrameStart" animationRange.start
	FbxExporterSetParam "BakeFrameEnd" animationRange.end
	FbxExporterSetParam "BakeFrameStep" 1
	FbxExporterSetParam "BakeResampleAnimation" false
	FbxExporterSetParam "Resampling" 60.0
	FbxExporterSetParam "FilterKeyReducer" false
	FbxExporterSetParam "Skin" true	
	FbxExporterSetParam "Shape" false
	
	FbxExporterSetParam "SmoothingGroups" true	 	--Export With Smoothing Group
	
	FbxExporterSetParam "UpAxis" #z						 	--Up Axis -> +Z
	FbxExporterSetParam "Lights" false					 	--Export WithOut Light
	FbxExporterSetParam "ASCII" true						 	--FBX Format -> ASCII
	FbxExporterSetParam "ConvertUnit" #custom unit	--unit Size -> Custom
	
	
	
) -- from FBX Export Parameter Selection

fn getBodyNodes = 
(	
	File = BodyNodes
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
	UndefinedNodeinScene = findItem ar_selection undefined 
	if UndefinedNodeinScene == 0 then
	(
		select ar_Selection
	)

	else 
	(
		messageBox "This file(Scene) doesn't seem to be \nthe right file of PC(EVE) " title:"Script Alert"
		format "undefined Node num : %" UndefinedNodeinScene
		
		/* Alert는 해주지만 뽑긴 뽑는다  */
		for i in ar_selection do 
		(
			if i != undefined do 
			(
				selectMore i 
			)
		)
	)
	--selectMore $SC_WeaponConstraint
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
		local bnRootNode = boneSys.createBone [ 0, 0, 0 ] [ 0, -20, 0 ] [ 0, 0, 1 ] -- Root를 -Y를 Front로 놓고 생성 
		bnRootNode.name = "Root"
		$Bip001.parent = bnRootNode 
		print "Root Node Created"
	)

	Return isRoot 
)

fn selectMeshesOnly = --wrappingCode 
(
	deselect $*
	ar_meshObjs = getMeshObjs()
	select ar_meshObjs
)

fn showBiped = 
(
	local bips = for i in $* where classof i == Biped_Object collect i 
	select bips 
	max hide inv
	
	local meshes = for i in $* where classof i == PolyMeshObject collect i 
	unhide meshes
)


fn selectSkinBones = --wrappingCode 
(
	ar_skinObjs = getSkinObjs()
	ar_skinBones = #()
	for i=1 to ar_SkinObjs.count do
	(
		local skinBone = getSkinBone ar_skinObjs[i]
		append ar_skinBones skinBone
	)
	for i in ar_skinBones do selectMore i
)

fn selectBeforeExport =
(
	case species of
	(
		1 : --when Export PC Species
		(
			
			getBodyNodes() -- get Bone Object 
			Case exportOption of
			(
				1 : --when Export bones and Mesh 
				(
					ar_skinObjs = getSkinObjs()
					selectMore ar_skinObjs
					try /* 링크 카메라용 본 */ 
					(
						selectMore $Link_Camera
						selectMore $SC_WeaponConstraint
					)
					Catch()

					format "select Bones and Mesh PC[EVE]\n"
				)
				2 : -- when Export Bones Only 
				(
					if facialSetting == 2 do -- Export facialNodes Only 
					(							
						deselect $* 
						getFacialNodes()
					)
					try /* 링크 카메라용 본 */ 
					(
						selectMore $Link_Camera
						selectMore $SC_WeaponConstraint
					)
					Catch()
				) 
				3 : --when Export Meshes Only 
				(
					selectMeshesOnly()
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
					selectMore ar_skinObjs 
					try /* 링크 카메라용 본 */ 
					(
						selectMore $Link_Camera
						--selectMore $SC_WeaponConstraint
					)
					Catch()
				)
				2 : --when Export Bones Only 
				(
					selectSkinBones()
					try /* 링크 카메라용 본 */ 
					(
						selectMore $Link_Camera
						--selectMore $SC_WeaponConstraint
					)
					Catch()
				)
				3 : --when Export Meshes Only 
				(
					selectMeshesOnly()
				)
			)
					
		)
		3 : --when Export Weapon Species 
		(
			Case exportOption of 
			(
				1 : --when Export Bones and Mesh 
				(	
					ar_skinBones = grabchild $Weapon_Root
					select ar_skinBones
				)
				2 : --when Export Bones On;y 
				(
					ar_skinBones = grabchild $Weapon_Root
					select ar_skinBones
				)
				3 : -- when Export Meshes Only 
				(
					selectMeshesOnly()
				)
			)
		)
	)
	if exportOption == 4 do
	(
		deselect $*
		select $*
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

		exportFile exportFileName #noPrompt selectedOnly:True using:FBXEXPORTER
		fileName = getFilenameFile exportFileName 
		return fileName
	)
	else
	(
		--exportName = ""
		mesaageBox "first, save this Scene\nAnd Redo."	title:"script Alert"
	)
	--fileName = getFilenameFile exportName 
)

fn makePastedBoneName strNodeName = 
(
    if ( findString strNodeName " R " != undefined ) then 
        local strOppositeNodeName = substituteString strNodeName " R " " L "

    else if ( findString strNodeName " L " != undefined ) then 
        local strOppositeNodeName = substituteString strNodeName " L " " R "

    else 
		local strOppositeNodeName = strNodeName
    return strOppositeNodeName 
)

fn makeMirrorBone lBone = 
(
    local sPoint = lBone.pos
    local ePoint = (preTransLate lBone.transform [(lBone.inode.stretchTM.scale.x *lBone.length),0,0]).pos -- get bone end pos, compensate for stretch

    local rBone = boneSys.createBone [-sPoint.x,sPoint.y,sPoint.z]  [-ePoint.x,ePoint.y,ePoint.z] -lBone.dir

    rBone.name = makePastedBoneName lBone.name
    --rBone.parent  = lBone.parent 
    rBone.Length = lBone.Length 

    arProperties = getPropNames lBone 

    for i in arProperties do
    (
        propertiesToLoop = execute ( "$" + "'" + lBone.name + "'" + "." + (i as string) )
        setProperty rBone i propertiesToLoop
    )
)

fn makeMirrorHelper lHelper =
(
    if classof lHelper == ExposeTm then
    (
        local rHelper = ExposeTM()
    )
    else if classof lHelper == Point then 
    (
        local rHelper = Point() 
    )
    else if classof lHelper == dummy then 
    (
        local rHelper = dummy()
    )

    rHelper.transform = lHelper.transform *  matrix3 [-1,0,0] [0,1,0] [0,0,-1] [0,0,0]

    rHelper.pos = lHelper.pos
    
    rHelper.pos.x = lHelper.pos.x * -1 

    rHelper.name = makePastedBoneName lHelper.name

    arProperties = getPropNames lHelper 
    
    --except ExposeTM
    if ( classof lHelper ) != ExposeTm do 
    (
        for i in arProperties do
        (
            propertiesToLoop = execute ( "$" + "'" + lHelper.name + "'" + "." + (i as string) )
            setProperty rHelper i propertiesToLoop
        )
    )
)

fn oppositeParentFinder childNode = 
(
    local strOppoisteChildName = makePastedBoneName childNode.name 
    local nOppositeChildNode = getNodeByName strOppoisteChildName
    local nOppositeParentNode = nOppositeChildNode.parent 
    local parentNodeName = makePastedBoneName nOppositeParentNode.name
    local parentNode = getNodeByName parentNodeName 

    childNode.parent =  parentNode 

)


fn setExposeNode ETMNode = 
(
	local strOppositeETM = makePastedBoneName ETMNode.name 
	local nOppositeETM = getNodebyName strOppositeETM
    ETMNode.ExposeNode =  getNodeByName ( makePastedBoneName (nOppositeETM.ExposeNode.name))
    ETMNode.localReferenceNode = getNodeByName ( makePastedBoneName (nOppositeETM.ExposeNode.name) )
    ETMNode.useParent = false 
)

fn getFloatWireNodes nBone = 
(
    deselect $* 
    local XposController = nBone.pos.controller.x_position.controller
    if ( classof XposController ) == Float_Wire do 
    (
        selectMore nBone 
    )
    local YposController = nBone.pos.controller.Y_position.controller
    if ( classof YposController ) == Float_Wire do 
    (
        selectMore nBone 
    )
    local ZposController = nBone.pos.controller.Z_Position.controller
    if ( classof ZposController ) == Float_Wire do 
    (
        selectMore nBone 
    )

    local XRotController = nBone.rotation.controller.X_Rotation.controller
    if ( classof XRotController == Float_Wire ) do 
    (
        selectMore nBone 
    )
    local YRotController = nBone.rotation.controller.Y_Rotation.controller
    if ( classof YRotController == Float_Wire ) do 
    (
        selectMore nBone 
    )
    local ZRotController = nBone.rotation.controller.Z_Rotation.controller
    if ( classof ZRotController == Float_Wire ) do 
        (
            selectMore nBone 
        )
)


fn makeRootMotion = 
(
		if $Bip001.parent != $Root do 
		(
			$Bip001.parent = $Root 
		)

		isRootSubHere = isValidNode $Root_Sub

		if isRootSubHere == false do 
		(
			A = Dummy()
			A.name = "Root_Sub"
			A.parent = $Root
			$Bip001.parent = $Root_Sub 	
		)

		setInheritanceFlags $Root_sub #{7..9}

		sleep 1 

		sobj = $Root
		tobj = $Bip001

		select $Root_Sub
		setInheritanceFlags $Root_sub #{7..9}

		redrawViews() 	 

		astart = animationrange.start
		aend = animationrange.end

		stepCount = 1 

		Exposer = Dummy() 

		PropExposer = Dummy() 

		CAMExposer = Dummy()

		Try 
		(
			$'Link_Camera'.parent = world 
		)
		Catch() 

		animate on
		(
			for i =astart to aend do
			(
				slidertime = i
				sobj.transform = tobj.transform
				Exposer.transform = $Bip001.transform 

				Try 
				(
					PropExposer.transform = $Bip001_Prop1.transform 
					CAMExposer.transform = $'Link_Camera'.transform 
				)
				Catch() 

				
				if IsKindOf sobj Biped_Object then
				(
					biped.setTransform sobj #pos tobj.transform.position true
					biped.setTransform sobj #rotation tobj.transform.rotation true
				)
			)
		)
		SliderTime = 0f 
		
		$Root.transform = $Root_Sub.transform 
		DeleteKeys $Root.position.controller.Z_Position.controller #allKeys
		DeleteKeys $Root.rotation.controller.X_Rotation.controller #allKeys
		DeleteKeys $Root.rotation.controller.Y_Rotation.controller #allKeys

		delete $Root_Sub 
		biped.createLayer $Bip001.controller 1 "RMotionLayer01"
		
		$Bip001.parent = $Root 

		Try 
		(
			$'Link_Camera'.parent = $'Root' 
		)
		Catch() 

		set Animate on 
		for i = AnimationRange.start to AnimationRange.end do 
		(
			SliderTime = i 
			$Bip001.transform = Exposer.transform 
			
			Try 
			(
				$'Bip001 Prop1'.transform = PropExposer.transform 
				$'Link_Camera'.transform = CAMExposer.transform 
			)
			Catch() 
		)

		sliderTime = 0f

		delete Exposer 
		delete propExposer 
		delete CAMExposer 

--Special Thanks to JJ and Nopie

-- Script by Minomi /
)

fn switchPathFlag str_Dir = 
(
	local switchedDir = SubstituteString str_Dir "\\" "/"
	return switchedDir
)

fn getSkinBoneName obj  =					--skin�� bone �̸��� �迭�� ������
(
	setCommandPanelTaskMode mode:#modify  			-- modfiy pannel ����
	select obj														  			-- object ����
	skinModifier =  Obj.modifiers[#Skin]              			-- skinModifier�� ����ȭ
		
	boneCount = skinOps.GetNumberBones skinModifier	--skin�� ����� Bone ������ �˾Ƴ�
		
	boneNames = for i in 1 to boneCount collect skinOps.GetBoneName skinModifier i 1	--bonName������ ��Ų�� ����� Bone name (string)������ ����
	return boneNames
)

fn getSkinBoneName obj  =					--skin된 bone 이름을 배열로 돌려줌
(
    setCommandPanelTaskMode mode:#modify  			-- modfiy pannel 선택
    select obj														  			-- object 선택
    skinModifier =  Obj.modifiers[#Skin]              			-- skinModifier의 변수화
        
    boneCount = skinOps.GetNumberBones skinModifier	--skin에 적용된 Bone 갯수를 알아냄
        
    boneNames = for i in 1 to boneCount collect skinOps.GetBoneName skinModifier i 1			--bonName변수에 스킨에 적용된 Bone name (string)정보를 대입
    skinBones = for i in boneNames collect getNodeByName i
    return skinBones
)

fn copyObjectToFile =
(
    thecopypastedir = getdir #autoback -- CHANGE THIS TO ANY FOLDER YOU WANT
	thecopypastefile = "\pastefile.max" --this is the filename to save as...
	thecopypastestring = thecopypastedir + thecopypastefile --this is the complete string
	
    if $ != undefined do 
    (
        saveNodes $ thecopypastestring --this saves ("copies") the objects as a file
    )
)

fn pasteObjectFromFile =
(
    thecopypastedir = getdir #autoback -- CHANGE THIS TO ANY FOLDER YOU WANT
	thecopypastefile = "\pastefile.max" --this is the filename to save as...
	thecopypastestring = thecopypastedir + thecopypastefile --this is the complete string

	mergemaxfile (thecopypastedir + thecopypastefile) #select --this merges ("pastes") and selects objects from file
)


function TBSetFunction n	buttonState	=
	 (

	 
	  bipRoots=#() --???????? bip?? ???? ????? ??? com?? ????? ???????.
	  bipLimbs=#() --???? ?�ԥ�??? ????? ???????? ?????? ?????? ????? ????? ????

	  
	  
	  bipLimbs[1]=#(#larm,2,n[1],1," L UpperArm")
	  bipLimbs[2]=#(#rarm,2,n[1],1," R UpperArm")
	  bipLimbs[3]=#(#larm,3,n[2],2," L ForeArm")
	  bipLimbs[4]=#(#rarm,3,n[2],2," R ForeArm")
	  bipLimbs[5]=#(#lleg,1,n[3],3," L Thigh")
	  bipLimbs[6]=#(#rleg,1,n[3],3," R Thigh")
	  bipLimbs[7]=#(#lleg,2,n[4],4," L Calf")
	  bipLimbs[8]=#(#rleg,2,n[4],4," R Calf")
	  

	  
	  
	  
	  TBExpressionA="try(
	TM=Limb.transform*inverse Limb.parent.transform
	vector=normalize (cross TM.row1 [1,0,0])
	angle=acos (normalize TM.row1).x
	(quat angle vector)*inverse TM.rotation)
catch((quat 0 0 0 1))"
	 --UpperArm Twist ?? ??????????

	  
	  
	  TBExpressionBa="try(
	TM=(matrix3 [1,0,0] [0,0,-1] [0,1,0] [0,0,0])*Limb.transform*inverse Limb.parent.transform
	vector=normalize (cross TM.row1 [1,0,0])
	angle=acos (normalize TM.row1).x
	TM.rotation*(quat -angle vector))
catch((quat 0 0 0 1))"
	 --R ForeArm Twist ?? ??????????
	  TBExpressionBb="try(
	TM=(matrix3 [1,0,0] [0,0,1] [0,-1,0] [0,0,0])*Limb.transform*inverse Limb.parent.transform
	vector=normalize (cross TM.row1 [1,0,0])
	angle=acos (normalize TM.row1).x
	TM.rotation*(quat -angle vector))
catch((quat 0 0 0 1))"
	 --L ForeArm Twist ?? ??????????
	  


	  TBExpressionC="try(
	TM=Limb.transform*inverse Limb.parent.transform
	vector=normalize (cross -TM.row1 [1,0,0])
	angle=acos -(normalize TM.row1).x
	(quat 0 1 0 0)*(quat angle vector)*inverse TM.rotation)
catch((quat 0 0 0 1))"
	  --Thigh Twist ?? ??????????
	  TBExpressionD="try(
	TM=Limb.transform*inverse Limb.parent.transform
	vector=normalize (cross TM.row1 [1,0,0])
	angle=acos (normalize TM.row1).x
	TM.rotation*(quat -angle vector))
catch((quat 0 0 0 1))"
	 --Calf Twist ?? ??????????
	  

	  
	  
	  
	  TBExtraExpressionA="try(
	(Limb.transform*inverse LimbParent.transform).rotation
	)
catch((quat 0 0 0 1))"
	  --UpperArm, Thigh ?? ???? ?????????? ????

	  
	  
	  TBExtraExpressionB="try(dependson TB
	TB.rotation.controller[1].value
	)
catch((quat 0 0 0 1))"
	 -- ForeArm, Calf ?? ???? ?????????? ????
	
	  LimbJointExpression = "try(
	Tm = (limb.transform* inverse limb.parent.transform)
	vector=normalize (cross TM.row2 [0,1,0])
	angle=(acos (normalize TM.row2).y)/2
	(quat angle vector))*inverse TM.rotation
catch((quat 0 0 0 1))"
	-- Elbow, Knee ???? ?????? ???? (?????? ?????? ??? ??????????? ????????)
	
	  LimbShoulderExpression ="try(
	Tm = (limb.transform* inverse limb.parent.transform)
	vector = normalize (cross TM.row1 [1,0,0])
	angle = (acos (normalize TM.row1).X)
	local quat1= (quat angle vector) , quat2=(TM.rotationpart)
	local dot = quat1.x*quat2.x + quat1.y*quat2.y + quat1.z*quat2.z+quat1.w*quat2.w
	if (dot < 0.0) do (quat2.x = -quat2.x; quat2.y = -quat2.y;quat2.z = -quat2.z; quat2.w = -quat2.w)
	slerp quat1 quat2  0.2)
catch((quat 0 0 0 1))"
	-- Shoulder ???? ?????? ???? ?????? ???????? weight?? 50???? ????? .(????????? ??????????? ?????? ?????????)
	
	
	  for i in selection do
	  (
		   if (classof i.controller==BipSlave_Control) then  
		   (
				if (finditem bipRoots i.controller.rootnode)==0 then
					append bipRoots i.controller.rootnode
		   )
		   else if (classof i.controller==Vertical_Horizontal_Turn) then
		   (
			   if (finditem bipRoots i)==0 then
					append bipRoots i
		   )

	  ) --bip ?? com?? ??? bipRoots ????? ???????.
	  
	--for ???? ????????
	 /*
	  for i in selection do
	  (
			if classof i == Biped_Object do
			(
			
				if (finditem bipRoots i.controller.rootnode)== 0 do 
				(
					append bipRoots i.controller.rootnode
				)
			)
	  )
	*/
	--for ???? ???? -end- 	  

	  
	  
	  for i in bipRoots do
	  (
	   i.controller.figureMode = True 
	   --?????��? ??? ??? on
	   redrawViews() 
	   -- ????? ????
	   
	   RLegAux=biped.getNode i #Rleg link:1
	   LLegAux=biped.getNode i #Lleg link:1
	   PelvisAux=biped.getNode i #pelvis
	   
	   /*
	   RLegAux.parent=LLegAux.parent=PelvisAux
	--??? bip?? ?��? Bip Spine ???? Bip Pelvis?? ????
		*/
	
		if buttonState[3] do 
		(
			for k in bipLimbs do
		   (
				if k[4] == 2 or  k[4] == 4 do 
				(
					local Limb = biped.getNode i k[1] link:k[2] 
					local boxsize = ceil(distance limb.parent limb /4 )  --floor   ceil
					local creatDummy = Dummy transform:(limb.transform)  isSelected:off
					creatDummy.boxsize = [boxsize,boxsize,boxsize]
					creatDummy.name = "Joint" + k[5] 
					creatDummy.parent = limb
					
					creatDummy.rotation.controller=Rotation_List()
					creatDummy.rotation.controller[1].controller=rotation_script()
					creatDummy.rotation.controller[1].AddNode "Limb" Limb
					creatDummy.rotation.controller[1].SetExpression LimbJointExpression 
					creatDummy.rotation.controller.weight[1] = 100
					
					if buttonState[2] do setTransformLockFlags creatDummy #{1..9} --??????? ??
				)
				-- Elbow, Knee ???? ????
				if k[4] == 1 do 
				(
					local Limb = biped.getNode i k[1] link:k[2] 
					local boxsize = ceil(distance limb limb.Children[1] /4 )  --floor   ceil
					local creatDummy = Dummy transform:(limb.transform)  isSelected:off
					creatDummy.boxsize = [boxsize,boxsize,boxsize]
					creatDummy.name = "Joint" + k[5] 
					creatDummy.parent = limb.parent
					
					creatDummy.rotation.controller=Rotation_List()
					creatDummy.rotation.controller[1].controller=rotation_script()
					creatDummy.rotation.controller[1].AddNode "Limb" Limb
					creatDummy.rotation.controller[1].SetExpression LimbShoulderExpression
					creatDummy.rotation.controller.weight[1] = 50
					
					if buttonState[2] do setTransformLockFlags creatDummy #{1..9} --??????? ??
				) -- Shoulder ???? ????
				
		   ) 

		)
	-- ???? ???????? ???(?? ?���? ?????? ???????? ?????��???????? ?????? ??????? )
	
		
	   for k in bipLimbs do
	   (
		if (k[3]>0) then
		(
		Limb=biped.getNode i k[1] link:k[2] 
		distanceVar=(distance limb limb.Children[1]) 
		
		
		TBExpression=""
		ControllerLimb=Limb
		weightVar=100

		
		
		case k[4] of
		(
		 1:(TBExpression=TBExpressionA)
		 2:(
			if k[1]==#larm then TBExpression=TBExpressionBb else TBExpression=TBExpressionBa
			ControllerLimb=Limb.children[1]
			weightVar=100/k[3]
		   )
		 3:(TBExpression=TBExpressionC)
		 4:(
			TBExpression=TBExpressionD
			ControllerLimb=Limb.children[1]
			weightVar=100/k[3]
		   )
		)
		

		
		
		TwistBone=BoneSys.createBone Limb.transform.position Limb.transform.position [0,0,1] 
		TwistBone.name="Bone"+k[5]+" Twist"
		TwistBone.parent=Limb
		TwistBone.Length=distanceVar/k[3]
		TwistBone.Width=distanceVar/8
		TwistBone.Height=TwistBone.Width
		TwistBone.taper=0
		TwistBone.rotation.controller=Rotation_List()
		TwistBone.rotation.controller[1].controller=rotation_script()
		TwistBone.rotation.controller[1].AddNode "Limb" ControllerLimb
		TwistBone.rotation.controller[1].SetExpression TBExpression
		TwistBone.rotation.controller.weight[1]=weightVar
		
		if buttonState[2] do setTransformLockFlags TwistBone #{1..9} --??????? ??
		--?? ?????????? ???? ???? rotation_script???????? ?????? ??? ?????? ???? ???

		
		--???????? ???? ???????? ????? 
		TBExtraController=rotation_script()
		if buttonState[1] then 
		(
			case of
			(
			 (k[4]==1 or k[4]==3):(
								   TBExtraController.AddNode "Limb" Limb 
								   TBExtraController.AddNode "LimbParent" TwistBone 
								   TBExtraController.setExpression TBExtraExpressionA
								  )
			 (k[4]==2 or k[4]==4):(
								   TBExtraController.AddNode "TB" TwistBone
								   TBExtraController.setExpression TBExtraExpressionB
								  )
			)
			PrevTBE=TwistBone

			
			
			for j=2 to k[3] do
			(
			 TwistBoneExtra=BoneSys.createBone [0,0,0] [1,0,0] [0,0,1] 
			 matAux=matrix3 1
			 matAux.position=[(distanceVar/k[3]),0,0]
			 TwistBoneExtra.transform=matAux*PrevTBE.transform
			 TwistBoneExtra.name=TwistBone.name+((j-1) as string)
			 TwistBoneExtra.parent=PrevTBE
			 TwistBoneExtra.Length=distanceVar/k[3]
			 TwistBoneExtra.Width=PrevTBE.Width
			 TwistBoneExtra.Height=PrevTBE.Height
			 TwistBoneExtra.taper=0
			 TwistBoneExtra.rotation.controller=Rotation_List()
			 TwistBoneExtra.rotation.controller[1].controller=TBExtraController
			 TwistBoneExtra.rotation.controller.weight[1]=100/k[3]
			 PrevTBE=TwistBoneExtra
			 
			 if buttonState[2] do setTransformLockFlags TwistBoneExtra #{1..9} --??????? ??
			)
		) else
		(
			case of
			(
				(k[4]==1 or k[4]==3):
				(
					TBExtraController.AddNode "Limb" TwistBone  
					TBExtraController.AddNode "LimbParent" Limb 
					TBExtraController.setExpression TBExtraExpressionA
			 	)
				(k[4]==2 or k[4]==4):
				(
					TBExtraController.AddNode "TB" TwistBone
					TBExtraController.setExpression TBExtraExpressionB
				)
			)
			PrevTBE=TwistBone

			
			
			for j=2 to k[3] do
			(
			 TwistBoneExtra=BoneSys.createBone [0,0,0] [1,0,0] [0,0,1] 
			 matAux=matrix3 1
			 matAux.position=[(distanceVar/k[3]),0,0]
			 TwistBoneExtra.transform=matAux*PrevTBE.transform
			 TwistBoneExtra.name=TwistBone.name+((j-1) as string)
			 TwistBoneExtra.parent=Limb
			 TwistBoneExtra.Length=distanceVar/k[3]
			 TwistBoneExtra.Width=PrevTBE.Width
			 TwistBoneExtra.Height=PrevTBE.Height
			 TwistBoneExtra.taper=0
			 TwistBoneExtra.rotation.controller=Rotation_List()
			 TwistBoneExtra.rotation.controller[1].controller=TBExtraController
			 if (k[4]==1 or k[4]==3) then
			 (
				TwistBoneExtra.rotation.controller.weight[1]= (100/k[3] * ((k[3]+1)-j))
			 ) else 
			 (
				TwistBoneExtra.rotation.controller.weight[1]= (100/k[3] * j)
			 )
			 PrevTBE=TwistBoneExtra
			 
			 if buttonState[2] do setTransformLockFlags TwistBoneExtra #{1..9} --??????? ??
			)
		)
		--??????? ???? ???????? ????? -end-
		
		)
	   )
	   i.controller.figureMode = false 
	   --?????��? ??? ??? off
	   
	  )
	  redrawViews()
	 ) --TBSetFunction
