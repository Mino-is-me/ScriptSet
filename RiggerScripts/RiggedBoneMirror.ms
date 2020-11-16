
/*fn getTRTarget bnSelected =
(
    --try execute "\\\\10.220.70.12\\eve\\ART_Backup\\Script\\Exporter\\TheExporter.ms" 
        local posCtrl = bnSelected.pos.controller.getNumTargets()
    catch 

    try
        local rotCtrl = bnSelected.rotation.controller.getNumTargets()
    catch

    try
        local scaCtrl = bnSelected.scale.controller.getNumTargets() 
    Catch 

    local arCtrl = #()
	
    if posCtrl != undefined do 
        append posCtrl arCtrl
    
    if rotCtrl != undefined do 
        append rotCtrl arCtrl 

    if scaCtrl != undefined do 
        append scaCtrl arCtrl 
    
    return arCtrl 
)
 -- throw this Function 
*/
fn makePastedBoneName strNodeName = 
(
    if ( findString strNodeName " R " != undefined ) then 
        local strOppositeNodeName = substituteString strNodeName " R " " L "

    else if ( findString strNodeName " L " != undefined ) then 
        local strOppositeNodeName = substituteString strNodeName " L " " R "

    else 
		local strOppositeNodeName = strNodeName
    return strOppositeNodeName 
)

fn makeMirrorBone lBone = 
(
    local sPoint = lBone.pos
    local ePoint = (preTransLate lBone.transform [(lBone.inode.stretchTM.scale.x *lBone.length),0,0]).pos -- get bone end pos, compensate for stretch

    local rBone = boneSys.createBone [-sPoint.x,sPoint.y,sPoint.z]  [-ePoint.x,ePoint.y,ePoint.z] -lBone.dir

    rBone.name = makePastedBoneName lBone.name
    --rBone.parent  = lBone.parent 
    rBone.Length = lBone.Length 

    arProperties = getPropNames lBone 

    for i in arProperties do
    (
        propertiesToLoop = execute ( "$" + "'" + lBone.name + "'" + "." + (i as string) )
        setProperty rBone i propertiesToLoop
    )
)

fn makeMirrorHelper lHelper =
(
    if classof lHelper == ExposeTm then
    (
        local rHelper = ExposeTM()
    )
    else if classof lHelper == Point then 
    (
        local rHelper = Point() 
    )
    else if classof lHelper == dummy then 
    (
        local rHelper = dummy()
    )

    rHelper.transform = lHelper.transform *  matrix3 [-1,0,0] [0,1,0] [0,0,-1] [0,0,0]

    rHelper.pos = lHelper.pos
    
    rHelper.pos.x = lHelper.pos.x * -1 

    rHelper.name = makePastedBoneName lHelper.name

    arProperties = getPropNames lHelper 
    
    --except ExposeTM
    if ( classof lHelper ) != ExposeTm do 
    (
        for i in arProperties do
        (
            propertiesToLoop = execute ( "$" + "'" + lHelper.name + "'" + "." + (i as string) )
            setProperty rHelper i propertiesToLoop
        )
    )
)

fn oppositeParentFinder childNode = 
(
    local strOppoisteChildName = makePastedBoneName childNode.name 
    local nOppositeChildNode = getNodeByName strOppoisteChildName
    local nOppositeParentNode = nOppositeChildNode.parent 
    local parentNodeName = makePastedBoneName nOppositeParentNode.name
    local parentNode = getNodeByName parentNodeName 

    childNode.parent =  parentNode 

)


fn setExposeNode ETMNode = 
(
	local strOppositeETM = makePastedBoneName ETMNode.name 
	local nOppositeETM = getNodebyName strOppositeETM
    ETMNode.ExposeNode =  getNodeByName ( makePastedBoneName (nOppositeETM.ExposeNode.name))
    ETMNode.localReferenceNode = getNodeByName ( makePastedBoneName (nOppositeETM.ExposeNode.name) )
    ETMNode.useParent = false 
)

fn getFloatWireNodes nBone = 
(
    deselect $* 
    local XposController = nBone.pos.controller.x_position.controller
    if ( classof XposController ) == Float_Wire do 
    (
        selectMore nBone 
    )
    local YposController = nBone.pos.controller.Y_position.controller
    if ( classof YposController ) == Float_Wire do 
    (
        selectMore nBone 
    )
    local ZposController = nBone.pos.controller.Z_Position.controller
    if ( classof ZposController ) == Float_Wire do 
    (
        selectMore nBone 
    )

    local XRotController = nBone.rotation.controller.X_Rotation.controller
    if ( classof XRotController == Float_Wire ) do 
    (
        selectMore nBone 
    )
    local YRotController = nBone.rotation.controller.Y_Rotation.controller
    if ( classof YRotController == Float_Wire ) do 
    (
        selectMore nBone 
    )
    local ZRotController = nBone.rotation.controller.Z_Rotation.controller
    if ( classof ZRotController == Float_Wire ) do 
        (
            selectMore nBone 
        )
)

/*
strPosCtrlName = $.pos.controller as string 
strRotCtrlName = $.rotation.controller as string
strSclCtrlName = $.scale.controller as string 

iPosTargetCnt = 0
iRotTargetCnt = 0
iSclTargetCnt = 0

arCtrlNames = #(strPosCtrlName, strRotCtrlName, strSclCtrlName)


for i=1 to 3 do
    if (findstring arCtrlNames[i] "Constraint") != undefined then
        case i of 
        (
            1 : iPosTargetCnt = $.pos.controller.getNumTargets()
            2 : iRotTargetCnt = $.rotation.controller.getNumTargets()
            3 : iSclTargetCnt = $.scale.controller.getNumTargets()
        )




if iPosTargetCnt != 0 then 
    posTargetNode = $.position.controller.getNode iPosTargetCnt 

if iRotTargetCnt != 0 then 
    rotTargetNode = $.rotation.controller.getNode iRotTargetCnt 

if iSclTargetCnt != 0 then 
    sclTargetNode = $.scale.controller.getNode isclTargetCnt
*/

for i in selection do 
(
    if (superclassof i == GeometryClass ) then 
    (
        makeMirrorBone i
    )
    else if ( superclassof i == Helper ) then 
    (
        makeMirrorHelper i 
        --oppositeParentFinder i 
    )
)

/*
ar_Nodes = selection as array 
for i in ar_Nodes do 
(
    getFloatWireNodes i  
)
*/
