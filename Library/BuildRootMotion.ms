-- Function : BuildRootMotion
-------------------------------------------------------------------------------
   
function BuildRootMotion removeX removeY removeZ bipRootBoneName bipBottomBoneName =
(
    ----------------------------------------------------------------------------
    -- get biped root
    ----------------------------------------------------------------------------
   
    local bipedRoot = getNodeByName bipRootBoneName
   
    if bipedRoot == undefined do
    (
        messagebox ( "Biped 루트가 존재하지 않거나 이름이 틀렸습니다" )
        return false
    )
      
    ----------------------------------------------------------------------------
    -- check if root bone exists
    ----------------------------------------------------------------------------
      
    local bipedBottom = getNodeByName bipBottomBoneName
      
    if bipedBottom == undefined do
    (
        messagebox( "Biped 바닥 본의 이름이 틀리므로 무시됩니다" )
    )
      
    ----------------------------------------------------------------------------
    -- check if root bone exists
    ----------------------------------------------------------------------------
   
    local rootBone = getNodeByName "Root"
   
    if rootBone != undefined do
    (
        messagebox ( "Root 본이 이미 존재합니다" )
        return false
    )
   
    ----------------------------------------------------------------------------
    -- create rootBone
    ----------------------------------------------------------------------------
   
    local rootBone = BoneSys.createBone [ 0, 0, 0 ] [ 20, 0, 0 ] [ 0, 0, 1 ]
   
    rootBone.name = "Root"
   
    clearSelection()
   
    select rootBone
   
    ----------------------------------------------------------------------------
    -- create rootBone position controller
    ----------------------------------------------------------------------------
   
    rootBone.position.controller = Position_XYZ()
   
    for t = animationRange.start to animationRange.end do
    (
        addNewKey rootBone.position.controller t
    )
   
    ----------------------------------------------------------------------------
    -- create position constraint controller for root
    ----------------------------------------------------------------------------
   
    local tempRootController = Position_Constraint()
   
    tempRootController.constraints.appendTarget bipedRoot 1.0
      
    ----------------------------------------------------------------------------
    -- create position constraint controller for bottom
    ----------------------------------------------------------------------------
      
    local tempBottomController = Position_Constraint()
      
    if bipedBottom != undefined do
    (
        tempBottomController.constraints.appendTarget bipedBottom 1.0
    )
       
    ----------------------------------------------------------------------------
    -- fill rootBone position controller
    ----------------------------------------------------------------------------
   
    animate on
    (
        for t = animationRange.start to animationRange.end do
        (
            at time t
            (
                if true == removeX then
                    rootBone.position.controller.value.x = 0.0
                else
                    rootBone.position.controller.value.x = tempRootController.value.x
                   
                if true == removeY then
                    rootBone.position.controller.value.y = 0.0
                else
                    rootBone.position.controller.value.y = tempRootController.value.y
                   
                if true == removeZ then
                (
                    rootBone.position.controller.value.z = 0.0
                )
                else
                (
                    local zValue = 0.0
                      
                    if bipedBottom != undefined then
                        zValue = tempBottomController.value.z
                    else
                        zValue = tempRootController.value.z
                      
                    rootBone.position.controller.value.z = zValue
                )
            )
        )
    )
       
    ----------------------------------------------------------------------------
    -- create biped layer
    ----------------------------------------------------------------------------
       
    rootMotionLayerId = biped.numLayers bipedRoot.controller + 1
       
    biped.createLayer bipedRoot.controller rootMotionLayerId "RootMotionLayer"
       
    biped.setCurrentLayer bipedRoot.controller rootMotionLayerId
       
    clearSelection()
       
    select bipedRoot
       
    horzController = bipedRoot.controller.horizontal.controller
       
    for t = animationRange.start to animationRange.end do
    (
        biped.addNewKey horzController t
    )
       
    animate on
    (
        for t = animationRange.start to animationRange.end do
        (  
            at time t
            (              
                newPos = horzController.value[ 4 ]
                   
                if false == removeX do
                    newPos.x = 0.0
                   
                if false == removeY do
                    newPos.y = 0.0
                   
                if false == removeZ do
                (
                    if bipedBottom != undefined then
                        newPos.z = newPos.z - tempBottomController.value.z
                    else
                        newPos.z = 0.0
                )
                   
                biped.setTransform bipedRoot #pos newPos false
            )
        )
    )
       
    ----------------------------------------------------------------------------
    -- make rootBone as root
    ----------------------------------------------------------------------------
       
    bipedRoot.parent = rootBone
       
    return true
)
   
-------------------------------------------------------------------------------
-- UI
-------------------------------------------------------------------------------
   
rollout RootMotionUI "루트모션 본 생성"
(
    checkbox checkRemoveX "Remove X" checked:true
    checkbox checkRemoveY "Remove Y"
    checkbox checkRemoveZ "Remove Z" checked:true
      
    edittext bipedRootName "Biped Root : " text:"Bip001"
    edittext bipedBottomName "Biped Bottom : " text:"Bip001 L Toe0Nub" readOnly:true
      
    button buttonOK "빌드"
       
    on buttonOK pressed do
    (
        BuildRootMotion checkRemoveX.checked checkRemoveY.checked checkRemoveZ.checked bipedRootName.text bipedBottomName.text
        DestroyDialog RootMotionUI
    )
      
    on checkRemoveZ changed theState do
    (
        bipedBottomName.readOnly = checkRemoveZ.checked
    )
)
   
-------------------------------------------------------------------------------
-- open UI
-------------------------------------------------------------------------------
   
CreateDialog RootMotionUI 200 150

