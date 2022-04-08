

 --Merged ShowMaker Script by Minomi 2021.03.05

global pbtn_controller_name = ""

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

Try 
( 
    DestroyDialog showMaker
)
Catch 
()

rollout showMaker "Show Maker" width:200 height:350
(
	button 'btn_Caster' "Caster" pos:[11,22] width:55 height:24 align:#left
    button 'btn_open_caster' "open" pos:[145,22] width:40 height:24 align:#left
	groupBox 'grp1' "Get Scenes" pos:[6,8] width:186 height:200 align:#left
	button 'btn_Target' "Target" pos:[11,74] width:55 height:24 align:#left
    button 'btn_open_target' "open" pos:[145,74] width:40 height:24 align:#left
	editText 'edt_caster' "" pos:[11,51] width:159 height:17 align:#left
	editText 'edt_target' "" pos:[11,102] width:159 height:17 align:#left
	spinner 'spn_distance' "Distance" pos:[16,132] width:99 height:16 range:[0,2000,150] type:#float align:#left
    checkbox 'chk_useCustomRootMotion' "Use Custom Controller" align:#left
    pickbutton 'pbtn_controller' "select Controller" align:#left enabled:false
	button 'btn_launch' "Launch" pos:[100,280] width:83 height:35 align:#left
	button 'btn_exportPath' "Export Path" pos:[16,220] width:71 height:22 align:#left
	editText 'edt_exportPath' "" pos:[11,250] width:162 height:17 align:#left

    on btn_open_caster pressed do (
        loadMaxFile  showMaker.edt_caster.text quiet:true
    )
    on btn_open_target pressed do (
        loadMaxFile showMaker.edt_target.text quiet:true 
    )

    on btn_Caster pressed do
    (
        files = fn_getMultipleFiles()

        if files.count > 0 do
        (
            showMaker.edt_caster.text = files[1]
        )
    )

    on chk_useCustomRootMotion changed val do 
    (
        if val then (
            pbtn_controller.enabled = true 
        )
        else (
            pbtn_controller.enabled = false 
        )
    )
    
    on pbtn_controller picked obj do
    (
        pbtn_controller.text = obj.name
        pbtn_controller_name = obj.name 
    )

    on btn_target pressed do 
    (
        files = fn_getMultipleFiles()

        if files.count > 0 do
        (
            showMaker.edt_target.text = files[1]
        )
    )

    on btn_exportPath pressed do 
    (
        showMaker.edt_exportPath.text = getSavePath "Set Output Path"
    )

    on btn_launch pressed do
    (

        resetMaxFile #noPrompt 
        if not (showMaker.chk_useCustomRootMotion.checked) then (
            filein (projectDir + "ShowMaker\\fullRootMotion_new.ms")
        )
        else (     
            filein (projectDir + "ShowMaker\\customRootMotion.ms")
        )

    )

)

CreateDialog showMaker