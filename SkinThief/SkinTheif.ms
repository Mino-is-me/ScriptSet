--SkinTheif
--스킨데이터 (스킨관여본 및 스킨데이터 옮길 때 사용)
Global floater_skinTheif

Try
(
	cui.FloatDialogBar floater_skinTheif
	cui.UnRegisterDialogBar floater_skinTheif
	closeRolloutFloater floater_skinTheif
) 
Catch()

function fn_switchPathFlag str_Dir = 
(
	local switchedDir = SubstituteString str_Dir "\\" "/"
	return switchedDir
)

fn fn_getSkinBoneName obj  =					--skin된 bone 이름을 배열로 돌려줌
(
	setCommandPanelTaskMode mode:#modify  			-- modfiy pannel 선택
	select obj														  			-- object 선택
	skinModifier =  Obj.modifiers[#Skin]              			-- skinModifier의 변수화
		
	boneCount = skinOps.GetNumberBones skinModifier	--skin에 적용된 Bone 갯수를 알아냄
		
	boneNames = for i in 1 to boneCount collect skinOps.GetBoneName skinModifier i 1	--bonName변수에 스킨에 적용된 Bone name (string)정보를 대입
	return boneNames
)

Global userMaxPath = fn_switchPathFlag (GetDir #UserMacros + "/")
Global file = (userMaxPath + "SkinDATA.txt")
Global skinfile = (userMaxPath + "SkinDATA.env")

Rollout skinTheif "Skin Theif" 
(
	Button btn_getSkinData "Get Skin" across:2
	Button btn_setSkinData "Set Skin"
	
	on btn_getSkinData pressed do
	(
		if(selection.count > 0) then
		(
			Max Modify Mode
			skinOps.SaveEnvelope $.modifiers[#Skin] skinfile
			fileSTM = CreateFile file
			for obj in selection do
			(
				local boneNames = fn_getSkinBoneName obj
				for i=1 to boneNames.count do
				(
					format "%" ((boneNames[i] as string) + "\n") to:fileSTM
				)
			)
			close fileSTM
		)
		else MessageBox "선택된 오브젝트 없음."
	)
	
	on btn_setSkinData pressed do
	(
		if(selection.count >0) then
		(
			fileSTM = openFile file
			
			while not eof fileSTM do
			(
				local txt = readLine fileSTM
				local nodeName = getNodeByName txt
				skinOps.addBone $.modifiers[#Skin] nodeName 1
			)
			skinOps.loadEnvelope $.modifiers[#Skin] skinfile
			close fileSTM 
			DeleteFile file

		)
		else MessageBox "선택된 오브젝트 없음."
	)
)--CreateDialog skinTheif
	

	floater_skinTheif = newRolloutFloater "Skin Theif" 180 50
	addRollout skinTheif floater_skinTheif
	cui.RegisterDialogBar floater_skinTheif
	cui.DockDialogBar floater_skinTheif #cui_dock_bottom


