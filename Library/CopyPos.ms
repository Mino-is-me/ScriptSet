global XValue
global YValue
global ZValue
global isMirrorState = false

fn getPos =
(
	XValue = $.transform.pos.x
	YValue = $.transform.pos.y
	ZValue = $.transform.pos.z	
	--return XVal,YVal,ZVal
)

fn setPos MirrorState = 
(
	if MirrorState == true then
	(
		$.pos.x = (-1 * XValue) as float
		$.pos.y = YValue as float 
		$.pos.z = ZValue as float 
		print "TT"
	)
	else  if MirrorState == false do 
	(		
		$.pos.x = XValue as float 
		$.pos.y = YValue as float 
		$.pos.z = ZValue as float 
		print "¤Ç¤Ç"
	)
)

Try(DestroyDialog BoneTransCopy) Catch()
Rollout BoneTransCopy "BonePosCopy"
(
	--Button btn_CopyPos "Copy Position Value" align:#Left
	editText Pos_X "X : "
	editText Pos_Y "Y : "
	editText Pos_Z "Z : "
	label lb_1""
	checkBox chk_isMirror "Paste Mirror Value" align:#Left
	Button btn_CopyPos "Copy Position Value" align:#Left
	Button btn_PastePos "Paste Position Value"align:#Left
	
	on BoneTransCopy Open do
	(
		Pos_X.text = XValue as string
		Pos_Y.text = YValue as string
		Pos_Z.text = ZValue as string
	)
	
	on chk_isMirror changed state do
	(
		if state == true then		
		(
			isMirrorState = true
		)
		else 
		(
			isMirrorState = false
		)
	)
	
	on btn_CopyPos pressed do
	(
		getPos()
		Pos_X.text = XValue as string
		Pos_Y.text = YValue as string
		Pos_Z.text = ZValue as string
	)
	
	on btn_PastePos pressed do
	(
		setPos isMirrorState
	)
)
CreateDialog BoneTransCopy
