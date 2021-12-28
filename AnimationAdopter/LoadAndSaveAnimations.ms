Global maxFiles = #()
Global xmlFiles = #()
Global newHierachy = #()

try(DestroyDialog loadAndSaveAnims) catch()

rollout loadAndSaveAnims "Save and Load Animation" width:680 height:301
(
	groupBox 'grp_save' "Save Animation" pos:[9,10] width:320 height:225 align:#left
	groupBox 'grp_load' "Load Animation" pos:[343,10] width:320 height:224 align:#left
	button 'btn_save' "Get *.max for save" pos:[20,40] width:296 height:82 align:#left
	button 'btn_load' "Get *.xml for Load" pos:[355,40] width:296 height:82 align:#left
	editText 'edt_saveExportDir' "" pos:[26,172] width:288 height:21 align:#left
	label 'lbl_save' "Export Directory" pos:[30,155] width:128 height:15 align:#left
	button 'btn_getSaveDir' "export Path" pos:[227,130] width:86 height:33 align:#left
	editText 'edt_loadExportDir' "" pos:[360,170] width:288 height:21 align:#left
	label 'lbl_load' "Export Directory" pos:[364,153] width:128 height:15 align:#left
	button 'btn_getLoadDir' "export Path" pos:[564,129] width:86 height:33 align:#left
	groupBox 'grp_setting' "Settings" pos:[11,241] width:653 height:49 align:#left
	button 'btn_runSave' "Run" pos:[237,200] width:75 height:30 align:#left
	button 'btn_runLoad' "Run" pos:[573,198] width:75 height:30 align:#left

    on btn_save pressed do
    (
        maxFiles = fn_getMultipleFiles multi:true fileFilter:"MAX Files (*.max)|*.max"
    )
    on btn_load pressed do 
    (
        xmlFiles = fn_getMultipleFiles multi:true fileFilter:"XML Files (*.xaf)|*.xaf"
    )

    on btn_getSaveDir pressed do 
    (
        edt_saveExportDir.text = getSavePath "Set Output Path"
    )
    on btn_getloadDir pressed do 
    (
        edt_loadExportDir.text = getSavePath "set Output Path"
    )

    on btn_runSave pressed do
    (
        for maxFile in maxFiles do 
        (
            loadMaxFile maxFile quiet:true 
            units.SystemScale = 1
            select $* 
            local nodes = selection as array 
            local xmlName = substituteString MaxFileName ".max" ".xaf"
            local filename = edt_saveExportDir.text + "\\" + xmlName
            LoadSaveAnimation.saveAnimation filename nodes #() #()
        )
    )

    on btn_runLoad pressed do 
    (
        for xmlFile in xmlFiles do 
        (
            select $* 
            local nodes = selection as array 
            LoadSaveAnimation.loadAnimation xmlFile nodes relative:true 
        )
    )
)

CreateDialog loadAndSaveAnims
