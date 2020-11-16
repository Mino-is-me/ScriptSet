/*------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- version 1.10
-- Previs
-- By ken turner
-- www.designimage.co.uk

----- version history -------
-- 06/09/2015 		v 1.10 
-- 25/01/2012		v 1.07	Fixed lost story bug. Added ablity to pick camera objects
-- 23/01/2012		v 1.06	Adjusted to allow vray camera support
-- 03/01/2012		v 1.05	Cleaned up for release.

----- notes ------
-- method to generate an AttribID -- GenClassId()
-- dot net reference http://www.scriptspot.com/bobo/mxs9/dotNet/dotNetObject_System.Windows.Forms.TabControl.html

--Get a snapshot of the active viewport:
ssBitmap3 = windows.snapshot (viewport.getHWnd()) 
display ssBitmap3 caption:"Active Viewport"

*/----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

if PrevisFloater != undefined then PrevisFloater.closeup()
PrevisFloater = undefined

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
fileIn ( "$userscripts/KenzorsScripts/Common/kenzorsRolloutManager.ms" )
fileIn ( "$userscripts/KenzorsScripts/Previs/dnListViewWithDragDropStruct.ms")
fileIn ( "$userscripts/KenzorsScripts/Common/control shape.ms" )
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

PrevisTransportRoll = undefined
PrevisClipListRoll = undefined
PrevisRenderRoll = undefined
ListStoriesRoll  = undefined
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- CheckTimeCallback = undefined



-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- PreVisAttrib
CaPrevis = Attributes PreVisAttrib
AttribID:#(0x550911d9, 0x3d38d670)
(
	Parameters CamSetup rollout:params
	(
		CaRenderFilePath	Type:#string				default:"" animatable:False
		CaSequenceName type:#string				animatable:False
		CaComment		Type:#string				ui:EdtComment default:"" animatable:False
		CaClipIn				Type:#intTab 				animatable:False	tabSizeVariable:true
		CaClipOut			Type:#intTab 				animatable:False	tabSizeVariable:true
		CaCameraList		Type:#MaxObjectTab	animatable:False	tabSizeVariable:true  -- weak reference
		CaShotComment	Type:#stringTab			animatable:False	tabSizeVariable:true
		CaTotalFrames	Type:#integer				animatable:false
		CaSortIndex		Type:#integer				animatable:false
		CaIsSelected		Type:#Boolean			animatable:false
	)
	
	fn getSeconds = formattedPrint ( CaTotalFrames as float / frameRate ) format:".1f"
	
	fn clearList =
	(
		CaClipIn = #()
		CaClipOut = #()
		CaCameraList = #()
		CaShotComment = #()
	)
	
	fn getCameraNodeList =
	(
		for obj in CaCameraList collect obj.node --- to do: add data validation
	)
	
	fn AddClip cam clipIn ClipOut comment:"" =
	(
		append CaCameraList (nodeTransformMonitor node:cam forwardTransformChangeMsgs:false)
		append CaClipIn ClipIn
		append CaClipOut ClipOut
		Append CaShotComment comment
	)
	fn LaunchGUI =
	(
		test = true
		try ( filein "$userscripts/KenzorsScripts/previs/previs.ms" ) catch (messageBox "Bad path" ; test = false)
		CaIsSelected = test
	)
		
	Rollout  Params "Story Previs"
	(
		-- Label lbl "Last Export" Type:#String
		-- Label lblDate "----" Type:#String
		EditText EdtComment "" height:72
		Button ButEdit		"Edit"
		--Button ButPlay		"Play"

		on ButEdit pressed do 
		(
			LaunchGUI()
		)
	)
)
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- END OF: PreVisAttrib
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------







--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------       saveImageStruct
struct ViewportImageStruct
(
	-- http://www.scriptspot.com/3ds-max/scripts/grabviewport-2-1
	-- http://www.scriptspot.com/3ds-max/scripts/viewport-preview
	fFileName = undefined,
	imageIndex = 0,
	view_size = [0,0],
	animBmp = undefined,
	isMovie = false,
	fn findMeInExplorer =
	(
		
		explorerPath = if isMovie then
		(	
			fullPath = mapPaths.getFullFilePath fFileName 
			 "/e,/select,\"" + fullPath + "\""
		)
		else 
		(
			mapPaths.getFullFilePath  ( getFilenamePath fFileName )
		)
		ShellLaunch "explorer.exe" explorerPath
		print explorerPath
	),
	fn setImageSize =
	(
		view_size = getViewSize()
	),
	fn setup fName =
	(
		setImageSize()
		
		fFileName = fName
		fileEnding =  (toLower( getFilenameType fName ) )
		isMovie = ( fileEnding == ".avi" )
		if isMovie do (animBmp = bitmap view_size.x view_size.y filename:fFileName )
		
	),
	fn getNextFileName =
	(
		fType = getFilenameType fFileName
		fPath = getFilenamePath fFileName
		fName = getFilenameFile fFileName
		imageIndex +=1
		fIndex = formattedPrint imageIndex format:"06i"
		
		fPath + fName + "_" + fIndex + fType
	),
	fn saveFrame =
	(
		if not isMovie do
		(
			f = getNextFileName()
			animBmp = bitmap view_size.x view_size.y filename:f
		)
		dib = gw.getViewportDib()
		-- use pasteBitmap to crop the Image to the safe frame
		copy dib animBmp
		save animBmp
		if not isMovie do ( close animBmp )
	),
	fn closeAndGC =
	(
		imageIndex = 0
		close animBmp
		gc()	
	),

	fn makeImageSequence fFileName =
	(
		if fFileName !=undefined do
		(
			view_size = getViewSize()
			anim_bmp = bitmap view_size.x view_size.y filename:fFileName
			for c in clipList do c.PlayBlast anim_bmp
			close anim_bmp
			gc()	
			ramplayer fFileName ""
		)
	),
	fn makeMovie =
	(	
		for t = clipIn to clipOut do
		(
			sliderTime = t
			dib = gw.getViewportDib()
			-- use pasteBitmap to crop the Image to the safe frame
			copy dib anim_bmp
			save anim_bmp
		)
	)
	
)
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------  END OF: saveImageStruct
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------







