/*
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
fn copyObj = 
(
    thecopypastedir = getdir #autoback -- CHANGE THIS TO ANY FOLDER YOU WANT
    thecopypastefile = "\pastefile.max" --this is the filename to save as...
    thecopypastestring = thecopypastedir + thecopypastefile --this is the complete string

    if $ != undefined do 
    (
        saveNodes $ thecopypastestring --this saves ("copies") the objects as a file
    )
)

fn pasteObj =
(
    thecopypastedir = getdir #autoback -- CHANGE THIS TO ANY FOLDER YOU WANT
	thecopypastefile = "\pastefile.max" --this is the filename to save as...
	thecopypastestring = thecopypastedir + thecopypastefile --this is the complete string

	mergemaxfile (thecopypastedir + thecopypastefile) #select --this merges ("pastes") and selects objects from file
)

global ar_casters
global ar_targets 
global scaleFactor = 1 
global selected = 1
global originFile = MaxFilePath + MaxFileName --Remember Original File Directory 

--units.systemScale
--try(DestroyDialog showMaker) catch()

rollout showMaker "Show Maker" 
(
	Button pick_caster "Pick Caster" across:2 tooltip:"Select Biped"
    Button pick_target "Pick Target" tooltip:"Select Biped"
    
    dropdownlist ddl_scaled "Scaled Actor?" items:#("Caster", "Target") across:2
    spinner spin_ScaleSelector "Set Scale" range:[1,360,1] type:#float

    button btn_makeScene "Make Scaled Scene"
 
    on pick_caster pressed do 
    (
        ar_casters = selection as array 

    )

    on pick_target pressed do 
    (
        ar_targets = selection as array 

    )
    on ddl_scaled selected val do 
    (
        selected = val
    )

    on spin_ScaleSelector entered do 
    (
        scaleFactor = spin_ScaleSelector.value
    )

    on btn_makeScene pressed do 
    (
        units.systemScale = 1.0


        newScaleFactor = 1.0 / scaleFactor 
        print newScaleFactor
        if selected == 1 then 
        (
            format "Caster\n"
            

            select ar_targets

            for i=1 to ar_targets.count do 
            (
                ar_targets[i].name =ar_targets[i].name + "_target"
            )
            copyObj()

            delete ar_targets

            units.systemScale = scaleFactor

            pasteObj()

            units.systemScale = 1.0

        )
        else if selected == 2 then
        (
            format "Target\n"

            select ar_casters
            
            for i=1 to ar_casters.count do 
            (
                ar_casters[i].name =ar_casters[i].name + "_target"
            )
            copyObj()

            delete ar_casters

            units.systemScale = scaleFactor

            pasteObj()

            units.systemScale = 1.0
        )
    )
)

--createDialog showMaker 300 300

--showmaker 전반적으로 뜯기 

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

rollout showMaker "Show Maker" width:200 height:300
(
	button 'btn_Caster' "Caster" pos:[11,22] width:55 height:24 align:#left
	groupBox 'grp1' "Get Scenes" pos:[6,8] width:186 height:155 align:#left
	button 'btn_Target' "Target" pos:[11,74] width:55 height:24 align:#left
	editText 'edt_caster' "" pos:[11,51] width:159 height:17 align:#left
	editText 'edt_target' "" pos:[11,102] width:159 height:17 align:#left
	spinner 'spn_distance' "Distance" pos:[16,132] width:99 height:16 range:[0,2000,150] type:#float align:#left
	button 'btn_launch' "Launch" pos:[100,254] width:83 height:35 align:#left
	button 'btn_exportPath' "Export Path" pos:[16,171] width:71 height:22 align:#left
	editText 'edt_exportPath' "" pos:[11,201] width:162 height:17 align:#left

    on btn_Caster pressed do
    (
        files = fn_getMultipleFiles()

        if files.count > 0 do
        (
            showMaker.edt_caster.text = files[1]
        )

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

        filein "Z:\\ART_Backup\\Script\\ShowMaker\\FullRootMotion.ms"

        saveMaxFile ((showMaker.edt_exportPath.text) + ("\\LinkTarget.max") ) quiet:true

        resetMaxFile #noPrompt 


        loadMaxFile showMaker.edt_caster.text quiet:true 

        thecopypastedir = getdir #autoback -- CHANGE THIS TO ANY FOLDER YOU WANT
        thecopypastefile = "\pastefile.max" --this is the filename to save as...
        thecopypastestring = thecopypastedir + thecopypastefile --this is the complete string
    
        mergemaxfile (thecopypastedir + thecopypastefile) #select #autoRenameDups quiet:true --this merges ("pastes") and selects objects from file
       /*   
 
        */
		
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