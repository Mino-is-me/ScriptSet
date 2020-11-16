fn toLeftHandedTM t1 = 
(
    t2 = ( matrix3 t1[1] t1[3] t1[2] t1[4] )
    t2[1] = [t2[1].x, t2[1].z, t2[1].y]
    t2[2] = [t2[2].x, t2[2].z, t2[2].y]
    t2[3] = [t2[3].x, t2[3].z, t2[3].y]
    t2[4] = [t2[4].x, t2[4].z, t2[4].y] 

    return t2
)

fn toLeftHandedTM2 t1 = 
(
    local t2 = matrix3 1
    local row1 = t1.row1 
    local row2 = t1.row2 
    local row3 = t1.row3 
    local row4 = t1.row4 

    t2.row1 = [row3.x,row1.z,row3.z]

    t2.row2 = [-row2.y,row2.x,row2.z]

    t2.row3 = [-row1.y, row1.x, row3.y]

    t2.row4 = [-row4.y, row4.x, row4.z]

    return t2
)

fn toLeftHandedTM3 t1 = 
(
    local t2 = matrix3 1
    t2.row1 = t1.row3
    t2.row2 = t1.row1
    t2.row3 = t1.row2 
    t2.row4.x = -t1.row4.y
    t2.row4.y = t1.row4.x
    t2.row4.z = t1.row4.z 

    return t2 
)

fn ue4toMAXTM t1 =
(
       
	local t2= matrix3 1
    t2.row1 = t1.row2
    t2.row2 = t1.row3 
    t2.row3 = t1.row1 
	/*
    t2.row4.x = t1.row4.y
    t2.row4.y = -1 * t1.row4.x
    t2.row4.z = t1.row4.z 
	*/
	t2.row4 = t1.row4
    return t2 
)

fn migrateTM =
(
    $'Bip002'.transform = $'Bip001'.transform
    $'Bip002 Prop1'.transform = $'Bip001 Prop1'.transform
	$'Bip002 Pelvis'.transform = $'Bip001 Pelvis'.transform
	$'Bip002 Spine'.transform = $'Bip001 Spine'.transform 
	
	
    $'Bip002 L Thigh'.transform = $'Bip001 L Thigh'.transform
    $'Bip002 L Calf'.transform = $'Bip001 L Calf'.transform
    $'Bip002 L Foot'.transform = $'Bip001 L Foot'.transform
    $'Bip002 L Toe0'.transform = $'Bip001 L Toe0'.transform
   
    $'Bip002 R Thigh'.transform = $'Bip001 R Thigh'.transform
    $'Bip002 R Calf'.transform = $'Bip001 R Calf'.transform
    $'Bip002 R Foot'.transform = $'Bip001 R Foot'.transform
    $'Bip002 R Toe0'.transform = $'Bip001 R Toe0'.transform

    $'Bip002 Spine1'.transform = $'Bip001 Spine1'.transform
    $'Bip002 Spine2'.transform = $'Bip001 Spine2'.transform

    $'Bip002 Neck'.transform = $'Bip001 Neck'.transform
    $'Bip002 Head'.transform = $'Bip001 Head'.transform

    $'Bip002 L Clavicle'.transform = $'Bip001 L Clavicle'.transform
    $'Bip002 L UpperArm'.transform = $'Bip001 L UpperArm'.transform
    $'Bip002 L Forearm'.transform = $'Bip001 L Forearm'.transform
    $'Bip002 L Hand'.transform = $'Bip001 L Hand'.transform

    $'Bip002 R Clavicle'.transform = $'Bip001 R Clavicle'.transform
    $'Bip002 R UpperArm'.transform = $'Bip001 R UpperArm'.transform
    $'Bip002 R Forearm'.transform = $'Bip001 R Forearm'.transform
    $'Bip002 R Hand'.transform = $'Bip001 R Hand'.transform

    $'Bip002 L Finger0'.transform = $'Bip001 L Finger0'.transform 
    $'Bip002 L Finger01'.transform = $'Bip001 L Finger01'.transform
    $'Bip002 L Finger02'.transform = $'Bip001 L Finger02'.transform
    
    $'Bip002 L Finger1'.transform = $'Bip001 L Finger1'.transform 
    $'Bip002 L Finger11'.transform = $'Bip001 L Finger11'.transform
    $'Bip002 L Finger12'.transform = $'Bip001 L Finger12'.transform

    $'Bip002 L Finger2'.transform = $'Bip001 L Finger2'.transform 
    $'Bip002 L Finger21'.transform = $'Bip001 L Finger21'.transform
    $'Bip002 L Finger22'.transform = $'Bip001 L Finger22'.transform

    $'Bip002 L Finger3'.transform = $'Bip001 L Finger3'.transform 
    $'Bip002 L Finger31'.transform = $'Bip001 L Finger31'.transform
    $'Bip002 L Finger32'.transform = $'Bip001 L Finger32'.transform

    $'Bip002 L Finger4'.transform = $'Bip001 L Finger4'.transform 
    $'Bip002 L Finger41'.transform = $'Bip001 L Finger41'.transform
    $'Bip002 L Finger42'.transform = $'Bip001 L Finger42'.transform

    $'Bip002 R Finger0'.transform = $'Bip001 R Finger0'.transform 
    $'Bip002 R Finger01'.transform = $'Bip001 R Finger01'.transform
    $'Bip002 R Finger02'.transform = $'Bip001 R Finger02'.transform
    
    $'Bip002 R Finger1'.transform = $'Bip001 R Finger1'.transform 
    $'Bip002 R Finger11'.transform = $'Bip001 R Finger11'.transform
    $'Bip002 R Finger12'.transform = $'Bip001 R Finger12'.transform

    $'Bip002 R Finger2'.transform = $'Bip001 R Finger2'.transform 
    $'Bip002 R Finger21'.transform = $'Bip001 R Finger21'.transform
    $'Bip002 R Finger22'.transform = $'Bip001 R Finger22'.transform

    $'Bip002 R Finger3'.transform = $'Bip001 R Finger3'.transform 
    $'Bip002 R Finger31'.transform = $'Bip001 R Finger31'.transform
    $'Bip002 R Finger32'.transform = $'Bip001 R Finger32'.transform

    $'Bip002 R Finger4'.transform = $'Bip001 R Finger4'.transform 
    $'Bip002 R Finger41'.transform = $'Bip001 R Finger41'.transform
    $'Bip002 R Finger42'.transform = $'Bip001 R Finger42'.transform

    

)
Base = "C:\Users\Shiftup\Documents\Seq_Export\Game\Art\Character\PC\CH_P_EVE_01\Animation\BaseBIP.max"
Files = getFiles "C:\Users\Shiftup\Documents\Seq_Export\Game\Art\Character\PC\CH_P_EVE_01\Animation\*.fbx"


