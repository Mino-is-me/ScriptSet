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

fn fn_getSkinBoneName obj  =					--skin�� bone �̸��� �迭�� ������
(
	setCommandPanelTaskMode mode:#modify  			-- modfiy pannel ����
	select obj														  			-- object ����
	skinModifier =  Obj.modifiers[#Skin]              			-- skinModifier�� ����ȭ
		
	boneCount = skinOps.GetNumberBones skinModifier	--skin�� ����� Bone ������ �˾Ƴ�
		
	boneNames = for i in 1 to boneCount collect skinOps.GetBoneName skinModifier i 1	--bonName������ ��Ų�� ����� Bone name (string)������ ����
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
		else MessageBox "���õ� ������Ʈ ����."
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
		else MessageBox "���õ� ������Ʈ ����."
	)
)--CreateDialog skinTheif
	
	floater_skinTheif = newRolloutFloater "Skin Theif" 180 50
	addRollout skinTheif floater_skinTheif


