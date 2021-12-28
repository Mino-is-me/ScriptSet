Fn fn_getMultipleFiles =
(
	theDialog = dotNetObject "System.Windows.Forms.OpenFileDialog" --create a OpenFileDialog 
	theDialog.title = "PLEASE Select One Or More Files" --set the title
	theDialog.Multiselect = true --allow multiple files to be selected
	theDialog.Filter = "csv Files (*.*)|*.*|csv Files (*.csv)|*.csv" --specify the filter
	theDialog.FilterIndex = 2 --set the filter drop-down list to All Files
	result = theDialog.showDialog() --display the dialog, get result into variable
	result.ToString() --when closed, convert the result to string
	result.Equals result.OK --returns TRUE if OK was pressed, FALSE otherwise
	result.Equals result.Cancel --returns TRUE if Cancel was pressed, FALSE otherwise
	theFilenames = theDialog.fileNames --the selected filenames will be returned as an array
	return theFilenames
)

animationRange = interval 0 20000

csvToParsing =fn_getMultipleFiles()
if csvToParsing.count > 0 do 
(
	fileSTM = openFile csvToParsing[1]

	txt = readLine fileSTM
	morphNames = filterString txt ","
	morphNames.count 

	set Animate On 
	cnt = 0 
	while not eof fileSTM do
	(
		SliderTIme = cnt
		txt = readLine fileSTM
		local values = filterString txt ","
		for i=1 to morphNames.count do 
		(
			try 
			(
				ctrl = getNodebyName (morphNames[i] + "_CTRL") 
				ctrl.pos.controller.Path_Constraint.controller.percent = (values[i] as float) * 100.0 
			)
			catch()
		)
		
		cnt = cnt+1
	)
)



