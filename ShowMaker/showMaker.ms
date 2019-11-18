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