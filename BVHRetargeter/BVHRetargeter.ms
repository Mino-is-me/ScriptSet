rememberthisFile = MaxFilePath + MaxFileName
BVHFiles = #()
--BonesToRetarget = #($'Bip001 L Finger0',$'Bip001 R Clavicle',$'Bip001 L Clavicle')
BipSavePath = ""
cnt = 0 
fn BVHfn_getMultipleFiles =
(
	theDialog = dotNetObject "System.Windows.Forms.OpenFileDialog" --create a OpenFileDialog 
	theDialog.title = "PLEASE Select One Or More Files" --set the title
	theDialog.Multiselect = true --allow multiple files to be selected
	theDialog.Filter = "All Files (*.*)|*.*|BVH Files (*.bvh)|*.bvh" --specify the filter
	theDialog.FilterIndex = 2 --set the filter drop-down list to All Files
	result = theDialog.showDialog() --display the dialog, get result into variable
	result.ToString() --when closed, convert the result to string
	result.Equals result.OK --returns TRUE if OK was pressed, FALSE otherwise
	result.Equals result.Cancel --returns TRUE if Cancel was pressed, FALSE otherwise
	theFilenames = theDialog.fileNames --the selected filenames will be returned as an array
	return theFilenames
)



fn fn_retargetBone = --Write Down Custom Retarget Setting
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

fn fn_makeBipFileName savePath FileName =
(
	local getFileName = getFileNameFile FileName
	
	return (savePath + "\\" + getFileName + ".bip")
)


-- biped.loadMocapFile $Bip001.controller 
-- biped.saveBipFile $Bip001.controller savePath
-- biped.createNew 100 -90 [0,0,100] arms:true neckLinks:1 spineLinks:3

Try(DestroyDialog BVHRetargeter) Catch()

rollout BVHRetargeter "BVH Retargeter"
(
	label lb_waterMark "Script by Minomi"
	Button btn_getBVHFiles "Select Files" width:150 height:50
	MultiListBox mlb_fileNames "File Lists"
	Button btn_getExportPath "Select Export Path" align:#Right  width:60 height:30
	EditText et_exportPath "Export Path : "
	Button btn_Retarget "Retarget && Export" width:150 height:50
	
	progressBar pgb_process "Retarget Processing..." color:Green 
	
	on btn_getBVHFiles pressed do
	(
		BVHFiles = BVHfn_getMultipleFiles()
		Try(mlb_FileNames.items = BVHFiles) Catch()
		
	)
	
	on btn_getExportPath pressed do
	(
		BipSavePath = getSavePath()
		Try(et_exportPath.text = BipSavePath) Catch()
	)
	
	on btn_Retarget pressed do
	(
		resetMaxFile #noprompt
		biped.createNew 100 -90 [0,0,100] arms:true neckLinks:1 spineLinks:3

		biped.loadMocapFile $Bip001.controller BVHFiles[1] #prompt 
		if BipSavePath != "" then 
		(
			savePath = fn_makeBipFileName BipSavePath BVHFiles[1]
		)
		else 
		(
			savePath = (getFilenamePath BVHFiles[1]) + (getFileNameFile BVHFiles[1]) + ".bip"
		)
		biped.saveBipFile $Bip001.controller savePath
		print savePath 
		for i=2 to BVHFiles.count do
		(
			--resetMaxFile #noprompt
			
			--biped.createNew 100 -90 [0,0,100] arms:true neckLinks:1 spineLinks:3
			biped.loadMocapFile $Bip001.controller BVHFiles[i] --#prompt 
			biped.createLayer $Bip001.controller 1 "Layer_Retarget"
			fn_retargetBone()
			biped.collapseAtLayer $Bip001.Controller 0
			if BipSavePath != "" then 
			(
				savePath = fn_makeBipFileName BipSavePath BVHFiles[i]
			)
			else 
			(
				savePath = (getFilenamePath BVHFiles[i]) + (getFileNameFile BVHFiles[i]) + ".bip"
			)
			biped.saveBipFile $Bip001.controller savePath
			print savePath 
			cnt += 1
			pgb_process.value = (100.0 / BVHFiles.count ) * i
			if(pgb_process.value == 100.0) OR cnt == BVHFiles.count do
			(
				messageBox "Job Done" Title:"Progress Alert" 
			)
		)
	)
)
--createDialog BVHRetargeter 400 400