--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- ClipStruct
struct ClipStruct 
(
	ClipCam = Undefined,
	clipIn = 0,
	clipOut = 30,
	comment = "",
	storyTime = 0,
	thumbNailIn = undefined,
	thumbNailOut = Undefined,
	oldClipIn = 0,
	oldClipOut = 0,
	--- playback speed ???
	--- comments string ??? directors note ???
	fn getLength = ( ClipOut - ClipIn ),
	fn setOldClipInOut =
	(
		oldClipIn = clipIn
		oldClipOut = clipOut
	),
	fn undoSetClipInOut =
	(
		clipIn = oldClipIn
		clipOut = oldClipOut		
	),
	fn setIn t =
	(
		clipIn = t as integer 
		if clipIn > clipOut then clipOut = Clipin + 1
	),
	fn setOut t =
	(
		clipOut = t as integer 
		if clipIn > clipOut then clipIn = clipOut - 1
	),
	fn AdjustClipOutBy timeOffset =
	(
		setOut ( timeOffset + oldClipOut)
	),
	fn AdjustClipInBy timeOffset =
	(
		setIn ( timeOffset + oldClipIn)
	),
	fn SlideClipBy timeOffset =
	(
		clipIn = timeOffset + oldClipIn
		clipOut = timeOffset + oldClipOut
	),
	fn View atInPoint:true =
	(
		if atInPoint then 
		(
			if animationRange.start > clipIn then animationRange = interval clipIn animationRange.end
			sliderTime = clipIn
		) else 
		(
			if animationRange.end < clipOut then animationRange = interval animationRange.start clipOut
			sliderTime = clipOut
		)
		if getActiveCamera() != clipCam do viewport.setCamera ClipCam
	),
	fn grabThumbNail atInPoint:true =										 ------------- to do
	(
		viewSize = getViewSize()
		viewAspect = viewSize.x / viewSize.y
		tmpBmp = bitmap 320 240 color:white
		ThumbNailBmp = bitmap 320 240 color:white

		copy dib tmpBmp -- rescales the image...
		View atInPoint:atInPoint
		dib = gw.getViewportDib()
	),
	fn MakeThumbNail =															------------- to do
	(
		ThumbHeight = 64 
		ThumbWidth = ThumbHeight * getRendImageAspect()
		
		
	),
	fn PlayClipFromNow =
	(
		stopAnimation()
		viewport.setCamera ClipCam
		if sliderTime > clipOut then sliderTime = ClipIn
		if animationRange.start > clipIn then animationRange = interval clipIn animationRange.end
		if animationRange.end < clipOut then animationRange = interval animationRange.start clipOut
		playAnimation immediateReturn:true
	),		
	fn PlayClipFromInPoint =
	(
		stopAnimation()
		viewport.setCamera ClipCam
		sliderTime = ClipIn
		playAnimation immediateReturn:true
	),
	fn setAnimRange = ( animationRange = interval clipIn ClipOut) ,
-- 	fn PlayBlast anim_bmp =
-- 	(
-- 		--createPreview() --Creates a viewport preview using the current values in the Make Preview dialog. 3ds Max 2013 added optional parameters
-- 		
-- 		viewport.setCamera ClipCam
-- 		-- createPreview outputAVI:false start:clipIn end:clipOut dspCameras:False dspHelpers:false dspSafeFrame:True dspFrameNums:True
-- 		
-- 		for t = clipIn to clipOut do
-- 		(
-- 			sliderTime = t
-- 			dib = gw.getViewportDib()
-- 			-- use pasteBitmap to crop the Image to the safe frame
-- 			copy dib anim_bmp
-- 			save anim_bmp
-- 		)
-- 	),
	fn playblastTo viewportImage =
	(
		viewport.setCamera ClipCam
		for t = clipIn to clipOut do
		(
			sliderTime = t
			viewportImage.saveFrame()
		)
		
	),
	fn SetClipCam cam =
	(
		ClipCam = cam
	)
)
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------    END OF: ClipStruct
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------



