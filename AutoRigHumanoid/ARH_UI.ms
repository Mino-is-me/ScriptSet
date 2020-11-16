rollout ARH_UI "Auto Rig Humanoid" width:440 height:800
(
	checkButton 'chk_head' "Head && Neck" pos:[152,28] width:118 height:135 align:#left checked:true
	Button 'make' "Make Rig" pos:[300,28] width:100 height:70 align:#left
	checkButton 'ckb3' "Left Arm" pos:[75,184] width:53 height:209 align:#left
	checkButton 'ckb4' "Right Arm" pos:[291,184] width:57 height:205 align:#left
	checkButton 'ckb5' "Spine" pos:[169,176] width:81 height:255 align:#left checked:true
	checkButton 'ckb6' "Left Leg" pos:[110,430] width:50 height:248 align:#left
	checkButton 'ckb7' "Right Leg" pos:[260,430] width:50 height:248 align:#left
	checkButton 'ckb8' "Left Foot" pos:[41,689] width:116 height:60 align:#left
	checkButton 'ckb9' "Right Foot" pos:[260,688] width:116 height:60 align:#left
	label 'lbl1' "Auto Rig Humanoid @ Script By Minomi" pos:[112,758] width:239 height:34 align:#left



	on make pressed do 
	(
		format "Make AutoRig... \n"
	)
)CreateDialog ARH_UI