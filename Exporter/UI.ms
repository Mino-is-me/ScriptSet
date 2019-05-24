

Try(DestroyDialog Exporter) Catch()

rollout Exporter "Brand New Exporter" width:505 height:723
(
	button 'btn1' "Select Files" pos:[19,21] width:158 height:90 align:#left
	listBox 'lbx1' "File List" pos:[28,139] width:433 height:16 align:#left
	button 'btn2' "Select Export Path" pos:[24,394] width:93 height:34 align:#left
	editText 'edt1' "" pos:[120,393] width:343 height:35 align:#left
	dropDownList 'ddl1' "Species" pos:[20,461] width:448 height:41 items:#("PC(EVE)", "MOB(NA)", "Weapon(WP)") align:#left
	dropDownList 'ddl2' "Export Option" pos:[20,500] width:448 height:41 items:#("Bones + Mesh", "Bones Only", "Mesh Only", "All") align:#left
	button 'btn3' "Export" pos:[305,20] width:158 height:90 align:#left
	groupBox 'grp1' "Import / Export" pos:[9,5] width:467 height:118 align:#left
	progressBar 'pb1' "Exporting..." pos:[22,621] width:440 height:55 align:#left
	dropDownList 'ddl4' "Facial" pos:[366,543] width:101 height:41 items:#("WithOut Facial", "Facial Only") align:#left
	groupBox 'grp2' "" pos:[12,126] width:468 height:314 align:#left
	groupBox 'grp3' "" pos:[13,453] width:468 height:138 align:#left
	groupBox 'grp4' "Progress" pos:[13,603] width:468 height:90 align:#left
)CreateDialog Exporter