--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------    PrevisTransportRoll
rollout PrevisTransportRoll "Playback controls"
(
	Local isRolledOut = true --- required varible for kenzorsRolloutManager
	fn rolledUpEventFn = 
	( --- required undefined varible for kenzorsRolloutManager
	)
	on PrevisTransportRoll rolledUp val do ( isRolledOut = val ; rolledUpEventFn()) --- required function for kenzorsRolloutManager
	---------------------------------------------------------------------------------------------
	
	Local PrevisNode = undefined, previsNodeCa = undefined
	Local PrevisShape = ShapeStruct "$userscripts/KenzorsScripts/common/control shapes/FilmStrip.txt"
	Local ClipList = #()
	Local CurrentClipIndex = 1, currentClipOut = 0
	Local clipCount = 0
	Local ClipViewAtInPoint = True
	Local OldAnimationRange = AnimationRange, PlayBackInterval = AnimationRange
	Local totalStoryTime = 0
	Local clipEditFrameAtButtonDown = 0
	----------------------------------------------------------------------- declare function names ------------------------------------------------------------------------
	local checkTime, GotoEnd, GotoStart
	
	--local checkTimeFn = undefined -- time callback function pointer
	-- hyperlink wwwDesignimage "www.designimage.co.uk" color:blue address:"www.designimage.co.uk" align:#center
	button btnGoToStart "|<<"  		tooltip:"first clip"	across:6
	Button btnBack "|<" 				tooltip:"previous clip"
	button btnPlayFromStart "|>"  	tooltip:"play from start"
	CheckButton btnPlay ">"			tooltip:"play"
	Button btnFwd ">|"					tooltip:"next clip"
	Button btnGoToEnd ">>|"			tooltip:"last clip" 
	
	Progressbar progBar "" height:10
	-- imgTag --- to do: set up img tag as timeline view
	
	fn setProgBar =
	(
		val = 100 * (clipList[currentClipIndex].storyTime + currentTime.frame - clipList[currentClipIndex].clipIn) / totalStoryTime
		progBar.Value = val
	)
	
	----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	fn setEnabledCtrls isEnabled forPlayBack:true =
	(
		btnGoToStart.enabled = btnBack.enabled = btnPlayFromStart.enabled = btnFwd.enabled = btnGoToEnd.enabled = isEnabled
		btnPlay.state = ( not isEnabled ) and forPlayBack
		btnPlay.enabled = isEnabled or forPlayBack
	)
	--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	
	fn getNodeText = If PrevisNode != undefined then PrevisNode.text else ""
	fn getNodeName = If PrevisNode != undefined then PrevisNode.name else ""
	fn getMaxMinInOut =
	(
		--OldAnimationRange = animationrange
		newMax = -10000000
		newMin = 10000000
		for c = cliplist do
		(
			if newMax < c.clipout then newMax = c.clipout 
			if newMin > c.clipIn then newMin = c.clipIn 
		)
		interval newMin newMax
	)
	fn getCurrentRenderPath = ( PrevisNodeCa.CaRenderFilePath )
	fn setCurrentRenderPath fpath = ( PrevisNodeCa.CaRenderFilePath = Fpath )
	--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	fn SetAnimationRangeForPlayBack =
	(
		OldAnimationRange = animationRange
		MaxMinInterval = getMaxMinInOut()
		safeFramesAtEnd = 15f -- when the frame rate is bad the animation can loop back to the start before the callback fires...
		PlayIn = if MaxMinInterval.start > animationRange.start then animationRange.start else MaxMinInterval.start
		PlayOut = if (MaxMinInterval.end + safeFramesAtEnd ) < animationRange.end then animationRange.end else MaxMinInterval.end + safeFramesAtEnd
		AnimationRange = PlayBackInterval = interval playIn PlayOut
	)
	fn setTransportToClipIndex =
	(
		clipList[CurrentClipIndex].view atInPoint:ClipViewAtInPoint
		PrevisClipListRoll.HighLightCurrentClipInList()
		setProgBar()
	)
	------------------------------------------------------------------------------------ clips --------------------------------------------------------------------------------------------
	fn copyClip c =
	(
		clipStruct c.clipcam c.clipIn c.clipOut c.comment
	)
	fn CurrentClipValid =
	(
		CurrentClipIndex > 0 and ClipList.count > 0 and CurrentClipIndex <=  ClipList.count 
	)
	fn SetStoryTime =
	(
		totalStoryTime = 0
		for c in cliplist do 
		(
			c.storyTime = totalStoryTime
			totalStoryTime += c.GetLength()
		)
		totalStoryTime
	)
	fn ImportClipsFromPrevisNode =
	(
		clipList = for i = 1 to previsNodeCa.CaClipIn.count collect
		(
			clipIn = previsNodeCa.CaClipIn[i]
			clipOut = previsNodeCa.CaClipOut[i]
			clipCam = previsNodeCa.CaCameraList[i].node
			ClipComment = previsNodeCa.CaShotComment[i]
			ClipStruct clipCam clipIn clipOut ClipComment
		)
		SetStoryTime()
		--GotoStart()
	)
	----------------------------------------------------------------------------------------- Previs Nodes ---------------------------------------------------------------------------------------------
	fn setPrevisNode obj =
	(
		previsNode = obj
		previsNodeCa = (custAttributes.get previsNode.'Previs' CaPrevis ) 
		ImportClipsFromPrevisNode()
		-- dnlist.fill()  --fillInSpreadSheet 
		-- setEnabledCtrls false
	)
	fn createPrevisNode =
	(
		--( previsNode = text size:20 steps:0 text:"Previs")		
		previsShape.createShape size:1 tm:(matrix3 1) colour:blue
		previsShape.addEmptyModNamed "Previs" withCustomAttribute:CaPrevis 
		previsNode = previsShape.obj
		--custAttributes.delete AsuraObj CaAsuraAnim -- Clear all the old data rather than reset array sizes
		--nodeInvalRect previsNode
		--custAttributes.add previsNode CaPrevis
		previsNodeCa = (custAttributes.get previsNode.'Previs' CaPrevis )  -- also return this value
	)
	fn getStorySecondsText =
	(
		previsNodeCa.getSeconds()
	)
	fn writeClipListToPrevisNode =
	(
		if previsNodeCa == undefined then createPrevisNode()
		previsNodeCa.clearlist()
		for c in cliplist do
		(
			previsNodeCa.addclip c.clipCam c.clipIn c.clipOut
		)
		previsNodeCa.CaTotalFrames = SetStoryTime()
	)
	fn NewPrevisNode =
	(
		ClipList = #()
		CurrentClipIndex = 1
		currentClipOut = 0
		clipCount = 0
		ClipViewAtInPoint = True
		OldAnimationRange = AnimationRange
		PlayBackInterval = AnimationRange
		totalStoryTime = 0
		
		createPrevisNode()
		return previsNode
	)
	----------------------------------------------------------------------------------- editing  functions --------------------------------------------------------------
	fn isValidCameraObject obj =
	(
		SuperClassOf obj == camera
	)
	fn InsertClip c index:1 = --- insert the clip At the selected index - move the other clips down to fit.
	(
		if c != undefined then 
		(
			if index == 0 then index = cliplist.count
			if index > cliplist.count then index = cliplist.count +1 
			insertItem c cliplist index
			currentClipIndex = index
			ClipViewAtInPoint = True
			--dnList.fill() 
			--HighLightClipInList index 
			--PrevisTransportRoll.CurrentClipIndex = index
			--setEnabledCtrls true 
			writeClipListToPrevisNode()
		)
	)
	fn ReplaceClipCameraWithThisCameraObject c =
	(
		if c != undefined then -- ( classof c ) == freecamera or ( classof c ) == Targetcamera then
		(
			cliplist[currentClipIndex].SetClipCam c
			writeClipListToPrevisNode()
		)
	)
	fn CreateNewClipWithThisCameraObject c =
	(
		if c != undefined then -- ( classof c ) == freecamera or ( classof c ) == Targetcamera then
		(
			NewClipIn = animationrange.start.frame as integer
			NewClipOut = animationrange.end.frame as integer
			theNewClip = ClipStruct c NewClipIn NewClipOut
			InsertClip theNewClip index:( currentClipIndex + 1 )
		) 
	)
	fn SliceClip =
	(
		if CurrentClipValid() then
		(
			t = sliderTime.frame as integer
			if t > ClipList[CurrentClipIndex].clipIn and t < ClipList[CurrentClipIndex].clipOut then
			(
				c = copyClip ClipList[CurrentClipIndex]
				ClipList[CurrentClipIndex].clipOut = t
				c.clipIn = t
				InsertClip c index:( CurrentClipIndex + 1 )
			)
		)
	)
	fn DeleteCurrentClip = 
	(
		if CurrentClipValid() then
		(
			deleteitem clipList CurrentClipIndex
			If CurrentClipIndex > clipList.count do CurrentClipIndex = clipList.count 
			ClipViewAtInPoint = True
			writeClipListToPrevisNode()
			true
		) else false
	)
	fn RippleEditBy timeOffset StartClipIndex: =
	(
		for i = StartClipIndex to cliplist.count do
		(
			ClipList[i].SlideClipBy timeOffset
		)
	)
	fn editClipButtonDownMode EditMode =
	(
		case EditMode of
		(
			1:	( 
					cliplist[CurrentClipIndex].setOldClipInOut() 
				)
			2:	(
					cliplist[CurrentClipIndex].setOldClipInOut()
					if CurrentClipIndex > 2 then cliplist[CurrentClipIndex-1].setOldClipInOut()
					if CurrentClipIndex < clipList.count then cliplist[CurrentClipIndex+1].setOldClipInOut()
				)
			3:	(
					for i = CurrentClipIndex to cliplist.count do
					(
						cliplist[i].setOldClipInOut()
					)
				)
		)
	)
	fn setCurrentClipIn t EditMode:1 = 
	(
		frameOffset = (t as Integer )  - cliplist[CurrentClipIndex].OldClipIn
		case EditMode of
		(
			1:	(
					ClipList[CurrentClipIndex].SetIn t
				)
			2:	(
					if CurrentClipIndex > 1 then cliplist[CurrentClipIndex - 1].AdjustClipOutBy frameOffset
					ClipList[CurrentClipIndex].SetIn t
				)
			3:	(
					RippleEditBy frameOffset StartClipIndex:CurrentClipIndex
				)
		)
	)
	fn setCurrentClipOut t EditMode:1 = 
	(
		frameOffset = (t as Integer ) - cliplist[CurrentClipIndex].OldClipOut
		ClipList[CurrentClipIndex].SetOut t
		Case EditMode of
		(
			2:	(
					if CurrentClipIndex < clipList.count then cliplist[CurrentClipIndex+1].AdjustClipInBy frameOffset
				)
			3:	(
					RippleEditBy frameOffset StartClipIndex:( CurrentClipIndex + 1 )
				)
		)
	)
	fn GetCurrentClipIn = ( ClipList[CurrentClipIndex].clipIn )
	fn GetCurrentClipOut = ( ClipList[CurrentClipIndex].clipOut )
	----------------------------------------------------------------------------------- transport functions --------------------------------------------------------------
	fn SetCurrentClipIndex i setViewAtInPoint:true showInViewPort:false =
	(
		CurrentClipIndex = i
		ClipViewAtInPoint = setViewAtInPoint
		if showInViewPort and CurrentClipValid() then setTransportToClipIndex() else PrevisClipListRoll.HighLightCurrentClipInList()
	)
	fn GotoStart = ( SetCurrentClipIndex 1 setViewAtInPoint:true showInViewPort:true )
	fn GotoEnd = ( SetCurrentClipIndex clipList.count setViewAtInPoint:false showInViewPort:true )
	fn StepFwd = 
	(
		if not ClipViewAtInPoint then
		(
			if ( CurrentClipIndex += 1 ) > clipList.count then CurrentClipIndex = 1
		)
		ClipViewAtInPoint = not ClipViewAtInPoint
		setTransportToClipIndex()
	)
	fn StepBack =
	(
		if ClipViewAtInPoint then 
		(
			if ( CurrentClipIndex -= 1 ) < 1  then CurrentClipIndex = clipList.count
		)
		ClipViewAtInPoint = not ClipViewAtInPoint
		setTransportToClipIndex()
	)
	----------------------------------------------------------------------------------- playback functions --------------------------------------------------------------
	fn stopMe =
	(
		stopAnimation()
		unregisterTimeCallback CheckTime
		PrevisClipListRoll.HighLightCurrentClipInList playBackState:false
	)
	fn nextClip =
	(
		--format "clip count: % currentClipIndex: % \n" clipCount CurrentClipIndex
		if ( CurrentClipIndex += 1 ) > clipCount then 
		( 
			stopMe() 
			GotoEnd()
			--GotoStart()
		) 
		else 
		( 
			CurrentClipOut = clipList[CurrentClipIndex].clipOut
			clipList[CurrentClipIndex].PlayClipFromInPoint()
			PrevisClipListRoll.HighLightCurrentClipInList playBackState:true
		)
	)
	fn checkTime =
	(
		c = currentTime.frame
		setProgBar()
		if c > CurrentClipOut then nextClip()
		
	)
	fn playMe =
	(
		clipCount = cliplist.count 
		if ( clipCount ) > 0 then 
		(	
			unregisterTimeCallback CheckTime -- CheckTimeCallback
			SetAnimationRangeForPlayBack()
			PrevisClipListRoll.HighLightCurrentClipInList playBackState:true
			registerTimeCallback CheckTime -- CheckTimeCallback
			CurrentClipOut = clipList[CurrentClipIndex].clipOut
			clipList[CurrentClipIndex].PlayClipFromNow() 
		)
	)
	fn LoopPlayCurrentClip =
	(
		PrevisClipListRoll.HighLightCurrentClipInList playBackState:true
		clipList[CurrentClipIndex].setAnimRange()
		clipList[CurrentClipIndex].PlayClipFromNow() 
	)
	------------------------------------------------------------------------------------------------------ Render -----------------------------------------------------------------
	------------------------------------------------------------------------------------------------------ Preview render -------------------------------------------------------
	fn PreviewRenderMe viewportImage =
	(
		for c in clipList do (c.PlayBlastTo viewportImage)
	)
	fn BatchRenderMe fNamePath rWidth:renderWidth rHeight:renderHeight rPixelAspect:renderPixelAspect =
	(
		shotIndex = 1
		fType = getFilenameType fNamePath
		fName = getFilenameFile fNamePath
		fPath = getFilenamePath fNamePath

		for thisClip in ClipList do
		(
			shotName = fName + "_" + ( formattedPrint shotIndex format:".3u"  )
			fSequenceName = shotName + "_frame"
			batchIndex = batchRenderMgr.FindView shotName
			batchView = undefined
			if batchIndex == 0 then 
			(
				batchView = batchRenderMgr.CreateView thisClip.ClipCam 
				batchView.name = shotName -- must be unique
			)
			else 
			( 
				batchView = batchRenderMgr.GetView batchIndex 
				batchView.camera  = thisClip.ClipCam
			)
			
			batchView.overridePreset = true
			batchView.startFrame = thisClip.ClipIn
			batchView.endFrame = thisClip.ClipOut
			batchView.Width = rWidth
			batchView.Height = rHeight
			batchView.pixelAspect = rPixelAspect
			batchView.outputFileName = fPath + fSequenceName + fType
			--batchView.sceneStateName  = 
			--batchView.presetFile  = 
			shotIndex += 1
		)
		
		actionMan.executeAction -43434444 "4096"  -- Render: Batch Render Dialog Toggle  -- open the batch render dialog
		--batchRenderMgr.Render()
	)
	------------------------------------------------------------------------------------------------------ Cameras ------------------------------------------------------------------
	------------------------------------------------------------------------------------------------------ Camera selection --------------------------------------------------------
	fn getCurrentCamera = if CurrentClipValid() then clipList[CurrentClipIndex].clipCam else Undefined 
	fn getCurrentCameraTarget = if CurrentClipValid() then clipList[CurrentClipIndex].clipCam.target else Undefined 
	fn getCurrentCameraAndTarget = if CurrentClipValid() then #( ( clipList[CurrentClipIndex].clipCam ) , ( clipList[CurrentClipIndex].clipCam.target ) ) else Undefined
	------------------------------------------------------------------------------------------------------ Camera Names -----------------------------------------------------------
	fn RenameCameras Prefix startIndex =
	(
		for obj in clipList do
		(
			obj.ClipCam.Name = prefix + ( formattedPrint startIndex format:".3u"  ) 
			startIndex +=1
		)
	)
	----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	------------------------------------------------------------------------------------------------------ UI events ---------------------------------------------------------------

	on PrevisTransportRoll close do unregisterTimeCallback CheckTime
		
	on progBar clicked val do 
	(
		progBar.value = val
		val = TotalStoryTime * val / 100 --- its all frames so it stays as an integer...  
		scrubToClipIndex = 0
		for i = 1 to cliplist.count while ( val >= cliplist[i].storyTime ) do scrubToClipIndex = i
		slidertime = cliplist[scrubToClipIndex].clipIn + (val - cliplist[scrubToClipIndex].storyTime)
		if getActiveCamera() != cliplist[scrubToClipIndex].ClipCam do viewport.setCamera cliplist[scrubToClipIndex].ClipCam
		if scrubToClipIndex != CurrentClipIndex do 
		(
			CurrentClipIndex = scrubToClipIndex
			PrevisClipListRoll.HighLightCurrentClipInList()
		)
	)	
	on btnGotoStart pressed do ( GotoStart())
	on btnGotoEnd pressed do ( GotoEnd() )
	on btnBack pressed do ( StepBack() ) 
	on btnFwd pressed do ( StepFwd() )
	
	on btnPlayFromStart pressed do
	(
		GotoStart()
		PlayMe()
	)
	on btnPlay changed state do
	(
		if state == true then playMe() else stopMe()
	)
	
)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- END OF: PrevisTransportRoll
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- PrevisClipListRoll
rollout PrevisClipListRoll "Clip List" 
(
	Local isRolledOut = false --- required varible for kenzorsRolloutManager
	fn rolledUpEventFn = 
	( --- required undefined varible for kenzorsRolloutManager
	)
	on PrevisClipListRoll rolledUp val do ( isRolledOut = val ; rolledUpEventFn()) --- required function for kenzorsRolloutManager
	-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	CheckButton ChkBtnGrabCameraFrom "Grab View mode" width:120 align:#Left checked:true
	
	Button BtnAddClip "Add Clip" width:120 align:#Left offset:[0,10]
	Button BtnReplaceClipCamera "Replace Camera" width:120 align:#Left 

	--Button BtnSliceAndAddClip "Insert clip"
	Button BtnSelectCam "Select Camera" width:120 align:#Left  offset:[0,10]	
	Button BtnSelectCamTarg "Select Target" width:120 align:#Left 
	Button BtnSelectCamBoth "Select both" width:120 align:#Left 
	Button BtnSliceClip "slice clip" width:120 align:#Left offset:[0,10]	
	Button BtnMarkIn "Mark In" width:60 align:#Left 
	spinner spnClipIn "" type:#integer range:[-500,5000,animationRange.start] fieldWidth:40 align:#Left offset:[70,-22]
	Button BtnMarkOut "Mark Out" width:60  align:#Left 
	spinner spnClipOut "" type:#integer range:[-500,5000,animationRange.end] fieldWidth:40 align:#Left  offset:[70,-22]	
	CheckButton ChkBtnPlay ">" width:120 align:#Left  offset:[0,10]	
	Button BtnDeleteClip "delete Clip" width:120 align:#Left offset:[0,10]
	RadioButtons RdBtnEditMode "" Labels:#("End","Slip","Ripple") align:#Left offset:[0,10] Columns:1
	dotNetControl dnListObject  "System.Windows.Forms.ListView"  width:237 height:380 align:#right  Offset:[5,-390]
	

	fn myfillFn obj = 
	( 
		#(
			(if obj.clipCam == undefined then "" else obj.clipCam.name ),
			(obj.clipIn as String),
			(obj.clipOut as string)
		) 
	)
	
	Local DnList = dnListViewWithDragDropStruct dnListObject myfillFn &PrevisTransportRoll.clipList
	
	------------------------------------------------------------------------------------------------------------------------------
	fn setEnabledCtrls isEnabled forPlayBack:true  =
	(
		PrevisTransportRoll.setEnabledCtrls isEnabled forPlayBack:forPlayBack
		BtnAddClip.enabled = isEnabled
		ChkBtnPlay.state = ( not isEnabled ) and forPlayBack
		isValidClip = ( PrevisTransportRoll.CurrentClipValid() )
		isEnabledWithValidClip = isValidClip and isEnabled
		BtnReplaceClipCamera.enabled = isEnabledWithValidClip 
		ChkBtnPlay.enabled = isValidClip and forPlayBack
		BtnSelectCam.enabled = BtnSliceClip.enabled = BtnMarkIn.enabled = spnClipIn.enabled = spnClipOut.enabled = BtnMarkOut.enabled = BtnDeleteClip.enabled = isEnabledWithValidClip
		BtnSelectCamBoth.enabled  = BtnSelectCamTarg.enabled = isEnabledWithValidClip and ( PrevisTransportRoll.getCurrentCameraTarget() != undefined )--- and target exists
	)
	fn RefreshInOutValuesInListRow rowInt = 
	(
		DnList.refeshCellText rowInt 2
		DnList.refeshCellText rowInt 3
	)
	fn refreshInOutGui =
	(
		if PrevisTransportRoll.CurrentClipValid() then 
		(
			currentClipIn = PrevisTransportRoll.GetCurrentClipIn()
			currentClipOut = PrevisTransportRoll.GetCurrentClipOut()
			if RdBtnEditMode.state == 1 then
			(
				RefreshInOutValuesInListRow PrevisTransportRoll.currentClipIndex
			) else
			(
				for i = 1 to PrevisTransportRoll.clipList.count do RefreshInOutValuesInListRow i
			)
			spnClipIn.value = currentClipIn
			spnClipOut.value = currentClipOut
		)
	)
	fn HighLightCurrentClipInList playBackState:false =
	(
		dnList.setSelection PrevisTransportRoll.CurrentClipIndex
		refreshInOutGui()
		setEnabledCtrls ( Not playBackState)
	)
	fn Refresh =
	(
		DnList.Fill()
		HighLightCurrentClipInList()
	)
	----------------------------------------------------------------------------------------------
	----------------------------------------------------------------------------------------------
	on ChkBtnGrabCameraFrom changed state do
	(
		if state then 
		(
			ChkBtnGrabCameraFrom.text = "Grab View mode"
		) else
		(
			ChkBtnGrabCameraFrom.text = "Grab Object mode"
		)
	)
	fn CheckThisIsAValidCameraObject obj =
	(
		SuperClassOf obj == camera
	)
	fn getValidCamera =
	(
		theNewCamera = undefined
		if ChkBtnGrabCameraFrom.checked then
		(
			theNewCamera = viewport.getcamera()
			if theNewCamera == undefined do
			(
				messagebox "In 'Grab View Mode'. Highlight a camera viewport first. Then press 'add clip' or 'replace camera'."
				Undefined
			)
			theNewCamera
		)else
		(
			setEnabledCtrls false forPlayBack:false 
			theNewCamera = pickobject filter:CheckThisIsAValidCameraObject
			setEnabledCtrls true
			theNewCamera
		)
	)
	on BtnAddClip pressed do 
	( 
		obj = getValidCamera()
		if obj !=undefined then 
		(
			PrevisTransportRoll.CreateNewClipWithThisCameraObject obj
			Refresh()
		)
	)
	on BtnReplaceClipCamera pressed do 
	( 
		obj = getValidCamera()
		if obj !=undefined then 
		(
			PrevisTransportRoll.ReplaceClipCameraWithThisCameraObject obj
			Refresh()
		)
	)
	on BtnSliceClip pressed do
	(
		PrevisTransportRoll.SliceClip()
		Refresh()
	)
	on BtnDeleteClip Pressed do
	(
		if PrevisTransportRoll.DeleteCurrentClip() do Refresh()
	)
	-----------------------------------------------------------------------------------------------------------------------------
	on btnMarkIn Pressed do 
	(
		PrevisTransportRoll.setCurrentClipIn slidertime.frame -- EditMode:RdBtnEditMode.state
		refreshInOutGui()
		PrevisTransportRoll.writeClipListToPrevisNode()
	)
	on btnMarkOut Pressed do 
	(
		PrevisTransportRoll.setCurrentClipOut slidertime.frame
		refreshInOutGui()
		PrevisTransportRoll.writeClipListToPrevisNode()
	)
	------------------------------------------------------------------------------------------------------------------------------ set clip In Out
	on spnClipIn ButtonDown do 
	(
		PrevisTransportRoll.editClipButtonDownMode ( RdBtnEditMode.state)
		PrevisTransportRoll.setTransportToClipIndex()
	)
	on spnClipIn changed val do
	(
		PrevisTransportRoll.setCurrentClipIn val EditMode:RdBtnEditMode.state
		sliderTime = val
		refreshInOutGui()
	)	
	on spnClipIn entered do
	(
		PrevisTransportRoll.writeClipListToPrevisNode()
	)	
	
	on spnClipOut ButtonDown do 
	(
		PrevisTransportRoll.editClipButtonDownMode ( RdBtnEditMode.state)
		PrevisTransportRoll.setTransportToClipIndex()
	)
	on spnClipOut changed val do
	(
		PrevisTransportRoll.setCurrentClipOut val EditMode:RdBtnEditMode.state
		sliderTime = val
		refreshInOutGui()
	)
	on spnClipOut entered do
	(
		PrevisTransportRoll.writeClipListToPrevisNode()
	)
	------------------------------------------------------------------------------------------------------------------------------
	On ChkBtnPlay changed State do 
	( 
		if state then 
		(
			PrevisTransportRoll.LoopPlayCurrentClip()
		) else
		(
			PrevisTransportRoll.stopMe()
		)
	)
	------------------------------------------------------------------------------------------------------------------------------
	on BtnSelectCam Pressed do select  ( PrevisTransportRoll.GetCurrentCamera() )
	on BtnSelectCamTarg Pressed do select ( PrevisTransportRoll.GetCurrentCameraTarget() )
	on BtnSelectCamBoth pressed do select ( PrevisTransportRoll.GetCurrentCameraAndTarget() )
	------------------------------------------------------------------------------------------------------------------------------ List view Select Item
	on dnListObject mousedown do 
	(
		DnList.SelectAndHighLightMousePosition()
		--- DnList.setBtn args
		if DnList.selectedRow > 0 then
		(
			PrevisTransportRoll.SetCurrentClipIndex DnList.selectedRow setViewAtInPoint:( DnList.selectedColumn < 3) showInViewPort:( DnList.selectedColumn >1) 
		)  else 
		(
			--PrevisTransportRoll.clipIndex = 0
			--PrevisTransportRoll.ClipViewAtInPoint = True
		)
		--RefreshItemNum() 
		--HighLightCurrentClipInList()
	)
	
	------------------------------------------------------------------------------------------------------------------------ Drag and drop List View Item	
	on dnListObject DragDrop arg do 
	(
		if ( dnList.lvDragDrop arg ) do
		(
			PrevisTransportRoll.SetCurrentClipIndex DnList.selectedRow 
			refresh() 
			PrevisTransportRoll.writeClipListToPrevisNode()
		)
	)
	on dnListObject DragOver Arg do dnList.lvDragOver arg
	on dnListObject ItemDrag arg do dnList.lvItemDrag arg
	
	------------------------------------------------------------------------------------------------------------------------------
	
	on PrevisClipListRoll open do
	(
		dnList.init  #(#("Camera",140),  #("in",40), #("out",40) ) chkBx:false multi:false drop:true
		refresh()
	)
	on PrevisClipListRoll close do
	(
		--PrevisCurrentStory.writeClipListToPrevisNode()  ---- not needed because the data is written as the user edits.
	)
)

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- END OF: PrevisClipListRoll
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- ListStoriesRoll
rollout ListStoriesRoll "stories"
(
	Local isRolledOut = false --- required varible for kenzorsRolloutManager
	fn rolledUpEventFn = 
	( --- required undefined varible for kenzorsRolloutManager
	)
	on ListStoriesRoll rolledUp val do ( isRolledOut = val ; rolledUpEventFn()) --- required function for kenzorsRolloutManager
	---------------------------------------------------------------------------------------------
	local PrevisNodeList =  #()
	
	button btnNew "New" width:60 align:#left
	editText edtNodeText "" width:287 align:#right Offset:[0,-24]
	button btnCopy "Copy" width:60 align:#left
	Button btnDelete "Delete" width:60 align:#left Offset:[0,20]
	
	dotNetControl dnListObject  "System.Windows.Forms.ListView"  width:285 height:200 align:#right  Offset:[0,-70]

	fn myfillFn obj = 
	( 
		#( obj.Name , obj.'Previs'.CaComment, (obj.'Previs'.getSeconds() ) )
	)
	
	Local DnList = ( dnListViewWithDragDropStruct dnListObject myfillFn &PrevisNodeList )
	------------------------------------------------------------------------------------------------------------------------------
	fn setPrevisCurrentStorytoIndex i =
	(
		if i > 0 and i <= PrevisNodeList.count then ( PrevisTransportRoll.setPrevisNode (PrevisNodeList[i]) )
		PrevisClipListRoll.refresh()
		PrevisTransportRoll.gotoStart()
		PrevisRenderRoll.edtPath.text =  PrevisTransportRoll.getCurrentRenderPath()
	)
	fn addNewPrevisNodeToPrevisNodeList =
	(
		PrevisTransportRoll.NewPrevisNode()
	)
	fn setCaSortIndexForAllNodes =
	(
		i = 0
		for obj in PrevisNodeList do obj.Previs.CaSortIndex = ( i +=1 )
	)
	fn comparePrevisNodeCaSortIndexfn obj1 obj2 =
	(
		obj1.Previs.CaSortIndex - obj2.Previs.CaSortIndex 
	)
	fn CollectPrevisNodes =
	(
		i = 0
		selectedIndex = 1
		PrevisNodeList = For obj in objects where (IsProperty obj "Previs" ) collect 
		(
			i += 1
			if obj.Previs.CaIsSelected then selectedIndex = i
			obj
		)
		if PrevisNodeList.count == 0 Then
		(
			addNewPrevisNodeToPrevisNodeList()
			selectedIndex = 1
		)else
		(
			qsort PrevisNodeList comparePrevisNodeCaSortIndexfn
		)
		dnList.fill()
			
		dnList.SetSelection selectedIndex	
		setPrevisCurrentStorytoIndex selectedIndex
	)
	on ListStoriesRoll open do 
	(
		dnList.init  #(#("Node",60),  #("Text",160), #("Seconds",60) ) chkBx:false multi:false drop:true
		CollectPrevisNodes()
	)
	on ListStoriesRoll close do
	(
		for obj in PrevisNodeList do obj.Previs.CaIsSelected = false
		setCaSortIndexForAllNodes()
	)
	on dnListObject mousedown args do 
	(
		DnList.SelectAndHighLightMousePosition()
		--- DnList.setBtn args
		if DnList.selectedRow > 0 then
		(
			setPrevisCurrentStorytoIndex DnList.selectedRow
		)  else 
		(
			---
		)
	)
	on dnListObject DragDrop arg do dnList.lvDragDrop arg 
	on dnListObject DragOver Arg do dnList.lvDragOver arg
	on dnListObject ItemDrag arg do dnList.lvItemDrag arg
	--------------------------------------------------------------------------------------------------------------------------------

	on btnDelete Pressed do
	(
		selectedIndex = DnList.selectedRow
		if  selectedIndex > 0 and  selectedIndex <=  PrevisNodeList.count do
		(
			delete ( PrevisNodeList[selectedIndex] )
			CollectPrevisNodes() --- note if the last PrevisNode is delete a new empty one will be created here ....  toDo: does this need some sort of message to the user ?
			setCaSortIndexForAllNodes()
		)
	)
	
	on btnCopy Pressed do
	(
		selectedIndex = DnList.selectedRow
		if  selectedIndex > 0 and  selectedIndex <=  PrevisNodeList.count do
		(
			c = copy ( PrevisNodeList[selectedIndex] )
			PrevisNodeList[selectedIndex].previs.CaIsSelected = false
			c.previs.CaIsSelected = true
			insertItem c PrevisNodeList selectedIndex
			setCaSortIndexForAllNodes()
			CollectPrevisNodes()
		)
	)

	on btnNew Pressed do
	(
		addNewPrevisNodeToPrevisNodeList()
		CollectPrevisNodes()
	)
)
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------END OF: ListStoriesRoll
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------




