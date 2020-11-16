fn fn_getMaxFiles =
(
	theDialog = dotNetObject "System.Windows.Forms.OpenFileDialog" --create a OpenFileDialog 
	theDialog.title = "PLEASE Select One Or More Files" --set the title
	theDialog.Multiselect = true --allow multiple files to be selected
	theDialog.Filter = "All Files (*.*)|*.*|Max Files (*.max)|*.max|Bip Files (*.bip)|*.bip" --specify the filter
	theDialog.FilterIndex = 3 --set the filter drop-down list to All Files
	result = theDialog.showDialog() --display the dialog, get result into variable
	result.ToString() --when closed, convert the result to string
	result.Equals result.OK --returns TRUE if OK was pressed, FALSE otherwise
	result.Equals result.Cancel --returns TRUE if Cancel was pressed, FALSE otherwise
	theFilenames = theDialog.fileNames --the selected filenames will be returned as an array
	return theFilenames
)

fn getINIPath = 
(
    local this = getThisScriptFilename()
    local ININame = substituteString this ".ms" ".ini"
    return ININame 
)

fn setChangeSettingINI fPath =
(
    ININame = getINIPath()
    setINISetting ININame "ChangeSetting" "TargetPath" fPath
    --return ININame
)

fn getChangeSettingINI =
(
    ININame = getINIPath()
    local returnVal = getINISetting ININame "ChangeSetting" "TargetPath"
    return returnVal
)

fn collectBipFiles inPath=
(
    units.SystemScale = 1
    ININame = getChangeSettingINI()
    --local Path = getFilenamePath ININame 
    fileName = substituteString MaxFileName ".max" ".bip"
    Path = inPath + fileName 
    select $Bip001 
    Biped.saveBipFile $Bip001.controller Path

    return Path 
)


------Functions End------



Global targetScene = #()
Global ConvertedScenes = #()
Global bipFiles = #() 

Try(closeRolloutFloater fl_CharacterChange) Catch()

rollout rlt_CharacterChange "CharacterChanger" width:423 height:600
(
	button 'btn_selectTarget' "Select Target" pos:[20,23] width:125 height:38 align:#left
	editText 'edt_targetPath' "Path :" pos:[50,68] width:359 height:15 align:#left
	editText 'edt_targetName' "Name :" pos:[244,87] width:164 height:15 align:#left
	groupBox 'grp1' "Target Max File" pos:[9,6] width:410 height:120 align:#left
	groupBox 'grp2' "Converted Scene FIles" pos:[9,142] width:404 height:361 align:#left
	button 'btn_selectScenes' "Select Files" pos:[20,174] width:119 height:42 align:#left
	multilistBox 'lb_fileList' "Names" pos:[22,255] width:379 height:15 align:#left
    editText 'edt_scenePath' "Path :" pos:[23,226] width:373 height:15 align:#left
    --editText 'edt_exportPath' "Path :" pos:[23,480] width:373 height:15 align:#left
    --button 'btn_getExportPath' "ExportPath" pos:[20,516] width:111 height:45 align:#left
    button 'btn_Run' "Run" pos:[20,516] width:111 height:45 align:#left
    checkBox 'chk_BipConvertOnly' "Only BIP Files" pos:[300,516] 
    
    on rlt_CharacterChange open do
    (
        edt_targetPath.text = getFilenamePath (getChangeSettingINI())
        edt_targetName.text = getFilenameFile (getChangeSettingINI())
    )

    on btn_selectTarget pressed do 
    (
        print (getThisScriptFilename())
        targetScene = fn_getMaxFiles() 
        if targetScene[1] != undefined do 
        (
            edt_targetPath.text = getFilenamePath targetScene[1]
            edt_targetName.text = getFileNameFile targetScene[1]

            setChangeSettingINI targetScene[1]
        )
    )

    on btn_selectScenes pressed do 
    (
        ConvertedScenes = fn_getMaxFiles multi:true

        if ConvertedScenes.count != 0 do 
        (
            --local fileType = getFilenameType ConvertedScenes[1]
            --if fileType == ".max" do 
            edt_scenePath.text = getFilenamePath ConvertedScenes[1]
            Names = for i in ConvertedScenes collect getFilenameFile i 
            lb_fileList.items = Names
        )
        local firstType = getFileNameType ConvertedScenes[1]
        if firstType == ".bip" do 
        (
            chk_BipConvertOnly.checked = true 
        )
    )

    on btn_Run pressed do 
    (
        local savePath = getSavePath "Set Output Path"
        savePath = savePath + "\\"
        if savePath != "" do ()
        for i in ConvertedScenes do 
        (
            local type = getFilenameType i  
            print type 
            if type == ".max" then 
            (
                loadMaxFile i quiet:true 
                local bipFile = collectBipFiles savePath
                append bipFiles bipFile
            )
            else if type == ".bip" then 
            (
                append bipFiles i 
            )
        )

        TargetScene = getChangeSettingINI()
        loadMaxFile TargetScene quiet:true 

        for i in bipFiles do 
        (
            biped.loadBipFile $Bip001.controller i 

            -- Ani edit part start  
            local AnimRange = biped.getCurrentRange $Bip001.controller 
            
            if AnimRange.start == AnimRange.end do
            (
                AnimRange.end += 1
            )
            
            AnimationRange = AnimRange 
            
            $Bip001.controller.figureMode = True 

            sleep 0.05 

            $Bip001.controller.figureMode = False
            -- Ani edit part end 
            
            if chk_BipConvertOnly.checked then 
            (
                local saveDir = savePath + (getfileNameFile i) + ".max"
                saveMaxFile saveDir
            )
            else 
            (
                saveMaxFile (substituteString i ".bip" ".max")
            )
            loadMaxFile (MaxFilePath + MaxFileName) quiet:true
        )
    )
)
--createDialog rlt_CharacterChange
fl_CharacterChange = newRolloutFloater "Character Change" 440 600

addRollout rlt_CharacterChange fl_CharacterChange rolledUp:false 