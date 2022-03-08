

*/ --Merged ShowMaker Script by Minomi 2021.03.05

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
	groupBox 'grp1' "Get Scenes" pos:[6,8] width:186 height:200 align:#left
	button 'btn_Target' "Target" pos:[11,74] width:55 height:24 align:#left
	editText 'edt_caster' "" pos:[11,51] width:159 height:17 align:#left
	editText 'edt_target' "" pos:[11,102] width:159 height:17 align:#left
	spinner 'spn_distance' "Distance" pos:[16,132] width:99 height:16 range:[0,2000,150] type:#float align:#left
    checkbox 'chk_useCustomRootMotion' "Use Custom Controller" align:#left
    pickbutton 'pbtn_controller' "select Controller" align:#left enabled:false
	button 'btn_launch' "Launch" pos:[100,280] width:83 height:35 align:#left
	button 'btn_exportPath' "Export Path" pos:[16,220] width:71 height:22 align:#left
	editText 'edt_exportPath' "" pos:[11,250] width:162 height:17 align:#left
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


        loadMaxFile  showMaker.edt_target.text quiet:true
        
        if not (showMaker.chk_useCustomRootMotion.checked) then (
            filein "Z:\\ART_Backup\\Script\\ShowMaker\\FullRootMotion.ms"
        )
        else (
            filein "Z:\\ART_Backup\\Script\\ShowMaker\\customRootMotion.ms"
        )

        saveMaxFile ((showMaker.edt_exportPath.text) + ("\\LinkTarget.max") ) quiet:true

        resetMaxFile #noPrompt 


        loadMaxFile showMaker.edt_caster.text quiet:true 

        thecopypastedir = getdir #autoback -- CHANGE THIS TO ANY FOLDER YOU WANT
        thecopypastefile = "\pastefile.max" --this is the filename to save as...
        thecopypastestring = thecopypastedir + thecopypastefile --this is the complete string
    
        mergemaxfile (thecopypastedir + thecopypastefile) #select #autoRenameDups quiet:true --this merges ("pastes") and selects objects from file

		
		linkRoot = Dummy()
		$Root001.parent = linkRoot
		
		linkRoot.rotation = quat 0 0 1 0


        if not (isValidNode $SC_LinkTarget) do 
        (
            --delete $SC_LinkTarget
            sc_LinkTarget = dummy()
            sc_LinkTarget.parent = $Root
            sc_LinkTarget.transform = (matrix3 [1,0,0] [0,1,-1.19209e-07] [0,1.19209e-07,1] [0,0,0])
            sc_LinkTarget.name = "SC_LinkTarget"
        )


        cnt=0
        with Animate on 
        (
            for i=AnimationRange.start to AnimationRange.end do 
            (
                cnt = cnt+1
				SliderTime = i 
				$sc_LinkTarget.transform = $Root001.transform 
            )
        )

        delete $Root001
        delete linkRoot

        saveMaxFile ( (showMaker.edt_exportPath.text) + ("\\LinkCaster.max") ) quiet:true
    )

)

CreateDialog showMaker


/*
ar_TargetTMs = #()

cnt=0
for i=AnimationRange.start to AnimationRange.end do 
(
	cnt = cnt+1
	sliderTime = i 
	
	append ar_TargetTMs $Root.Transform
	
)

with Animate on 
(
	for i=AnimationRange.start to AnimationRange.end do 
	(
		SliderTime = i 
		cnt = cnt+1
		if cnt <= ar_TargetTMs.count do
		(
			sc_LinkTarget.transform = ar_TargetTMs[cnt]
			--sc_LinkTarget.pos.y = sc_LinkTarget.pos.y
		)
	)
)

*/