--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- PrevisRenderRoll
rollout PrevisRenderRoll "Render" 
(
	Local isRolledOut = false --- required varible for kenzorsRolloutManager
	fn rolledUpEventFn = 
	( --- required undefined varible for kenzorsRolloutManager
	)
	on PrevisRenderRoll rolledUp val do ( isRolledOut = val ; rolledUpEventFn()) --- required function for kenzorsRolloutManager
	---------------------------------------------------------------------------------------------
	local viewportImage = undefined
	-- radioButtons rbtnAllstories labels:#("All Stories", "Selected Story")
	group "Play Blast"
	(	
		button btnPlayBlast "Preview Render" across:2 tooltip:"Chose an image file type from the drop down list to create a image sequence"
		button btnFindMeInExplorer "show Files"  tooltip:"After rendering you can click this button to open windows explorer at the file location"
	)
	group "Batch Render"
	(
		button btnBatchRender "Assign to Batch Render"   across:2
		button btnClearBatchRender "Clear Batch Render"
		
		button btnBrowser "File Path"  align:#left Offset:[0,5]
		editText edtPath ""  width:300 Align:#right Offset:[0,-24]
	)
	
	on btnFindMeInExplorer pressed do
	(
		if viewportImage != undefined do
		(
			viewportImage.findMeInExplorer()
		)
	)
	fn getTypeString typesList =
	(
		typeString = ""
		for txt in typesList do
		(
			typeString += ( txt + "(*." + txt + ")|*." + txt + "|") 
		)
		typeString
	)
	on btnPlayBlast pressed do
	(
		typeString = getTypeString  #("avi","bmp","jpg","png","tga")
		fName = getSaveFileName  "Playblast"  Types:typeString 
		if fName !=undefined do
		(
-- 			ramplayer fName ""
			viewportImage = ViewportImageStruct()
			viewportImage.setup fName
			PrevisTransportRoll.PreviewRenderMe viewportImage
			viewportImage.closeAndGC()
		)

	)
	on btnBrowser pressed do
	(
		fPath = getSaveFileName types:"*.bmp|*.bmp|*.jpg|*.jpg|*.tga|*.tga|"
		if fPath != undefined then edtPath.text = ( PrevisTransportRoll.setCurrentRenderPath fPath )
	)
	on btnBatchRender pressed do
	(
		PrevisTransportRoll.BatchRenderMe edtPath.text
	)
	on btnClearBatchRender pressed do ( for i = 1 to batchRenderMgr.numViews do batchRenderMgr.DeleteView 1)
)
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- END OF: PrevisRenderRoll
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- AddRollout PrevisTransportRoll PrevisFloater rolledup:(not PrevisTransportRoll.isRolledOut)  -- border:false

PrevisFloater = KenzorsRolloutManagerStruct  "Story Mode" 400  #( KenzorsAboutMeRoll, PrevisTransportRoll, PrevisClipListRoll, ListStoriesRoll,PrevisRenderRoll )
PrevisFloater.Initalize()
KenzorsAboutMeRoll.wwwHelp = "http://www.designimage.co.uk/previsualizationmaxscript/"

