macroScript Copy_Objects_To_File Category:"CG_Tools" toolTip:"Copy"
(
	thecopypastedir = getdir #autoback -- CHANGE THIS TO ANY FOLDER YOU WANT
	thecopypastefile = "\pastefile.max" --this is the filename to save as...
	thecopypastestring = thecopypastedir + thecopypastefile --this is the complete string
	
	if $ != undefined do 
		saveNodes $ thecopypastestring --this saves ("copies") the objects as a file
)
