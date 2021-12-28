fn selectAllNode =
(
    select $* 

)

fn getScalingFactor iScalePer =
(
    fScaleFactor = iScalePer / 100 
    return iscaleFactor

)



fn CopyScene =
(
	thecopypastedir = getdir #autoback -- CHANGE THIS TO ANY FOLDER YOU WANT
	thecopypastefile = "\pastefile.max" --this is the filename to save as...
	thecopypastestring = thecopypastedir + thecopypastefile --this is the complete string
	
	if $ != undefined do 
		saveNodes $ thecopypastestring --this saves ("copies") the objects as a file
)

fn PasteScene = 
(
    thecopypastedir = getdir #autoback -- CHANGE THIS TO ANY FOLDER YOU WANT
	thecopypastefile = "\pastefile.max" --this is the filename to save as...
	thecopypastestring = thecopypastedir + thecopypastefile --this is the complete string

	mergemaxfile (thecopypastedir + thecopypastefile) #select --this merges ("pastes") and selects objects from file
)

fn sceneScaling iScalePer=
(
    scaleFactor = getScalingFactor iScalePer
    units.SystemScale = scaleFactor
     
)




--이제 스케일링 저한테 부탁하지 마세요
Try(DestroyDialog scaleMaster) Catch()
Rollout scaleMaster "Scale Master" 
( 
    Spinner spi_scale "scale" range:[10,1000,100] type:#integer scale:10 fieldWidth:50  across:2		
    Button btn_scale "%" 

    on btn_scale pressed do 
    (
        units.systemScale = ( spi_scale.value / 100.0  )
        select $*
        CopyScene()

        resetMaxFile #noprompt

        units.systemScale = 1.0 
        PasteScene()

    )
)
createDialog scaleMaster 200 30 