for i=1 to 2 do 
(
    local file = Files[i]
	FbxImporterSetParam "Mode" #create 
	importfile file #noPrompt using:FBXIMP 
	--ex = #()
    select $*
    deselect $Bip001*
    deselect $Root
    delete selection
	
	for i in $* do 
	(
		i.rotation.controller = TCB_Rotation()
	)
	numKey = numKeys $Bip001_Pelvis.rotation.controller
	
	AnimRange = AnimationRange 
	
	if numKey > 1 then
	(
		AnimRange.end = numKey - 1
	)
	else 
	(
		AnimRange.end = 1 
	)
	AnimationRange = AnimRange 
    
    bipeds = $Bip001*  as array 
    --rotate $bip001 (EulerAngles 0 0 -90)
    set Animate on 
    for i in Bipeds do 
    (
        local exposeNode = Dummy()
        exposeNode.name = i.name + "_Expose"
		--append ex exposeNode 
    )
	
	for j=AnimationRange.start to AnimationRange.end do 
	(
		
		sliderTime = j
		
		for i in Bipeds do 
		(
			exposeNode = getNodeByName (i.name + "_Expose")
			exposeNode.transform = ue4toMAXTM i.transform 
		)
	)

	/*
    
    for i in Bipeds do 
    (
        local exposeNode = Dummy()
        exposeNode.name = i.name
        exposeNode.transform = ue4toMAXTM i.transform
    )
	*/
    for i in Bipeds do 
    (
        i.name = substituteString i.name "Bip001" "Bip002"
		deleteKeys i.transform.controller #allkeys 
    )
	
	select $*Expose
	ar = selection as array
	deselect $* 
	
	for i in ar do 
	(
		i.name = substituteString i.name "_Expose" ""
	)
	
	delete $Root 
	
	SliderTime = 0 
    for j=AnimationRange.start to AnimationRange.end do 
    (
        sliderTime = j
        migrateTM() 
    )
    
    delete $Bip001*
     
    for i in Bipeds do 
    (
        i.name = substituteString i.name "Bip002" "Bip001"
    )

	for i in $* do 
	(
		i.rotation.controller = TCB_Rotation()
	)
	
	--$Bip001.rotation.controller = Euler_XYZ()
	
	exportFileName = ("C:\Users\Shiftup\Documents\Seq_Export\Game\Art\Character\PC\CH_P_EVE_01\Animation\Editied\\") + (getFileNameFile file) + ".fbx"
	ExportFile exportFileName #noPrompt using:FBXEXP
	
	ResetMaxFile #noPrompt
)

