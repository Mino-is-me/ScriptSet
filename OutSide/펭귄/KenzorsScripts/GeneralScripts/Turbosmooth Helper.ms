/*------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Turbosmooth and LOD Helper GUI
-- By ken turner
-- www.designimage.co.uk

-- 09/12/2017	v1.10 3dsmax 2017 rollout bug fix
*/------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
if TurboSmoothAndLODHelperManager != undefined then TurboSmoothAndLODHelperManager.closeup()
TurboSmoothAndLODHelperManager = undefined

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------------------------------- File In ----------------------
fileIn ( "$userscripts/KenzorsScripts/Common/kenzorsRolloutManager.ms" )
rollout GeneralOptionsRoll "General Options"
(
	-------------------------------------------------------------------- required for kenzorsRolloutManager
	Local isRolledOut = true
	fn rolledUpEventFn = 
	( --- required undefined varible for kenzorsRolloutManager
	)
	on GeneralOptionsRoll rolledUp val do ( isRolledOut = val ; rolledUpEventFn()) 
	-------------------------------------------------------------------------------------------------------------
	label lbl1 "Using the checkboxes"
	label lbl2 "All modifiers in the scene"
	label lbl3 "Can be turned ON or OFF"
	
	checkbox chkIgnoreBelowPointCache "Ignore mod below Point Cache"  checked:true
	checkbox chkSelectedOnly  "Only Effect selected Objects"  checked:false
	checkBox chkLimitIterations "Limit Iterations" checked:false
		
	fn isTheModAbovePointCache theObj theModClass: = -- ie pointCacheBelow turbosmooth
	(
		isOk = True
		for theMod in theObj.modifiers while ( (classOf theMod ) != theModClass ) do
		(
			if ( (classOf theMod ) == Point_CacheSpacewarpModifier ) then isOk = false
		)
		isOk
	)
	fn theObjects =
	(
		theObjectList = if chkSelectedOnly.checked then (selection as array ) else ( geometry as array )
		if chkIgnoreBelowPointCache.checked then
		(
			theObjectList = for theObj in theObjectList where ( ( isProperty theObj #Turbosmooth ) and ( isTheModAbovePointCache theObj ) ) collect theObj
		)
		theObjectList
	)	
	
)

rollout TurboSmoothAndLODHelperRoll "Turbosmooth and LOD Helper"
(
	-------------------------------------------------------------------- required for kenzorsRolloutManager
	Local isRolledOut = true
	fn rolledUpEventFn = 
	( --- required undefined varible for kenzorsRolloutManager
	)
	on TurboSmoothAndLODHelperRoll rolledUp val do ( isRolledOut = val ; rolledUpEventFn()) 
	-------------------------------------------------------------------------------------------------------------
	label lbl1 "Using the checkboxes"
	label lbl2 "All modifiers in the scene"
	label lbl3 "Can be turned ON or OFF"
	
	checkbox chkIgnoreBelowPointCache "Ignore mod below Point Cache"  checked:true
	checkbox chkSelectedOnly  "Only Effect selected Objects"  checked:false
	checkBox chkLimitIterations "Limit Iterations" checked:false

	Group "Turbosmooth"
	(
		checkbox ChkTurboOn "Enabled" checked:true
		checkbox ChkIsolineDisplay "Isoline Display" checked:true
		Spinner SpItrtns "Iterations" Range:[0,10,0] fieldwidth:50  Type:#integer 
		
		checkbox ChkRenderOn "" checked:False across:2
		Spinner SpRenderItrtns "Render" Range:[0,10,0] fieldwidth:50 Type:#integer
		
		button btnSelect "select TurboSmooth objects"
	)
	
	Group "shell"
	(
		checkbox ChkShellOn "Enabled" checked:true
	)
	Group "Symmetry"
	(
		checkbox ChkSymmetryOn "Enabled" checked:true
	)
	fn isTurboSmoothAbovePointCache theObj = -- ie pointCacheBelow turbosmooth
	(
		isOk = True
		for theMod in theObj.modifiers while ( (classOf theMod ) != TurboSmooth ) do
		(
			if ( (classOf theMod ) == Point_CacheSpacewarpModifier ) then isOk = false
		)
		isOk
	)
	fn theObjects =
	(
		theObjectList = if chkSelectedOnly.checked then (selection as array ) else ( geometry as array )
		if chkIgnoreBelowPointCache.checked then
		(
			theObjectList = for theObj in theObjectList where ( ( isProperty theObj #Turbosmooth ) and ( isTurboSmoothAbovePointCache theObj ) ) collect theObj
		)
		theObjectList
	)	
	
	fn ObjectsWithTurbosmooth  =
	(
		
		thecollection = for obj in ( theObjects() ) where isProperty obj #Turbosmooth collect obj
		print thecollection.count
		thecollection
	)
	on btnSelect pressed do select ( ObjectsWithTurbosmooth() ) 

	--- turbosmooth
	on ChkIsolineDisplay changed arg do
	(
		for obj in theObjects()  where isProperty obj #Turbosmooth do obj.Turbosmooth.isolineDisplay = arg
	)
	on SpItrtns changed val do
	(
		for obj in theObjects() where isProperty obj #Turbosmooth do
		(
			 obj.Turbosmooth.iterations = if ( chkLimitIterations.checked and val > obj.Turbosmooth.renderIterations ) then obj.Turbosmooth.renderIterations else val
		)
	)
	on SpRenderItrtns changed val do
	(
		for obj in theObjects()  where isProperty obj #Turbosmooth do obj.Turbosmooth.renderIterations  = val
	)
	on ChkTurboOn changed arg do
	(
		for obj in theObjects()  where isProperty obj #Turbosmooth do obj.Turbosmooth.enabled = arg
	)
	on ChkRenderOn changed arg do
	(
		for obj in theObjects()  where isProperty obj #Turbosmooth do obj.Turbosmooth.useRenderIterations = arg
	)
	-- shell
	on ChkShellOn changed arg do
	(
		for obj in theObjects()  where isProperty obj #Shell do obj.Shell.enabled = arg
	)
	on ChkSymmetryOn changed arg do
	(
		for obj in theObjects()  where isProperty obj #Symmetry do obj.Symmetry.enabled = arg
	)
)
rollout TurboSmoothproHelperRoll "Turbosmoothpro"
(
	-------------------------------------------------------------------- required for kenzorsRolloutManager
	Local isRolledOut = true

	fn rolledUpEventFn = 
	( --- required undefined varible for kenzorsRolloutManager
	)
	on TurboSmoothproHelperRoll rolledUp val do ( isRolledOut = val ; rolledUpEventFn()) 
	-------------------------------------------------------------------------------------------------------------
	checkbox chkSelectedOnly  "only selected"  checked:false
	Group "TurbosmoothPro"
	(
		checkbox ChkTurboOn "Enabled" checked:true
		checkbox ChkIsolineDisplay "Isoline Display" checked:true
		Spinner SpItrtns "Iterations" Range:[0,10,0] fieldwidth:50  Type:#integer 
		
		checkbox ChkRenderOn "" checked:False across:2
		Spinner SpRenderItrtns "Render" Range:[0,10,0] fieldwidth:50  Type:#integer 
		
	)
	button btnSelect "select TurboSmoothpro objects"
	
	fn theObjects =
	(
		if chkSelectedOnly.checked then (selection as array ) else geometry
	)
	fn turbosmoothObjects =
	(
		for obj in theObjects()  where isProperty obj #Turbosmoothpro collect obj
	)
	on btnSelect pressed do select ( turbosmoothObjects() ) 
	--- turbo smooth pro
	on ChkIsolineDisplay changed isTrue do
	(
		for obj in ( turbosmoothObjects() ) do obj.Turbosmoothpro.isolineDisplay = if isTrue then 1 else 0
	)
		
	on SpItrtns changed val do
	(
		for obj in theObjects() where isProperty obj #Turbosmoothpro do obj.Turbosmoothpro.iterations = val
	)
	on SpRenderItrtns changed val do
	(
		for obj in theObjects()  where isProperty obj #Turbosmoothpro do obj.Turbosmoothpro.renderIterations  = val
	)
	on ChkTurboOn changed arg do
	(
		for obj in theObjects()  where isProperty obj #Turbosmoothpro do obj.Turbosmoothpro.enabled = arg
	)
	on ChkRenderOn changed arg do
	(
		for obj in theObjects()  where isProperty obj #Turbosmoothpro do obj.Turbosmoothpro.useRenderIterations = arg
	)
	
)
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------------- END OF: CloneAndFixCameraRoll

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- 
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

TurboSmoothAndLODHelperManager = KenzorsRolloutManagerStruct  "turbosmooth helper" 200 #( KenzorsAboutMeRoll, GeneralOptionsRoll, TurboSmoothAndLODHelperRoll, TurboSmoothproHelperRoll )
TurboSmoothAndLODHelperManager.Initalize()