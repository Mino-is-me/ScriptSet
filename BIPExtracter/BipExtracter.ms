/*
BipExtracter Scripted by Minomi from ShiftUp - Project EVE
*/
Global arMaxFiles = #()
fn Bipfn_getMultipleFiles =
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

Try 
(
    destroyDialog BipExtracter
)
Catch() 
rollout BipExtracter "Bip Extracter" 
(
    label lb_waterMark "Script by Minomi"
	Button btn_getMaxFiles "Select Files" width:150 height:50
	MultiListBox mlb_fileNames "File Lists"
	Button btn_getExtractPath "Select Export Path" align:#Right  width:60 height:30
	EditText et_extractPath "Export Path : "
    Button btn_Extract "Extract Bip Files" width:150 height:50 
    
    on btn_getMaxFiles pressed do 
    (
        arMaxFiles = Bipfn_getMultipleFiles()

        mlb_fileNames.items = arMaxFiles
    )

    on btn_getExtractPath pressed do 
    (
        BipSavePath = getSavePath()
		Try(et_extractPath.text = BipSavePath) Catch()
    )

    on btn_Extract Pressed do 
    (
        for i in arMaxFiles do 
        (
            loadMaxFile i quiet:true
            units.systemScale = 1
            local path = et_extractPath.text + "\\" + (makeBipFileName MaxFileName)
            biped.saveBipFile $Bip001.controller path
        )
    )
)createDialog BipExtracter