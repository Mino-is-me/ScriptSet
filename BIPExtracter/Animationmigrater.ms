

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

Try(DestroyDialog AnimationMigrater) Catch()

Rollout AnimationMigrater "Animation migrater"
(
    button btnGetMaxFiles1 "get Max Files for Extract" align:#Right
    multiListBox mlbForExtract "Extract Bip Files From Listed Max Files"
    Label lbArrowDowner "↓"
    button btnGetMaxFiles2 "get Max Files for BaseMesh" align:#Right
    multiListBox mlbforMigration "Base Mesh Files for Migrated Bip Files"
    editText edtMigratePath "Migrate Path : " 
    button btnGetMigratePath "get Path" align:#Right

    button btnMigrate "Migrate Animation Data"

    on btnGetMaxFiles1 pressed do 
    (
        mlbForExtract.items = getMultipleFiles()
    )
    on btnGetMaxFiles2 pressed do 
    (
        mlbforMigration.items = getMultipleFiles()
    )
    on btnGetMigratePath pressed do 
    (
        fileSavePath = getSavePath()
        Try(edtMigratePath.text = fileSavePath) Catch()
    )

    on btnMigrate pressed do 
    (
        local arBipFiles = #()
        for i in mlbForExtract.items do 
        (
            loadMaxFile i quiet:true
            units.systemScale = 1
            local path = edtMigratePath.text + "\\" + (makeBipFileName MaxFileName)
            append arBipFiles path 
            biped.saveBipFile $Bip001.controller path
        )

        for scFile in mlbforMigration.items do 
        (
            loadMaxFile scFile quiet:true 
            units.systemScale = 1  
            for i in arBipFiles do 
            (
                biped.loadBipFile $Bip001.controller i 
                local maxName = makeMaxFileName i
                saveMaxFile maxName clearNeedSaveFlag:true 
            )
        )
    )
)
CreateDialog AnimationMigrater 400 475