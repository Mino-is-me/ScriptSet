fn getThisDir =
(
	local This = getThisScriptFilename()
	thisPath = getFileNamePath This
	
	return thisPath
)

This = getThisDir() + "Script\\"

setUpDir = getDir #usermacros + "\\"

files = getFiles (This + "*")



for i in files do
(
	fileName = filenameFromPath i
	newDir = setUpDir + fileName
	CopyFile i newDir
)