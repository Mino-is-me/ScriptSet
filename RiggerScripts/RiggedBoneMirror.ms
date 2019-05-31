/*
fn getTRTarget bnSelected =
(
    try 
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
*/ -- throw this Function 

fn makePastedBoneName strNodeName = 
(
    if ( findString strNodeName " R " != undefined ) do 
        local strOppositeNodeName = substituteString strNodeName " R " " L "

    if ( findString strNodeName " L " != undefined ) do 
        local strOppositeName = substituteString strNodeName " L " " R "
    
    return strOppositeNodeName 
)

fn makeMirrorBone lBone = 
(
 local sPoint = lBone.pos
 local ePoint = (preTransLate lBone.transform [(lBone.inode.stretchTM.scale.x *lBone.length),0,0]).pos -- get bone end pos, compensate for stretch
 
 local rBone = boneSys.createBone [-sPoint.x,sPoint.y,sPoint.z]  [-ePoint.x,ePoint.y,ePoint.z] -lBone.dir

 rBone.name = makePastedBoneName lBone.name
 rBone.parent  = lBone.parent 
 rBone.Length = lBone.Length 
)
/*
numCtrl = getTRTarget $ 

print ( numCtrl as string )
*/

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

selectMore rotTargetNode 


