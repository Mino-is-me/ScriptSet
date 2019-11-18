/*------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Tweak Cameras
-- By ken turner
-- www.designimage.co.uk
-- dot net reference http://www.scriptspot.com/bobo/mxs9/dotNet/dotNetObject_System.Windows.Forms.TabControl.html
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- versions 
-- 09/12/2017	3dsmax 2017 rollout bug fix
-- 07 mar 2014 -- fixed some rounding error issues , changed proxy sizes.
-- 28 feb 2014 -- added 'real' camera data from Digital Cinema Pocket Guides  https://www.theblackandblue.com/pocket-guides/
-- 20 Dec 2012 -- simple frame overscan  controls

-- toDo

bake targeted camera animation
custom attrib for cameras 
user lists of cameras and proxy sizes


*/------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

	-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
if KenzorsTweakCameraManager != undefined then KenzorsTweakCameraManager.closeup()
KenzorsTweakCameraManager = undefined

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------------------------------- File In ----------------------
fileIn ( "$userscripts/KenzorsScripts/Common/kenzorsRolloutManager.ms" )
fileIn ( "$userscripts/KenzorsScripts/Common/StringStreamStruct.ms" )
fileIn ( "$userscripts/KenzorsScripts/Common/dnListViewWithDragDropStruct.ms")

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------------------- declare Rollouts ----------------------
LockCamRoll = undefined
ExtendFrameRoll = undefined
vRayCameraRoll = undefined
ProxyResolutionRoll = undefined
SetRealCameraRoll = undefined
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- camDataStruct
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
struct camDataStruct
(
	cameraName = "Custom Cam",
	FilmBackWidth = 22.2,
	pixelWidth = 0,
	pixelheight = 0,
	fn greatestCommonDivisor a b = -- Euclidean algorithm for greatest common divisor
	(
		while b != 0 do
		(
			t = b
			b = mod a b
			a = t
		)
	),
	fn intAsString i = ( i as integer ) as String ,
	fn getAspectRatioAsString =
	(
		i = greatestCommonDivisor pixelWidth pixelheight
		"" + ( intAsString ( pixelWidth / i ) )  + ":" + ( intAsString ( pixelheight / i ) )
	),
	fn getImageAspect = ( pixelWidth as float ) / ( pixelheight as float ),
	fn getImageAspectAsString =
	(
		r = getImageAspect()
		(floor (r *100 ) /100.0) as string	
	),
	fn SetAsRenderSize withMultipler: =
	(
		renderWidth =  withMultipler.getPixelWidthOf pixelWidth
		renderHeight =  withMultipler.getPixelHeightOf pixelheight
		renderPixelAspect  = 1.0
		renderSceneDialog.Update()
	),
	fn GetSizeFromRenderDialog =
	(
		pixelWidth = renderWidth
		pixelheight = renderHeight
	),

	fn SetRenderSize withMultipler: =
	(
		setRendApertureWidth ( FilmBackWidth * withMultipler.overScanRatioWidth )
		SetAsRenderSize withMultipler:withMultipler
	),
	fn getResolutionHeightAsString = pixelheight as String,
	fn getResolutionWidthAsString = pixelWidth as String,	
	fn getFilmBackWidthAsString =
	(
		( FilmBackWidth as string ) -- + " mm"
	),
	fn readme sStream =
	(
		sData = sStream.ReadLineAsArray()
		cameraName = sData[1]
		pixelWidth = sData[2] as integer
		pixelheight = sData[3] as integer
		FilmBackWidth = sData[4] as float
	),
	fn SetRenderWidth withMultipler: = 
	(
		renderWidth =  withMultipler.getPixelWidthOf pixelWidth
		setRendApertureWidth  ( FilmBackWidth * withMultipler.overScanRatioWidth )
		renderSceneDialog.Update()
	),
	fn SetRenderHeight withMultipler: =
	(
		renderHeight =  withMultipler.getPixelHeightOf pixelheight
		renderSceneDialog.Update()
	)
)
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------------------------------- END OF: camDataStruct

