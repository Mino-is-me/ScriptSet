rollout unnamedRollout "Untitled" width:680 height:301
(
	groupBox 'grp_save' "Save Animation" pos:[9,10] width:320 height:225 align:#left
	groupBox 'grp_load' "Load Animation" pos:[343,10] width:320 height:224 align:#left
	button 'btn_save' "Get *.max for save" pos:[20,40] width:296 height:82 align:#left
	button 'btn2' "Get *.xml for Load" pos:[355,40] width:296 height:82 align:#left
	editText 'edt1' "" pos:[26,172] width:288 height:21 align:#left
	label 'lbl1' "Save Directory" pos:[30,155] width:128 height:15 align:#left
	button 'btn_getSaveDir' "export Path" pos:[227,130] width:86 height:33 align:#left
	editText 'edt2' "" pos:[360,170] width:288 height:21 align:#left
	label 'lbl2' "Save Directory" pos:[364,153] width:128 height:15 align:#left
	button 'btn4' "export Path" pos:[564,129] width:86 height:33 align:#left
	groupBox 'grp_setting' "Settings" pos:[11,241] width:653 height:49 align:#left
	button 'btn_runSave' "Run" pos:[237,200] width:75 height:30 align:#left
	button 'btn_runLoad' "Run" pos:[573,198] width:75 height:30 align:#left
)

createDialog unnamedRollout