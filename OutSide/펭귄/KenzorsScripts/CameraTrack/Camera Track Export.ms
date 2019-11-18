/*------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Export 2D Object Track
-- By ken turner
-- www.designimage.co.uk

-- 09/12/2017	3dsmax 2017 rollout bug fix

*/------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
if KenzorsCameraTrackManager != undefined then KenzorsCameraTrackManager.closeup()
KenzorsCameraTrackManager = undefined

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
fileIn ( "$userscripts/KenzorsScripts/Common/kenzorsRolloutManager.ms" )
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
rollout setAspectRatioAndAnimationRange "Aspect Ratio And Animation Range" 
(
	Local isRolledOut = false
	fn rolledUpEventFn = 
	( --- required undefined varible for kenzorsRolloutManager
	)
	on setAspectRatioAndAnimationRange rolledUp val do ( isRolledOut = val ; rolledUpEventFn())
	----------------------------------------------------------------------------------------------------------------------------------------------- aspect ratio and frame range
	
	-- Euclidean algorithm for greatest common divisor
	fn gdc a b =
	(
		while b != 0 do
		(
			t = b
			b = mod a b
			a = t
		)
	)
	
	fn CalcAspectRatio type w:renderWidth h:renderHeight = 
	(
		r = gdc w h
		case type of
		(
			#width: ( w/r)
			#height: ( h/r)
			default:1
		)
	)
	group "Animation Range:"
	(
		spinner SpnStart "Start" range:[-100000,100000,animationRange.start]  fieldwidth:35 type:#integer  offset:[0,0] across:3
		spinner SpnEnd "End" range:[-100000,100000,animationRange.end] fieldwidth:35 type:#integer  offset:[10,0] 
		button btnResetAnimationRange "reset" offset:[5,-3] 
	)
	group "Frame Aspect Ratio:"
	(
		spinner SpnWidth "width"  range:[1,10000,(CalcAspectRatio #Width)]  type:#Integer fieldwidth:35  offset:[0,0] across:3 
		spinner SpnHeight "height"  range:[1,10000,(CalcAspectRatio #Height)]  type:#Integer fieldwidth:35 offset:[10,0]
		button btnResetAnimationAspectRatio "reset" offset:[5,-3] 
	)
	
	on btnResetAnimationRange pressed do
	(
		SpnStart.value = animationRange.start
		SpnEnd.value = animationRange.end
	)
	on btnResetAnimationAspectRatio pressed do
	(
		SpnWidth.value = (CalcAspectRatio #Width)
		SpnHeight.value = (CalcAspectRatio #Height)
	)
	on SpnStart changed Val do ( if val > SpnEnd.value then SpnEnd.value = val )
	on SpnEnd changed Val do ( if val < SpnStart.value then SpnStart.value = val )
	fn getUserAspectRatio = ( SpnWidth.value as float / SpnHeight.value )
	fn getUserAnimationRange = ( interval SpnStart.value SpnEnd.value )
)
	----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
rollout exportCamRoll "Export Camera POV Track"
(
	Local isRolledOut = true
	fn rolledUpEventFn = 
	( --- required undefined varible for kenzorsRolloutManager
	)
	------------
	on exportCamRoll rolledUp val do ( isRolledOut = val ; rolledUpEventFn())
	Local divideByAspectRatioForFusion = true
	local AspectRatio = undefined -- ( renderWidth as float ) / renderHeight --- grab this from rollout above just before exporting
	Local AnimRange = undefined --- grab this from rollout above just before exporting
	

	
	Label lbl_obj "object" across:2
	Label lbl_cam "camera"
	pickbutton pckObj "pick object" autoDisplay:true across:2
	pickbutton pckCam "pick camera"  autoDisplay:true

	group "distance from camera"
	(
		checkbox chkExportZ "Export Z ( as .spl )"   across:2 
		button btnAutoZRange "Calculate Z Range" enabled:false
		spinner SpnZmin "Z: min" range:[-10000000.0,10000000.0,0.0]  fieldwidth:60  offset:[25,0] across:3
		spinner SpnZmax "max" range:[-10000000.0,10000000.0,1.0] fieldwidth:60 offset:[47,0] 
		checkbox chkFlip "flip" offset:[50,0] 
	)
	group "export" 
	(
		radioButtons rbtType "type" Labels:#("dfmo","spl (X and Y)") columns:1 across:3		
		button btnExport "export" width:40 Height:40 offset:[0,5] enabled:false
		radioButtons rbtToFile "write to" Labels:#("file","Listener") columns:1 
	)
	fn checkObjectsOk =
	(
		pckCam.object != undefined and IsValidNode pckCam.object and pckObj.object != undefined and IsValidNode pckObj.object 	
	)
	fn checkAndInitalizeOK =
	(
		AnimRange = setAspectRatioAndAnimationRange.getUserAnimationRange()
		AspectRatio = setAspectRatioAndAnimationRange.getUserAspectRatio()
		
		checkObjectsOk()
	)
	on pckObj picked obj do btnExport.enabled = btnAutoZRange.enabled =  checkObjectsOk()
	on pckCam picked obj do btnExport.enabled = btnAutoZRange.enabled =  checkObjectsOk()
	fn map cam obj =  -- toDo --- think of some cool to do if the object is behind the camera
	(
		tm = obj.transform * inverse cam.transform
		--tm = in coordsys cam (obj.transform)
		--Calculate the distance from the camera to the viewing plane ... viewing plane width is 1 unit
		viewdistance = ( tan ( (180 - cam.fov ) / 2.0) )  --- note that animated FOV is picked up because we are still in the 'at time' context of the calling function
		ratio =  viewdistance / -tm.pos.z
		x = (1.0 + ( tm.pos.x * ratio )) / 2.0
		y = (1.0 + ( tm.pos.y * ratio * AspectRatio )) / 2.0
		z = length tm.pos  
		mappedTM = [x,y,z]
	)
	fn MapPos t =
	(
		at time t 
		( 
			p = (map pckCam.object  pckObj.object  AspectRatio:AspectRatio)
			z = (p.z - SpnZmin.value) / ( SpnZmax.value - SpnZmin.value) 
			[p.x,p.y,z]
		)
	)
	on btnAutoZRange pressed do 
	(
		if checkAndInitalizeOK() then
		(
			
			Zmax = -1000000000.0
			Zmin = 1000000000.0
			for t = AnimRange.start to AnimRange.end do
			(
				at time t 
				(
					p = ( map pckCam.object pckObj.object  )
					z = p.z
					if z < Zmin then Zmin = z
					if z > Zmax then Zmax = z
				)
			)
			if chkFlip.State != true then
			(
				SpnZmin.value = Zmin
				SpnZmax.value = Zmax
			)else
			(
				SpnZmin.value = Zmax
				SpnZmax.value = Zmin
			)
		)
	)
	on chkFlip changed state do
	(
		Zmin = SpnZmin.value 
		SpnZmin.value = SpnZmax.value 
		SpnZmax.value = Zmin
	)
	---------------------------------------------------------------------------------------------------------------------- Export functions
	/* --- not currently hooked up
	fn writeAse f = 
	(

		Format "*3DSMAX_ASCIIEXPORT\t200\n" to:f
		Format "*COMMENT \"AsciiExport Version  2.00 - % \"\n"  localTime  to:f
		Format "*SCENE {\n"  to:f
		Format "\t*SCENE_FILENAME \t\"\"\n"  to:f
		Format "\t*SCENE_FIRSTFRAME\t%\n" SpnStart.value to:f
		Format "\t*SCENE_LASTFRAME\t%\n" SpnEnd.value to:f
		Format "\t*SCENE_FRAMESPEED\t%\n" frameRate  to:f
		Format "\t*SCENE_TICKSPERFRAME\t%\n" TicksPerFrame  to:f 
		Format "\t*SCENE_BACKGROUND_STATIC\t0.00000\t0.00000\t0.00000\n"  to:f
		Format "\t*SCENE_AMBIENT_STATIC\t0.00000\t0.00000\t0.00000\n"  to:f
		Format "}\n"  to:f
		-----------------------------------
		Format "*HELPEROBJECT {\n" to:f
		Format "\t*NODE_NAME  \"CameraSpace\"\n" to:f
		Format "\t*HELPER_CLASS \"PointHelper\"\n" to:f
		-------------------------------
		t = AnimRange.start
		tm = at time t ( pckObj.object .transform * inverse pckCam.object.transform)   
		p = MapPos t 
		Format "\t*NODE_TM {\n" to:f
		Format "\t\t*NODE_NAME  \"CameraSpace\"\n" to:f
		Format "\t\t*INHERIT_POS\t0\t0\t0\n" to:f
		Format "\t\t*INHERIT_ROT\t0\t0\t0\n" to:f
		Format "\t\t*TM_ROW0\t%\t%\t%\n" tm.row1.x tm.row1.y tm.row1.z to:f
		Format "\t\t*TM_ROW1\t%\t%\t%\n" tm.row2.x tm.row2.y tm.row2.z to:f
		Format "\t\t*TM_ROW2\t%\t%\t%\n" tm.row3.x tm.row3.y tm.row3.z to:f
		Format "\t\t*TM_ROW3\t%\t%\t%\n" p.x p.y p.z to:f --tm.row4.x tm.row4.y tm.row4.z
		Format "\t\t*TM_POS\t%\t%\t%\n" p.x p.y p.z to:f  --tm.row4.x tm.row4.y tm.row4.z
		ang = tm.rotation as angleaxis
		Format "\t\t*TM_ROTAXIS \t%\t%\t%\n" ang.axis.x ang.axis.y ang.axis.z to:f 
		Format "\t\t*TM_ROTANGLE\t%\n" (degToRad(ang.angle)) to:f
		Format "\t\t*TM_SCALE\t%\t%\t%\n" 1.0 1.0 1.0 to:f
		Format "\t\t*TM_SCALEAXIS\t%\t%\t%\n" 0.0	0.0 0.0 to:f
		Format "\t\t*TM_SCALEAXISANG\t%\n" 0.0 to:f

		Format "\t}\n" to:f
		------------------------------------------
		Format "\t*BOUNDINGBOX_MIN\t200.10004\t0.01000\t-0.30499\n" to:f
		Format "\t*BOUNDINGBOX_MAX\t200.12003\t-0.01000\t-0.28499\n" to:f
		------------------------------------------
		Format "\t*TM_ANIMATION {\n" to:f
		Format "\t\t*NODE_NAME \"CameraSpace\"\n" to:f
		Format "\t\t*CONTROL_POS_TRACK {\n" to:f
		for t = AnimRange.start to AnimRange.end do
		(
			p = MapPos t
			format "\t\t\t*CONTROL_POS_SAMPLE\t%\t%\t%\t%\t \n" t.frame p.x p.y p.z to:f
			-- format "\t\t\t*CONTROL_POS_SAMPLE\t%\t%\t%\t%\t \n" t.ticks p.x p.z -p.y to:f
		)
		format "\t\t}\n\t}\n}\n" to:f
	)
	*/
	fn writeXYDfmoTo FileXY FileZ =
	(
		format "DFMO\n" to:FileXY
		format "0.000000 0.000000 0.000000 1.000000 %\n" (1 / aspectRatio) to:FileXY  -- fusions relative transform info ... makes no difference to y scaling issues
		
		format "DFSP\n" to:FileZ
		for t = AnimRange.start to AnimRange.end do
		(
			p = MapPos t
			x = p.x
			y = if divideByAspectRatioForFusion then p.y / AspectRatio else p.y  --- for some reason fusion mulitplies the y by the aspect ratio on import ... no matter what the relative transform info says
			format "% % %\n" p.x y t.frame to:FileXY
			format "% %\n" t.frame p.z to:FileZ
		)
	)
	fn writeXYSplTo FileX FileY FileZ =
	(
		format "DFSP\n" to:FileX
		format "DFSP\n" to:FileY
		format "DFSP\n" to:FileZ
		for t = AnimRange.start to AnimRange.end do
		(
			p = MapPos t	
			x = p.x
			y = if divideByAspectRatioForFusion then p.y / AspectRatio else p.y
			format "% %\n" t.frame x to:FileX
			format "% %\n" t.frame y to:FileY
			format "% %\n" t.frame p.z to:FileZ
		)	
	)
	-------------------------------------------------------------------------------------------------------------------------------------- 
	fn writeThisStringStream theStringStream  ToFileName:Undefined withSuffix:"" setFilenameTypeTo:Undefined =
	(
		if ToFileName != undefined then 
		(
			newFileNameType = if setFilenameTypeTo != undefined then setFilenameTypeTo else ( getFilenameType ToFileName )
			newPathName = ( getFilenamePath ToFileName ) + ( getFilenameFile ToFileName ) + withSuffix + newFileNameType
			f = createFile newPathName
			format "%" (theStringStream as string) to:f
			close f
		)
	)
	on btnExport pressed do
	(
		if checkAndInitalizeOK() do
		(	
			if rbtToFile.state == 1 then   --rbtType Types: #("dfmo","spl")
			(
				-- svTypeText = fType +"(*." + fType + ")|*." + fType
				svTypeText = if rbtType.state == 1 then "dfmo(*.dfmo)|*.dfmo|X and Y spl files (*.spl)|*.spl|" else "X and Y spl files (*.spl)|*.spl|dfmo(*.dfmo)|*.dfmo|"
				fName = getSaveFileName "Save Track" Types:svTypeText
				if fName !=undefined do
				(
					stringStreamZ = StringStream ""
					
					if ( getFilenameType fName ) == ".dfmo" then
					(
						rbtType.state = 1
						stringStreamXY = StringStream ""
						writeXYDfmoTo stringStreamXY stringStreamZ
						writeThisStringStream stringStreamXY ToFileName:fName --withSuffix:"_XY"
					)else
					(
						rbtType.state = 2
						stringStreamX = StringStream ""
						stringStreamY = StringStream ""
						writeXYSplTo stringStreamX stringStreamY stringStreamZ
						writeThisStringStream stringStreamX ToFileName:fName withSuffix:"_X"
						writeThisStringStream stringStreamY ToFileName:fName withSuffix:"_Y"
					)
					if chkExportZ.checked then writeThisStringStream stringStreamZ ToFileName:fName withSuffix:"_Z" setFilenameTypeTo:".spl"
				)
			) else 
			(
				stringStreamZ = StringStream ""
				if rbtType.state == 1  then
				(
					stringStreamXY = StringStream ""
					writeXYDfmoTo stringStreamXY stringStreamZ
					print "----XY-----------------------------------"
					print ( stringStreamXY as string )
				)else
				(
					stringStreamX = StringStream ""
					stringStreamY = StringStream ""
					writeXYSplTo stringStreamX stringStreamY stringStreamZ
					print "----X------------------------------------"
					print ( stringStreamX as string )
					print "----Y------------------------------------"
					print ( stringStreamY as string )
				)
				print "----Z------------------------------------"
				print ( stringStreamZ as string )
			)
		)
	)
)

KenzorsCameraTrackManager = KenzorsRolloutManagerStruct  "Export BMD Fusion Track" 260 #( KenzorsAboutMeRoll,setAspectRatioAndAnimationRange, exportCamRoll)
KenzorsCameraTrackManager.Initalize()

