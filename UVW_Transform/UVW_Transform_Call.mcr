macroScript UVWTrans
	category:"UVWTransform"
	toolTip:"UVWTransform"
(
	fn getThisDir =
	(
		local This = getThisScriptFilename()
		thisPath = getFileNamePath This
		
		return thisPath
	)

	Global this = getThisDir()
	
	fileIn (This + "UVW_Transform.ms")
)
