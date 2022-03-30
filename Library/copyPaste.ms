function copyNode = (
    thecopypastedir = getdir #autoback -- CHANGE THIS TO ANY FOLDER YOU WANT
	thecopypastefile = "\pastefile.max" --this is the filename to save as...
	thecopypastestring = thecopypastedir + thecopypastefile --this is the complete string
	
	if $ != undefined do 
		saveNodes $ thecopypastestring --this saves ("copies") the objects as a file
)

function pasteNode = (
    thecopypastedir = getdir #autoback -- CHANGE THIS TO ANY FOLDER YOU WANT
	thecopypastefile = "\pastefile.max" --this is the filename to save as...
	thecopypastestring = thecopypastedir + thecopypastefile --this is the complete string

	mergemaxfile (thecopypastedir + thecopypastefile) #select #skipDups #neverReparent quiet:true  --this merges ("pastes") and selects objects from file
)