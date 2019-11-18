(
global g_TimeConfigRollout

global G_InitTimeConfig



--======================================================================================
-- Callbacks
--======================================================================================	
--------------------------------------------------------------------
-- G_InitSeqManager
--------------------------------------------------------------------
fn G_InitTimeConfig =
(
	rot = g_TimeConfigRollout
	
	if rot.spn_StartTime.value != animationRange.start then
		rot.spn_StartTime.value = animationRange.start
	
	if rot.spn_EndTime.value != animationRange.end then
		rot.spn_EndTime.value = animationRange.end
)



--======================================================================================
-- DestroyDialog
--======================================================================================
try(cui.UnRegisterDialogBar g_TimeConfigRollout) catch()
try(destroyDialog g_TimeConfigRollout) catch()



--==========================================================================================================

-- SequenceManager Rollout

--==========================================================================================================
rollout g_TimeConfigRollout "Time Config"
(
	spinner spn_StartTime "Start Time :" type:#integer range:[-66666,66666,0]width:100 align:#left across:3
	spinner spn_EndTime "End Time :" type:#integer range:[-66666,66666,100] width:100 align:#left offset:[20,0]
	--label lbl_Maker "Hwanggoon" offset:[20,0]
	
	
	
	--======================================================================================
	-- fn
	--======================================================================================
	--------------------------------------------------------------------
	-- ConvertDialogBar
	--------------------------------------------------------------------
	fn ConvertDialogBar rot dockFlag: =
	(
		cui.registerDialogBar rot
		
		if IsKindOf dockFlag Name then
			cui.dockDialogBar rot dockFlag
	)
	
	
	
	--======================================================================================
	-- UI Control
	--======================================================================================
	----------------------------------------------------------------------------------------
	-- spn_StartTime
	----------------------------------------------------------------------------------------
	on spn_StartTime changed state do
	(
		local endF = animationRange.end
		if state >= endF then
			endF = state + 1
		
		animationRange = interval state endF
	)
	
	
	----------------------------------------------------------------------------------------
	-- spn_EndTime
	----------------------------------------------------------------------------------------
	on spn_EndTime changed state do
	(
		local startF = animationRange.start
		if state <= startF then
			startF = state - 1
		
		animationRange = interval startF state
	)
	
	
	----------------------------------------------------------------------------------------
	-- open
	----------------------------------------------------------------------------------------
	on g_TimeConfigRollout open do
	(
		G_InitTimeConfig()
		
		ConvertDialogBar g_TimeConfigRollout dockFlag:#cui_dock_bottom
		
		callbacks.addScript #animationRangeChange "G_InitTimeConfig()" id:#InitTimeConfig
	)
	
	
	----------------------------------------------------------------------------------------
	-- close
	----------------------------------------------------------------------------------------
	on g_TimeConfigRollout close do
	(
		callbacks.removeScripts #animationRangeChange id:#InitTimeConfig
	)
)

createDialog g_TimeConfigRollout width:300 height:25
)