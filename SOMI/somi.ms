	/*
	작성자 : 장민호
	스크립트 명세
	'''
		통합 작업 도움툴, 씬 매니징 너무 귀찮아서 만듬,
		소녀전선 수오미와는 관계 없고(중요), Supporting&Observing&Managing Interface의 약칭임.
		
		AI나 스크립트 문자열 받아서 처리할 수 있도록 개발할수도있음 (아마)
	'''
	*/
--	getThisScriptFilename()
	--Ver : Beta
include "\\\\10.220.70.12\\eve\\ART_Backup\\Script\\Library\\stella.ms"
(	
	Global Flt_support
	Global Flt_observe
	Global Flt_interface
	Global Flt_interface
	Global UnitSize = units.systemScale
	--Floater들을 전부 Global변수로 처리해서 콜백-ReDraw에 사용
	Global fn_realodFloater
	fn fn_realodFloater = 
	(
		Try(macros.run "Minomi" "Somi") Catch()
	)
	Try
	(
		cui.FloatDialogBar Flt_support
		cui.FloatDialogBar Flt_observe
		cui.FloatDialogBar Flt_interface
		cui.FloatDialogBar Flt_interface
		
		cui.UnRegisterDialogBar Flt_support
		cui.UnRegisterDialogBar Flt_observe
		cui.UnRegisterDialogBar Flt_interface
		cui.UnRegisterDialogBar Flt_interface
		
		closeRolloutFloater Flt_support
		closeRolloutFloater Flt_observe
		closeRolloutFloater Flt_interface
		closeRolloutFloater Flt_interface
	)Catch()

	
	fn fn_getSkinBoneName obj  =					--skin된 bone 이름을 배열로 돌려줌
	(
		setCommandPanelTaskMode mode:#modify  			-- modfiy pannel 선택
		select obj														  			-- object 선택
		skinModifier =  Obj.modifiers[#Skin]              			-- skinModifier의 변수화
			
		boneCount = skinOps.GetNumberBones skinModifier	--skin에 적용된 Bone 갯수를 알아냄
			
		boneNames = for i in 1 to boneCount collect skinOps.GetBoneName skinModifier i 1			--bonName변수에 스킨에 적용된 Bone name (string)정보를 대입
		skinBones = for i in boneNames collect getNodeByName i
		return skinBones
	)
	
	Rollout rlt_CatHide "Support"
	(

		CheckButton ckb_bone "Bones" across:4 HighLightColor:Red
		CheckButton ckb_Helper "Helpers" HighLightColor:Red
		CheckButton ckb_Mesh "Meshes" HighLightColor:Red
		CheckButton ckb_Shapes "Shape" HighLightColor:Red
		on rlt_CatHide Open do
		(
			if HideByCategory.Bones == true do ckb_bone.state = true
			if HideByCategory.Helpers == true do ckb_Helper.state = true
			if HideByCategory.Geometry == true do ckb_Mesh.state = true		
		)
		on ckb_bone changed val do
		(
			if val == true then HideByCategory.Bones = true
			else if val == false do HideByCategory.Bones = false
		)
		on ckb_Helper changed val do
		(
			if val == true then HideByCategory.Helpers = true
			else if val == false do HideByCategory.Helpers = false
		)
		on ckb_Mesh changed val do
		(
			if val == true then HideByCategory.Geometry = true
			else if val == false do HideByCategory.Geometry = false
		)
		on ckb_Shapes changed val do
		(
			if val == true then HideByCategory.Shapes = true
			else if val == false do HideByCategory.Shapes = false
		)

	)

	Rollout rlt_Orga "Organize"
	(
		Button btn_world "world" across:3
		Button btn_Local "Local"
		Button btn_Parent "Parent"

		on btn_world pressed do
		(
			toolMode.coordsys #world
		)
		on btn_local pressed do
		(
			toolMode.coordsys #local
		)
		on btn_Parent pressed do 
		(
			toolMode.coordsys #parent	
		)
	)
		Rollout rlt_Info "Information"
		(
			
			label xx "" across:3
			Spinner spi_Unit "unit" range:[1,1000,UnitSize] type:#integer scale:1 fieldWidth:20 			
			Button btn_Unit "?" 
			on rlt_Info Open do 
			(
				spi_Unit.Value = UnitSize
			)
			on spi_Unit changed val do
			(
				units.systemScale = val
				print ("UnitScale = " + val as string)
			)
			on btn_Unit Pressed do
			(
				spi_Unit.value = units.systemScale
				print ("UnitScale = " + val as string)
			--edt_filePath.text = MaxFilePath
			)
		)

	-- 전반적으로 뜯어고치기 --
		
	Rollout rlt_manage "Manage"
	(
		Button btn_resetScale "ResetScale" across:4
		Button btn_resetXForm "ResetXForm"
		Button btn_resetGizmo "ResetGizmo"
		DropDownList ddl_Axis "" items:#("X","Y","Z")

		on btn_resetScale pressed do
		(
			ResetScale $
		)
		on btn_resetXForm pressed do
		(
			ResetXForm $
		)
		on btn_resetGizmo pressed do
		(
			if ddl_Axis.selection == 1 then
			(
				$.pivot.x = 0
			)
			else if ddl_Axis.Selection == 2 then
			(
				$.pivot.y = 0
			)
			else if ddl_Axis.Selection == 3 then
			(
				$.pivot.z = 0
			)
		)
	)
	-- 전반적으로 뜯어고치기 --	

	Flt_support = newRolloutFloater "Support" 250 50
	addRollout rlt_CatHide Flt_support
	cui.RegisterDialogBar Flt_support
	cui.DockDialogBar Flt_support #cui_dock_Bottom
	
	Flt_observe = newRolloutFloater "Organize" 200 50
	addRollout rlt_Orga Flt_observe	
	cui.RegisterDialogBar Flt_observe
	cui.DockDialogBar Flt_observe #cui_dock_Bottom

	Flt_interface = newRolloutFloater "Manage" 350 50
	addRollout rlt_manage Flt_interface	
	cui.RegisterDialogBar Flt_interface
	cui.DockDialogBar Flt_interface #cui_dock_Bottom
	
	Flt_interface = newRolloutFloater "information" 100 50
	addRollout rlt_Info Flt_interface	
	cui.RegisterDialogBar Flt_interface
	cui.DockDialogBar Flt_interface #cui_dock_Bottom
	
--	fileIn "C:\Users\minomi\Desktop\Script_개발중\SkinTheif.ms"
--	macros.run "BlessConsol" "LWorkFlow"

	callBacks.addScript #filePostOpenProcess "fn_realodFloater()"
)