---------------------------------------------------------------------------------------------------------------------------------------------------------------------- MaxCameraWrapperStruct
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
struct MaxCameraWrapperStruct --toDo set this as a custom atribute
(
	-- note that these fuctions ignore the fovType set by the camera
	cameraNode = undefined,
	cameraLens = undefined,
	
	fn WorldUnitMultiplier =
	(
		case units.systemtype of
		(
			 #Inches: units.decodevalue "1\""
			 #Feet: units.decodevalue "1'"
			 #Miles: undefined -- 1609.344
			 #Millimeters: units.decodevalue "1mm"
			 #Centimeters: units.decodevalue "1cm"
			 #Meters: units.decodevalue "1m"
			 #Kilometers: units.decodevalue "1km"
		 )
	),
	
	fn getLensSize =
	(
		cameraLens = cameraFOV.FOVtoMM cameraNode.FOV
	),
	fn setCameraTo theCameraNode =
	(
		cameraNode = theCameraNode
		getLensSize()
	),
	fn resetLens = 
	(
		cameraNode.FOV = cameraFOV.MMtoFOV cameraLens
	),
	fn updateView =
	(
		nodeInvalRect cameraNode
	),
	fn isVRayCamera =
	(
		classOf cameraNode == VRayPhysicalCamera
	),
	fn GetFixedTransformOf theObj =
	(
		--- how to find the Source CAMERA pivot if transform matrix is mashed up by tracking software.... use ... node.objectTransform
		newTm = matrix3 1
		newTm.rotation = (theObj.objectTransform).rotation 
		newTm.pos = (theObj.objectTransform).pos
		newTm = orthogonalize  newTm
		 -- newTm.determinantsign  --- toDo check Left or right handed
		newTm
	),
	fn IsTargetCam =
	(
		if  (classOf cameraNode == VRayPhysicalCamera ) then ( cameraNode.targeted == true ) else ( cameraNode.type == #target ) 
	),
	fn setFreeCamTmTo newCam =
	(
		newTm = GetFixedTransformOf cameraNode
		newCam.Rotation = inverse newTm.rotation
		newCam.position = newTm.position
	),
	fn setTargetCamTmTo newCam =
	(
		newTm = GetFixedTransformOf cameraNode
		newCam.transform.controller.rollangle = cameraNode.transform.controller.rollangle
		newCam.transform.controller.Axis = cameraNode.transform.controller.Axis
		newCam.transform.controller.Flip = cameraNode.transform.controller.Flip
		newCam.target.transform = cameraNode.target.transform
		newCam.position = newTm.position
	),
	fn BakeAnimTo newCam  inAnimRange:animationrange withStep:1 fnCopyTm: =
	(
		for t = inAnimRange.start to inAnimRange.end by withStep do
		(
			at time t 
			(
				with animate on
				(
					fnCopyTm newCam
				)
			)
		)
	),

	fn getNewVRayCamera =
	(
		newCamera = VRayPhysicalCamera()
		if ( IsTargetCam() )  then
		(
			newCamera.targeted = true
			setTargetCamTmTo newCamera
		)else 
		(
			newCamera.targeted = false
			setFreeCamTmTo newCamera
			newCamera.target_distance = cameraNode.target_distance /  WorldUnitMultiplier()
		)
		newCamera.film_width = getRendApertureWidth()
		newCamera.specify_fov = true  -- note that by setting this to true first vRay does the lens size calculation when we change the FOV ... otherwise the lens size is not refreshed.
		newCamera.environment_near = cameraNode.nearrange
		newCamera.environment_far  = cameraNode.farrange
		newCamera.clip_near = cameraNode.nearclip
		newCamera.clip_far = cameraNode.farclip
		newCamera.fov = cameraNode.fov
		newCamera.clip_on = cameraNode.clipManually
		newCamera
	),
	fn getNewMaxCamera =
	(
		newCamera = freeCamera()
		if ( IsTargetCam() ) then
		(
			newCamera.type = #target
			setTargetCamTmTo newCamera
		)else 
		(
			newCamera.type = #free
			setFreeCamTmTo newCamera
			newCamera.target_distance = cameraNode.target_distance * WorldUnitMultiplier()
		)
		-- setRendApertureWidth ( cameraNode.film_width )  
		newCamera.nearrange = cameraNode.environment_near
		newCamera.farrange = cameraNode.environment_far
		newCamera.nearclip = cameraNode.clip_near 
		newCamera.farclip = cameraNode.clip_far 
		newCamera.fov = cameraNode.fov
		newCamera.clipManually = cameraNode.clip_on
		newCamera
	),
	fn CopyDataToThisCamera newCam andReplaceExisting:true andbakeAnim:true  =
	(
			if andbakeAnim do
			(
				print "bak"
				if ( IsTargetCam()  )then 
				(
					BakeAnimTo newCam inAnimRange:animationrange withStep:1 fnCopyTm:setTargetCamTmTo 
				)else
				(
					BakeAnimTo newCam inAnimRange:animationrange withStep:1 fnCopyTm:setFreeCamTmTo 
				)
			)
			
			if andReplaceExisting then
			(
				newCam.name = cameraNode.name
				delete cameraNode
			)else
			(
				newCam.name = cameraNode.name + "_Copy"
			)
			select newCam
			cameraNode = newCam
	),
	fn ConvertToVray andReplaceExisting:true andbakeAnim:true =
	(
		print andbakeAnim
		if (classOf cameraNode != VRayPhysicalCamera ) then 
		(
			CopyDataToThisCamera ( getNewVRayCamera() ) andReplaceExisting:andReplaceExisting andbakeAnim:andbakeAnim 
		)
	),
	fn ConvertFromVray andReplaceExisting:true andbakeAnim:true =
	(
		print andbakeAnim
		if (classOf cameraNode == VRayPhysicalCamera ) then 
		(
			CopyDataToThisCamera ( getNewMaxCamera() ) andReplaceExisting:andReplaceExisting andbakeAnim:andbakeAnim 
		)
	)
)
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------------------- END OF: MaxCameraWrapperStruct

----------------------------------------------------------------------------------------------------------------------------------------------------------------------- ProxyAndOverScanStruct
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
struct ProxyAndOverScanStruct 
(
	proxySize = #(.75,.5,.25,.125,.0625),
	currentProxyIndex = 0, -- 0 means no proxy
	overScanRatioWidth = 1.0,
	overScanRatioHeight = 1.0,
	usingOverScan = true,
	
	fn setFileProperties =
	(
		fileProperties.addProperty #custom "currentProxyIndex" currentProxyIndex
	),
	fn getFileProperties =
	(
		theIndex = fileProperties.findProperty #custom "currentProxyIndex"
		if theIndex > 0 then
		(
			currentProxyIndex =  fileProperties.getPropertyValue #custom theIndex
		) else setFileProperties()
	),
	fn getProxyMultiplier proxyIndex:currentProxyIndex = ( if proxyIndex == 0 then 1 else proxySize[proxyIndex] ),	
	fn getPixelWidthOf pxWidth proxyIndex:currentProxyIndex = ( pxWidth * ( getProxyMultiplier proxyIndex:proxyIndex) * ( if usingOverScan then overScanRatioWidth else 1 ) ) as integer ,
	fn getPixelHeightOf pxheight proxyIndex:currentProxyIndex  = ( pxheight * ( getProxyMultiplier proxyIndex:proxyIndex ) * ( if usingOverScan then overScanRatioHeight else 1 ) ) as integer ,
	fn setProxyResolutionToIndex i =
	(
		currentProxyIndex = i
		setFileProperties()
	),
	fn InitialiseWith theCamData =
	(
		print theCamData
		getFileProperties() 
		pxWidth = floor ( theCamData.pixelWidth * ( getProxyMultiplier() ) )
		pxheight = floor ( theCamData.pixelHeight * ( getProxyMultiplier() ) )
		overScanRatioWidth = ( renderWidth as float ) / pxWidth
		overScanRatioHeight = ( renderHeight as float ) / pxheight
	)
)
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------------------- END OF: ProxyAndOverScanStruct

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------- ProjectSettingsStruct
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
struct ProjectSettingsStruct -- singleton shared across rollouts
(
	currentCamera = camDataStruct(),
	heightPropertyName = "project Resolution Height",
	widthPropertyName = "project Resolution Width",
	cameraDataPath = "$userscripts/KenzorsScripts/CameraTrack/CameraData.txt",
	userCameraDataPath =  "$userscripts/KenzorsScripts/CameraTrack/UserCameraData.txt",
	camData = #(),
	userCamData = #(),
	allMaxCameras = #(), --array of MaxCameraWrapperStruct,
	imageScale = ProxyAndOverScanStruct(),
	/*
	isFilmBackInMM = true,
	fn getFilmBackUnits =
	(
		if isFilmBackInMM then 1 else 25.4
	),
	fn setIsFilmBackInMMTo val =
	(
		isFilmBackInMM = val
	),
	*/
	fn setFileProperties =
	(
		fileProperties.addProperty #custom "cameraName"  currentCamera.cameraName
		fileProperties.addProperty #custom widthPropertyName  ( currentCamera.pixelWidth )
		fileProperties.addProperty #custom heightPropertyName ( currentCamera.pixelHeight )
		fileProperties.addProperty #custom "filmBackWidth"  currentCamera.filmBackWidth
		imageScale.setFileProperties()
	),
	------------------------------------------------------------------------------------------------------------------------ 
	fn GetSizeFromRenderDialog = 
	(
		currentCamera.GetSizeFromRenderDialog()
		setFileProperties()
	),
	------------------------------------------------------------------------------------------------------------------------
	fn getFrameWidth = currentCamera.pixelWidth,
	fn getFrameHeight = currentCamera.pixelHeight,
	fn	getFilmBackWidth= currentCamera.filmBackWidth,
	fn getCameraName = currentCamera.cameraName,
	------------------------------------------------------------------------------------------------------------------------
	fn setProxyResolutionToIndex i =
	(
		imageScale.setProxyResolutionToIndex i 
		currentCamera.SetRenderSize withMultipler:imageScale
		-- if i == 0 then multiplyResolutionBy 1 else multiplyResolutionBy proxySize[i]		
	),
	fn getResolutionStringForProxy i =
	(
		w = imageScale.getPixelWidthOf currentCamera.pixelWidth proxyIndex:i 
		h = imageScale.getPixelHeightOf currentCamera.pixelHeight proxyIndex:i
		( w as string ) + "x" + ( h as string ) 
	),
	fn getProxyResolutionIndex = imageScale.currentProxyIndex,
	------------------------------------------------------------------------------------------------------------------------
	fn getOverScanWidthPercent = imageScale.overScanRatioWidth * 100.0 ,
	fn getOverScanHeightPercent = imageScale.overScanRatioHeight * 100.0 ,
	fn setOverScanWidthPercentTo val = 
	(
		imageScale.overScanRatioWidth = val /100.0
		currentCamera.SetRenderWidth withMultipler:imageScale  -- also sets render FilmBackWidth
	),
	fn setOverScanWidthPixelsTo val = 
	(
		imageScale.overScanRatioWidth = ( val as float ) / ( currentCamera.pixelWidth *  ( imageScale.getProxyMultiplier() ) )
		currentCamera.SetRenderWidth withMultipler:imageScale -- also sets render FilmBackWidth
	),
	fn setOverScanFilmBackWidthTo val = 
	(
		imageScale.overScanRatioWidth = val / ( currentCamera.filmBackWidth )
		currentCamera.SetRenderWidth withMultipler:imageScale -- also sets render FilmBackWidth
	),
	fn setOverScanHeightPercentTo val = 
	(
		imageScale.overScanRatioHeight = val /100.0
		currentCamera.SetRenderHeight withMultipler:imageScale
	),
	fn setOverScanHeightPixelsTo val = 
	(
		imageScale.overScanRatioHeight = ( val as float ) / ( currentCamera.pixelHeight  *  ( imageScale.getProxyMultiplier() ) )
		currentCamera.SetRenderHeight withMultipler:imageScale
	),
	------------------------------------------------------------------------------------------------------------------------
	fn LoadCameraDataFrom sStream =
	(
		sStream.ReadHeadLineAndVersionNumber()
		camData = sStream.collectStructArrayToEOF camDataStruct
	),
	fn LoadCameraDataFromFilePath fPath =
	(
		if (fPath != undefined) then 
		( 
			if (doesFileExist fPath ) then
			(
					f = openfile fPath
					LoadCameraDataFrom ( StringStreamStruct f )
					close f
					true
			)else false
		)else false
	),
	------------------------------------------------------------------------------------------------------------------------
	fn storeLenses theCameras:cameras =
	(
		-- originalImageWidth  = renderWidth
		-- originalImageHeight = renderHeight
		-- originalApetureWidth = getRendApertureWidth()
		allMaxCameras = for obj in theCameras where  ( SuperClassOf obj == camera ) and ( ClassOf obj != VRayDomeCamera ) collect ( MaxCameraWrapperStruct obj)
		for obj in allMaxCameras do obj.getLensSize()
	),
	fn resetLenses =
	(
		for obj in allMaxCameras do obj.resetLens()
	),
	------------------------------------------------------------------------------------------------------------------------
	fn ConvertToVRay theCameras andReplaceExisting:true andBakeAnim:true=
	(
		storeLenses theCameras:theCameras
		for obj in allMaxCameras do obj.ConvertToVRay andReplaceExisting:andReplaceExisting andBakeAnim:andBakeAnim
	),
	fn ConvertFromVRay theCameras andReplaceExisting:true andBakeAnim:true=
	(
		storeLenses theCameras:theCameras
		for obj in allMaxCameras do obj.ConvertFromVRay andReplaceExisting:andReplaceExisting andBakeAnim:andBakeAnim
	),
	------------------------------------------------------------------------------------------------------------------------
	fn SetRenderSizeForCameraIndex i =
	(
			camData[i].SetRenderSize withMultipler:imageScale
			currentCamera = camData[i]
			setFileProperties()
	),
	------------------------------------------------------------------------------------------------------------------------
	fn Initialise =
	(
		LoadCameraDataFromFilePath cameraDataPath
		heightIndex = fileProperties.findProperty #custom  heightPropertyName
		widthIndex = fileProperties.findProperty #custom  widthPropertyName
		cameraNameIndex = fileProperties.findProperty #custom "cameraName" 
		filmBackIndex = fileProperties.findProperty #custom "filmBackWidth"
		if ( HeightIndex > 0 ) and ( widthIndex > 0 )  and ( filmBackIndex > 0 ) and ( cameraNameIndex > 0 ) then
		(
			currentCamera.pixelHeight = fileProperties.getPropertyValue #custom heightIndex
			currentCamera.pixelWidth = fileProperties.getPropertyValue #custom widthIndex
			currentCamera.cameraName = fileProperties.getPropertyValue #custom cameraNameIndex
			currentCamera.filmBackWidth =  fileProperties.getPropertyValue #custom filmBackIndex
			imageScale.InitialiseWith currentCamera
			true
		)else
		(
			GetSizeFromRenderDialog()
			false
		)
	),
	init = Initialise(),
	fn setCustomCamera cameraName: pWidth: pHeight: filmBackWidth: =
	(
		currentCamera = copy currentCamera
		currentCamera.pixelHeight = pHeight
		currentCamera.pixelWidth = pWidth
		currentCamera.cameraName = cameraName
		currentCamera.filmBackWidth = filmBackWidth
		currentCamera.SetRenderSize withMultipler:imageScale
		setFileProperties()
	)
)
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------------- END OF: ProjectSettingsStruct

KenzorsCameraResolutionToolSettings = ProjectSettingsStruct()

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- LockCamRoll
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
rollout LockCamRoll "Lock Camera Transforms"
(
	-------------------------------------------------------------------- required for kenzorsRolloutManager
	Local isRolledOut = true
	fn rolledUpEventFn = 
	( --- required undefined varible for kenzorsRolloutManager
	)
	on LockCamRoll rolledUp val do ( isRolledOut = val ; rolledUpEventFn()) 
	-------------------------------------------------------------------------------------------------------------
	fn KenzorsSetSelectedCameraLocksTo CameraLockBool =
	(
		theList = for obj in selection where (SuperClassOf obj == camera) collect obj
		if theList.count >0 then
		(
			TransformLockFlag = if CameraLockBool then #all else #none
			setTransformLockFlags theList TransformLockFlag
		)
	)
	fn KenzorsSetAllCameraLocksTo CameraLockBool =
	(
		TransformLockFlag = if CameraLockBool then #all else #none
		setTransformLockFlags cameras TransformLockFlag
	)
	checkButton chkBtnLockAllCameraTransform "lock all" across:2
	checkButton chkBtnLockSelectedCameraTransform "lock selected"
	
	on chkBtnLockAllCameraTransform changed state do
	(
		KenzorsSetAllCameraLocksTo state
	)
	
	on chkBtnLockSelectedCameraTransform changed state do
	(
		KenzorsSetSelectedCameraLocksTo state
	)
)
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------- END OF: LockCamRoll

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- ExtendFrameRoll
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
rollout ExtendFrameRoll "Overscan"
(
	-------------------------------------------------------------------- required for kenzorsRolloutManager
	Local isRolledOut = true
	fn rolledUpEventFn = 
	( --- required undefined varible for kenzorsRolloutManager
	)
	on ExtendFrameRoll rolledUp val do ( isRolledOut = val ; rolledUpEventFn()) 
	-------------------------------------------------------------------------------------------------------------
	local allCameras = #()
	local originalImageWidth,originalImageHeight,originalApetureWidth

	fn storeLenses =
	(
	--	originalImageWidth  = renderWidth
	--	originalImageHeight = renderHeight
	--	originalApetureWidth = getRendApertureWidth()
		allCameras = for obj in cameras where  ( SuperClassOf obj == camera ) collect ( MaxCameraWrapperStruct obj)
		for obj in allCameras do obj.getLensSize()
	)
	fn resetLenses =
	(
		for obj in allCameras do obj.resetLens()
	)
	----------------------------------------------------------------------------------
	group "extend frame"
	(
	spinner spnWidthPercent "Image Width:  %" range:[0,100000,100]  fieldWidth:40 align:#right offset:[-100,10]
	spinner spnWidthPixels "pixels" range:[0,100000,renderWidth] type:#integer fieldWidth:50 align:#right offset:[0,-21]	
	spinner spnHeightPercent "Image Height:  %"  range:[0,100000,100] fieldWidth:40 align:#right offset:[-100,0]
	spinner spnHeightPixels  "pixels" range:[0,100000,renderHeight] type:#integer fieldWidth:50 align:#right offset:[0,-21]
	spinner spnImageAspect "Image Aspect" scale:001 fieldWidth:50 align:#right type:#float  enabled:false
	button btnReset "reset" Width:50 align:#left 
	spinner spnFilmBackWidth "Film Back Width" fieldWidth:50 align:#right offset:[-30,-21]
	checkButton chkBtnFilmBackUnits "mm" Width:30 align:#right offset:[0,-24]
	)
	----------------------------------------------------------------------------------
	fn getFilmBackUnits =
	(
		if chkBtnFilmBackUnits.checked then 25 else 1
	)
	----------------------------------------------------------------------------------
	fn refreshWidth =
	(
		spnWidthPercent.value = KenzorsCameraResolutionToolSettings.getOverScanWidthPercent()
		spnWidthPixels.value = renderWidth
		spnImageAspect.value = getRendImageAspect() 
		spnFilmBackWidth.value = getRendApertureWidth() / getFilmBackUnits()
		ProxyResolutionRoll.RefeshRollout()
	)
	fn refreshHeight =
	(
		
		spnHeightPercent.value = KenzorsCameraResolutionToolSettings.getOverScanHeightPercent()
		spnHeightPixels.value = renderHeight
		spnImageAspect.value = getRendImageAspect()
		ProxyResolutionRoll.RefeshRollout()
	)
	fn RefeshRollout =
	(
		spnWidthPixels.value = renderWidth
		spnWidthPercent.value = KenzorsCameraResolutionToolSettings.getOverScanWidthPercent()
		spnFilmBackWidth.value = getRendApertureWidth() / getFilmBackUnits()
		spnHeightPixels.value = renderHeight
		spnHeightPercent.value = KenzorsCameraResolutionToolSettings.getOverScanHeightPercent()
		spnImageAspect.value = getRendImageAspect() 
		-- 
	)
	----------------------------------------------------------------------------------
	on ExtendFrameRoll open do
	(
		storeLenses()
		RefeshRollout()
	)
	----------------------------------------------------------------------------------
	on spnWidthPixels buttondown do storeLenses()
	on spnWidthPercent buttondown do storeLenses()
	----------------------------------------------------------------------------------
	on spnWidthPercent changed Val do
	(
		KenzorsCameraResolutionToolSettings.setOverScanWidthPercentTo val
		--spnWidthPixels.value = renderWidth
		--spnImageAspect.value = getRendImageAspect() 
		--	spnFilmBackWidth.value = getRendApertureWidth()
		resetLenses()
		refreshWidth()
	)
	on spnWidthPixels changed Val do
	(
		/*
		renderWidth = val 
		renderSceneDialog.Update()
		setRendApertureWidth ( originalApetureWidth * val / originalImageWidth )
		*/
		KenzorsCameraResolutionToolSettings.setOverScanWidthPixelsTo val
		resetLenses()
		refreshWidth()
		
	)
	----------------------------------------------------------------------------------
	on spnFilmBackWidth changed val do
	(
		KenzorsCameraResolutionToolSettings.setOverScanFilmBackWidthTo ( val * getFilmBackUnits() )
		-- setRendApertureWidth val
		-- renderSceneDialog.Update()
		resetLenses()
		refreshWidth()
	)
	----------------------------------------------------------------------------------
	-- changing height does not effect the lens size so there is no need to store the lens first.
	on spnHeightPixels changed val do
	(
		/*
		renderHeight = val
		renderSceneDialog.Update()
		*/
		KenzorsCameraResolutionToolSettings.setOverScanHeightPixelsTo val
		refreshHeight()
		resetLenses() 
	)
	on spnHeightPercent changed val do
	(
		KenzorsCameraResolutionToolSettings.setOverScanHeightPercentTo val
		refreshHeight()
		resetLenses() 
	)
	----------------------------------------------------------------------------------
	on btnReset pressed do
	(
		storeLenses()
		KenzorsCameraResolutionToolSettings.setOverScanWidthPercentTo 100.0
		KenzorsCameraResolutionToolSettings.setOverScanHeightPercentTo 100.0
		ProxyResolutionRoll.RefeshRollout()
		resetLenses()
		RefeshRollout()
		
	)
	----------------------------------------------------------------------------------
	on chkBtnFilmBackUnits changed isInches do 
	(
		chkBtnFilmBackUnits.text = ( if isInches then "inch" else "mm" )
		RefeshRollout()
	)

)
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------------------- END OF: ExtendFrameRoll

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- vRayCameraRoll
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
rollout ConvertVRayCameraRoll "V-Ray Camera"
(
	-------------------------------------------------------------------- required for kenzorsRolloutManager
	Local isRolledOut = false
	fn rolledUpEventFn = 
	( --- required undefined varible for kenzorsRolloutManager
	)
	on ConvertVRayCameraRoll rolledUp val do ( isRolledOut = val ; rolledUpEventFn()) 
	-------------------------------------------------------------------------------------------------------------	
	checkbox chkReplace "replace Existing" checked:true across:2
	checkbox chkBakeAnim "Bake Anim" checked:true
	checkbutton chkConvertToVRay "Convert TO Vray" checked:true
	group "convert Camera"
	(
	button btnVRayCameraConvertAll "convert All" across:2
	button btnVRayCameraConvertSelected "convert Selected"
	)

		
	on chkConvertToVRay changed isOn do
	(
		chkConvertToVRay.text = if isOn then  ( "Convert TO Vray"  ) else  ( "Convert TO Max"  ) 
		btnVRayCameraConvertAll.text = if isOn then  ( "All TO Vray"  ) else  ( "All TO Max"  ) 
		btnVRayCameraConvertSelected.text = if isOn then  ( "Selected TO Vray"  ) else  ( "Selected TO Max"  ) 
	)

	fn convertTheseCameras theCameraList =
	(
		if chkConvertToVRay.checked then
		(
			KenzorsCameraResolutionToolSettings.ConvertToVRay theCameraList andReplaceExisting:(chkReplace.checked) andbakeAnim:(chkBakeAnim.checked)
		)else
		(
			KenzorsCameraResolutionToolSettings.ConvertFromVRay theCameraList andReplaceExisting:(chkReplace.checked) andbakeAnim:(chkBakeAnim.checked)
		)
	)
		
	on btnVRayCameraConvertAll pressed do
	(
		convertTheseCameras cameras
	)
	
	on btnVRayCameraConvertSelected pressed do
	(
		theCameraList = for obj in selection where ( superclassof obj == camera ) collect obj
		convertTheseCameras theCameraList
	)
)
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------------------------------- END OF: vRayCameraRoll

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------- ProxyResolutionRoll
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
rollout ProxyResolutionRoll "Proxies"
(
	-------------------------------------------------------------------- required for kenzorsRolloutManager
	Local isRolledOut = true
	fn rolledUpEventFn = 
	( --- required undefined varible for kenzorsRolloutManager
	)
	on ProxyResolutionRoll rolledUp val do ( isRolledOut = val ; rolledUpEventFn()) 
	-------------------------------------------------------------------------------------------------------------

	checkbutton btnBaseSize "" width:70 
	checkbutton btnP1 "" width:70 across:3
	checkbutton btnP2 ""  width:70 
	checkbutton btnP3 "" width:70 

	fn getResAsStringForProxy i = KenzorsCameraResolutionToolSettings.getResolutionStringForProxy i
	fn setButtonsToIndex i =
	(
		btnBaseSize.state = (i ==0)
		btnP1.state = (i == 1)
		btnP2.state = (i == 2)
		btnP3.state = (i == 3)
	)
	fn setButtonIndex i isOn =
	(
		if not isOn do i = 0
		KenzorsCameraResolutionToolSettings.setProxyResolutionToIndex i 			
		setButtonsToIndex i
		ExtendFrameRoll.RefeshRollout()
	)
	fn refeshRollout =
	(
		btnBaseSize.text = getResAsStringForProxy 0
		btnP1.text = getResAsStringForProxy 1
		btnP2.text = getResAsStringForProxy 2
		btnP3.text = getResAsStringForProxy 3
	)
	on btnBaseSize changed state do setButtonIndex 0 state
	on btnP1 changed state  do setButtonIndex 1 state
	on btnP2 changed state  do  setButtonIndex 2 state
	on btnP3 changed state  do  setButtonIndex 3 state
	--on btnP4 pressed do multiplyResolutionBy proxySize[4]
		
	on ProxyResolutionRoll open do 
	(
		refeshRollout()
		setButtonsToIndex ( KenzorsCameraResolutionToolSettings.getProxyResolutionIndex() )
	)
)
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------ END OF: ProxyResolutionRoll

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- SetRealCameraRoll
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
rollout SetRealCameraRoll "Project Resolution and camera Film Back"
(
	-------------------------------------------------------------------- required for kenzorsRolloutManager
	Local isRolledOut = true
	fn rolledUpEventFn = 
	( --- required undefined varible for kenzorsRolloutManager
	)
	on SetRealCameraRoll rolledUp val do ( isRolledOut = val ; rolledUpEventFn()) 
	-------------------------------------------------------------------------------------------------------------
	local camData = KenzorsCameraResolutionToolSettings.camData  --- passed by reference
	
	fn myfillFn obj = 
	( 
		#( obj.cameraName,( obj.getResolutionWidthAsString()) , ( obj.getResolutionHeightAsString()), obj.getFilmBackWidthAsString() , obj.getImageAspectAsString() )
	)
	group ""
	(
		label lblCameraName offset:[0,-5]
		button btnAddCameraToList "add" align:#right offset:[0,-21] 
		spinner spnWidth "x" range:[0,100000,0] type:#integer fieldWidth:40 align:#left offset:[0,5] 
		spinner spnHeight "y"  range:[0,100000,0] type:#integer fieldWidth:40 align:#left offset:[65,-21]
		spinner spnImageAspect "Aspect" scale:001 fieldWidth:40 type:#float align:#right offset:[0,-21] enabled:false	
		spinner spnFilmBackWidth "Film Back Width" fieldWidth:50 align:#right offset:[-33,6] --enabled:false
		checkButton chkBtnFilmBackUnits "mm" Width:30 align:#right offset:[0,-24]
	)
	label lbl "Pick render settings by camera"
	dotNetControl dnListObjectRealCamera "System.Windows.Forms.ListView"  width:260 height:200 align:#left Offset:[-15,0]
	Local DnList = ( dnListViewWithDragDropStruct dnListObjectRealCamera myfillFn &camData )
	fn getFilmBackUnits =
	(
		if chkBtnFilmBackUnits.checked then 25 else 1
		-- 1
	)
	fn RefeshRollout =
	(
		lblCameraName.text = KenzorsCameraResolutionToolSettings.getCameraName() 
		spnWidth.value = KenzorsCameraResolutionToolSettings.getFrameWidth() 
		spnHeight.value = KenzorsCameraResolutionToolSettings.getFrameHeight() 
		-- spnImageAspect.value = KenzorsCameraResolutionToolSettings.getImageAspect() 
		spnFilmBackWidth.value  = KenzorsCameraResolutionToolSettings.getFilmBackWidth() / getFilmBackUnits()
	)
	on SetRealCameraRoll open do 
	(
		DnList.init  #(#("Name",80),  #("x",37), #("y",37) ,#("width mm",57) , #("Aspect",45)  ) chkBx:false multi:false drop:false
		DnList.fill()
		RefeshRollout()
	)
	fn setCustomCamera =
	(
		lblCameraName.text = "custom camera"
		KenzorsCameraResolutionToolSettings.setCustomCamera cameraName:( lblCameraName.text) pWidth:( spnWidth.value)  pHeight:( spnHeight.value)  filmBackWidth:( spnFilmBackWidth.value * (getFilmBackUnits()) )
		ProxyResolutionRoll.RefeshRollout()
		ExtendFrameRoll.RefeshRollout()
	)
	on spnWidth changed val do setCustomCamera()
	on spnHeight changed val do setCustomCamera()
	on spnFilmBackWidth changed val do setCustomCamera()
	
	on dnListObjectRealCamera mousedown args do 
	(
		DnList.SelectAndHighLightMousePosition()
		--- DnList.setBtn args
		if DnList.selectedRow > 0 then
		(
			KenzorsCameraResolutionToolSettings.SetRenderSizeForCameraIndex DnList.selectedRow
			RefeshRollout()
			ProxyResolutionRoll.RefeshRollout()
			ExtendFrameRoll.RefeshRollout()
		)  else 
		(
			---
		)
	)
	on chkBtnFilmBackUnits changed isInches do 
	(
		chkBtnFilmBackUnits.text = ( if isInches then "inch" else "mm" )
		RefeshRollout()
	)
	
)
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------------------------------- END OF: SetRealCameraRoll


-------------------------------------------------------------------------------------------------------------------------------------------------------------------------- CloneAndFixCameraRoll
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
rollout CloneAndFixCameraRoll "Clone with Animation"
(
	Local isRolledOut = false --- required varible for kenzorsRolloutManager
	fn rolledUpEventFn = 
	( --- required undefined varible for kenzorsRolloutManager
	)
	on CloneAndFixCameraRoll rolledUp val do ( isRolledOut = val ; rolledUpEventFn()) --- required function for kenzorsRolloutManager
	---------------------------------------------------------------------------------------------
	local fromObj = undefined
	local newCamera = undefined
	------------------------------------------------------------------------------------------
	PickButton BtnFrom "Pick" width:40 align:#left offset:[-5,0]
	Button btnFromObj ""	width:129 align:#left offset:[37,-26]

	checkBox chkPosition "Pos" checked:true across:2
	checkBox chkRotation "Rot" checked:true 
	
	Button BtnBake "Clone and Fix" width:80 across:2 enabled:false
	Spinner SpnStep "Step" range:[1,100,1] type:#integer fieldwidth:30 
	
	------------------------------------------------------------------------------------------------
	fn checkAndSelect theObj =
	(
		( if theObj !=undefined and (not isDeleted theObj) do select theObj )
	)
	fn checkNodesOK =
	(
		checkOK = fromObj !=undefined and (not isDeleted fromObj) and toObj !=undefined and (not isDeleted toObj) and fromObj != toObj
		BtnBake.enabled = checkOK
		checkOK
	)
	fn checkObjectsHaveTheSameAxisOrder = 
	(
		theCheck = if checkNodesOK() then
		(
			fromObj.transform.determinantsign == toObj.transform.determinantsign 
		)else undefined
		Lbl_flippedAxis.text = (if theCheck == false then "warning: mirrored axis" else "" )
	)
	fn getTargetObjectTm =
	(
		tm = fromObj.transform
	)
	local mirrorTm =  (matrix3 [1,0,0] [0,1,0] [0,0,1] [0,0,0])
	fn setMirrorTmWithAxisID i =
	(
		mirrorTm = case i of
		(
			0:(matrix3 [1,0,0] [0,1,0] [0,0,1] [0,0,0])
			1:(matrix3 [-1,0,0] [0,1,0] [0,0,1] [0,0,0])
			2:(matrix3 [1,0,0] [0,-1,0] [0,0,1] [0,0,0])
			3:(matrix3 [1,0,0] [0,1,0] [0,0,-1] [0,0,0])
		)
	)

	fn getMirroredTargetObjectTm =
	(
		tm = mirrorTm  * fromObj.transform
	)
	local ptrgetTargetObjectTm =  getTargetObjectTm
		
	On BtnFrom picked obj do ( btnFromObj.text = obj.name ; fromObj = obj ; checkNodesOK() ; checkObjectsHaveTheSameAxisOrder() )
	On BtnTo picked obj do ( btnToObj.text = obj.name ; toObj = obj ; checkNodesOK() ; checkObjectsHaveTheSameAxisOrder() )
	on btnFromObj pressed do checkAndSelect fromObj
	on btnToObj pressed do checkAndSelect toObj
	fn RemoveKeysFromTarget =
	(
		if chkRotation.checked then ( deleteKeys toObj.Rotation.controller.keys #allKeys )
		if chkPosition.checked then ( deleteKeys toObj.Position.controller.keys #allKeys )
		-- if chkScale.checked then ( deleteKeys toObj.scale.controller.keys #allKeys )
	)
	fn BakeTheAnim =
	(
		for t = animationrange.start to animationrange.end by SpnStep.value do
		(
			at time t 
			(
				tm = fromObj.transform 
				if chkRotation.checked then ( with animate on ( toObj.Rotation = inverse tm.rotation ) )
				if chkPosition.checked then ( with animate on ( toObj.position = tm.position ) )
				-- if chkScale.checked then ( with animate on ( toObj.scale = tm.scale ) )
			)
		)
	)
	
	on BtnBake pressed do 
	(
		if checkNodesOK() do
		(
			if chkRemoveKeysBeforeBaking.checked do RemoveKeysFromTarget()
			BakeTheAnim()
		)
	)
	
)
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------------- END OF: CloneAndFixCameraRoll

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- 
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

KenzorsTweakCameraManager = KenzorsRolloutManagerStruct  "Camera Resolution tool" 270 #( KenzorsAboutMeRoll, ProxyResolutionRoll, LockCamRoll, ExtendFrameRoll ,SetRealCameraRoll,ConvertVRayCameraRoll,CloneAndFixCameraRoll)
KenzorsTweakCameraManager.Initalize()
KenzorsAboutMeRoll.wwwHelp = "http://www.designimage.co.uk/real-3dsmax-camera-resolution-tool/"

