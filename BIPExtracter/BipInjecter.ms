

fn getMultipleFiles_Max =
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

fn getMultipleFiles_bip =
(
	theDialog = dotNetObject "System.Windows.Forms.OpenFileDialog" --create a OpenFileDialog 
	theDialog.title = "PLEASE Select One Or More Files" --set the title
	theDialog.Multiselect = true --allow multiple files to be selected
	theDialog.Filter = "All Files (*.*)|*.*|Bip Files (*.bip)|*.bip" --specify the filter
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

Rollout BipInjecter "Bip Injecter"
(
    button btnGetBipFiles "get Bip Files for Inject" align:#Right
    multiListBox mlbBips "Bip Files List"
    Label lbArrowDowner "↓"
    button btnGetMaxFiles "get Max Files for BaseMesh" align:#Right
    multiListBox mlbMax "Base Mesh File" height:1
    label lbBlank ""
    editText edtExportPath "Export Path : " 
    button btnGetExportPath "get Path" align:#Right

    button btnMigrate "Inject Anim Data"

    on btnGetBipFiles pressed do 
    (
        mlbForExtract.items = getMultipleFiles_bip()
    )
    on btnGetMaxFiles2 pressed do 
    (
        mlbforMigration.items = getMultipleFiles_Max()
    )
    on btnGetMigratePath pressed do 
    (
        fileSavePath = getSavePath()
        Try(edtMigratePath.text = fileSavePath) Catch()
    )

    on btnMigrate pressed do 
    (
        for scFile in mlbForExtract.items do 
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
CreateDialog BipInjecter 400 475