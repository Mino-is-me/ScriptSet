fn getBodyNodes = 
(	
	File = BodyNodes
	fileSTM = openFile File
	ar_selection = #()

	deselect $*
	while not eof fileSTM do
	(
		try
		(
			txt = readLine fileSTM 
			nodeName = getNodeByName txt
			append ar_selection nodeName 
		)
		Catch(print nodeName)
	)
	close fileSTM
	UndefinedNodeinScene = findItem ar_selection undefined 
	if UndefinedNodeinScene == 0 then
	(
		select ar_Selection
	)
	else 
	(
		messageBox "This file(Scene) doesn't seem to be \nthe right file of PC(EVE) " title:"Script Alert"
		format "undefined Node num : %" UndefinedNodeinScene
		--exit 
	)
) -- NodeName parsing from txt file


--parsingCSV

csvToParsing ="Z:\\신규인력\\홈페이지_입사지원_EVE-190524.csv"
txtToFind = "클라이언트 프로그래머"
csvToMake = createFile "Z:\\신규인력\\parsingTest.csv"
ar_line = #()



fileSTM = openFile csvToParsing
fileSTM2 = openFile csvToMake 

while not eof fileSTM do
(
    txt = readLine fileSTM
    isWordintxtLine = findString txt txtToFind 
    if isWordintxtLine == true do
    (
        format txt to:fileSTM2
    )
)
close fileSTM 
close csvToMake 