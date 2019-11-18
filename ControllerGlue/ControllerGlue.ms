
global fullDir = getThisScriptFilename() 
global lib = (getFilenamePath  fullDir ) + "RolloutHandler.ms"
filein lib

global mainFloater = newRolloutFloater "Controller Glue" 505 850
global cnt = 0 
global tempTxt = ""
global multiapply

rollout multiapply "Multi File Apply"
(
	button mlb_selectFiles "+" align:#right 
	multilistbox mlb_appliedFiles "File Ilst:"

	on mlb_selectFiles pressed do 
	(
		mlb_appliedFiles.items = fn_getMultipleFiles multi:true fileFilter:"MAX Files (*.max)|*.max"
	)
)

rollout mainHandler "Create Window" 
(
	editText edt_boneName "Bone Name : "  across:2
	button btn_addBoneController "+" 
	checkBox cbx_isMulti "Apply to Multi File?"
	--button btn_apply "Apply All"
	
	on cbx_isMulti changed val do  
	(
		if val == true then
		(
			createDialog multiapply
		)
		else 
		(
			destroyDialog multiapply
		)
	)
	on btn_addBoneController pressed do 
	(
		cnt = cnt + 1 
		tempTxt = edt_boneName.text 
		addRolloutoFloater tempTxt cnt 
	)
)




addRollout mainHandler mainFloater