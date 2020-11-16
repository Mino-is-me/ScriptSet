/*------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Standard Load Save functions
-- By ken turner
-- www.designimage.co.uk
*/------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Struct StandardLoadSaveStruct
(
	fnPtrSave = undefined,
	fnPtrLoad = undefined,
	fileType = "txt",
	filePath = "$userscripts/",
	
	fn fixPath txt =
	(
		txt = trimleft ( trimRight txt ) -- remove surrounding spaces
		for i = 1 to txt.count where txt[i] == "\\" do txt[i] = "/"
		txt
	),
	fn SetPath txt =
	(
		filePath = (if txt == undefined then "" else (FixPath txt) ) 
	),
	fn getPath = getFilenamePath filePath,
	fn SetfileNameTo newName =
	(
		p = getPath()
		newName = fixPath newName
		SetPath ( p + newName + "." + fileType )
	),

	fn BrowseAndSave =
	(
		txt = getSaveFileName fileName:filePath Caption:("Pick ."+fileType +" file" ) Types:("*." + fileType +"|*."+fileType +"|")
		if txt != undefined do
		(
			SetPath txt 
			fnPtrSave filePath
		)
	),
	fn BrowseAndLoad =
	(
		txt = getOpenFileName fileName:filePath Caption:("Pick ."+fileType +" file" ) Types:("*." + fileType +"|*."+fileType +"|")
		if ( txt != undefined ) and ( doesFileExist txt ) do
		(
			SetPath txt 
			fnPtrLoad filePath
		)
	)
)

rollout StandardLoadSaveRoll "Load / Save"
(
	Local isRolledOut = true --- required varible for kenzorsRolloutManager
	fn rolledUpEventFn = 
	( --- required undefined varible for kenzorsRolloutManager
	)
	on StandardLoadSaveRoll rolledUp val do ( isRolledOut = val ; rolledUpEventFn()) --- required function for kenzorsRolloutManager
	---------------------------------------------------------------------------------------------
	-----------------------------------------------------------------------------------------------------------------------
	local LoadSaveWrapper = StandardLoadSaveStruct()
	
	edittext EditPath 
	
	button BtnLoad "Load"  align:#right offset:[-50,0]
	button BtnSave "Save"  align:#right offset:[10,-26]
	
	fn setFilePathTo fPath =
	(
		EditPath.text = LoadSaveWrapper.SetPath fPath
	)
	
	fn SetfileNameTo newName  =
	(
		EditPath.text = LoadSaveWrapper.SetfileNameTo newName
	)
	
	on EditPath entered arg do ( EditPath.text = LoadSaveWrapper.SetPath arg )
	on btnSave Pressed do ( LoadSaveWrapper.BrowseAndSave() ; EditPath.text = LoadSaveWrapper.filePath )
	on btnLoad Pressed do (LoadSaveWrapper.BrowseAndLoad() ; EditPath.text = LoadSaveWrapper.filePath )
)
/* ------- expects functions like this
	fn writeMeToFilePath fPath =
	(
		if (fPath != undefined) then 
		( 
			fStream = createFile fPath
			writeMe fStream
			close fStream
			true -- todo: return false if it breaks
		)else false
	)
*/