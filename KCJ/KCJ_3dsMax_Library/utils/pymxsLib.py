# -*-coding: utf-8-*-
import pymxs

rt = pymxs.runtime
import math


def set_redrawViews():
    # 화면을 다시 그려주는 기능을 합니다.
    rt.redrawViews()


def get_selected():
    return list(rt.GetCurrentSelection())


def get_layer(layerName):
    return pymxs.runtime.LayerManager.getLayerFromName(layerName)


def set_select(DataList):
    # DataList = [ INode, String, HandleNum, .... ]
    # okay
    SelList = [get_INode_auto(Data) for Data in DataList]
    rt.select(SelList)


def get_parent(INode):
    # return : Parent INode /  None (if no Parent )

    return INode.parent


def get_children(INode):
    # INode
    #   -ChildA
    #       -ChildA1
    #   -ChildB
    #   -ChildC
    # return : [ INode(ChildA), INode(ChildB), INode(ChildC) ]
    return list(INode.children)


def set_transformController_PositionRotationScale(INode):
    ctrl = rt.PRS()
    INode.controller = ctrl


# 사용 예
# for sel in pm.get_currentSelection():
#	set_transformController_PositionRotationScale(sel)

def set_positionController_Position_XYZ(INode):
    ctrl = rt.Position_XYZ()
    rt.refs.replaceReference(INode.controller, 1, ctrl)
    # 사용 예
    # for sel in pm.get_currentSelection():
    #	set_transformController_PositionRotationScale(sel)


def get_baseMatrix3():
    return rt.Matrix3(1)


def build_matrix3(row1=[1, 0, 0],
                  row2=[0, 1, 0],
                  row3=[0, 0, 1],
                  row4=[0, 0, 0]):
    matrix3 = rt.Matrix3(1)
    matrix3.row1 = rt.point3(*row1)
    matrix3.row2 = rt.point3(*row2)
    matrix3.row3 = rt.point3(*row3)
    matrix3.row4 = rt.point3(*row4)

    return matrix3


def set_matrix3_row1(matrix3, xVal, yVal, zVal):
    matrix3.row1 = rt.point3(xVal, yVal, zVal)
    return matrix3


def set_matrix3_row2(matrix3, xVal, yVal, zVal):
    matrix3.row2 = rt.point3(xVal, yVal, zVal)
    return matrix3


def set_matrix3_row3(matrix3, xVal, yVal, zVal):
    matrix3.row3 = rt.point3(xVal, yVal, zVal)
    return matrix3


def set_matrix3_row4(matrix3, xVal, yVal, zVal):
    matrix3.row4 = rt.point3(xVal, yVal, zVal)
    return matrix3


def get_matrix3_translation(matrix3):
    return matrix3.translation


def get_matrix3_rotateQuat(matrix3):
    return matrix3.rotationpart


def get_matrix3_rotate(matrix3):
    euler = rt.quatToEuler(matrix3.Rotation)
    return [euler.x, euler.y, euler.z]


def get_matrix3_scale(matrix3):
    return matrix3.scalepart


def get_matrix3_inverse(matrix3):
    return rt.inverse(matrix3)


def get_matrix3_isIdentity(matrix3):
    return rt.isIdentity(matrix3)


def set_matrix3_rotateX(matrix3, value):
    rt.rotateX(matrix3, value)
    return matrix3


def set_matrix3_rotateY(matrix3, value):
    rt.rotateY(matrix3, value)
    return matrix3


def set_matrix3_rotateZ(matrix3, value):
    rt.rotateZ(matrix3, value)
    return matrix3


def set_matrix3_translate(matrix3, XVal, YVal, ZVal):
    rt.translate(matrix3, rt.point3(XVal, YVal, ZVal))
    return matrix3


def set_matrix3_scale(matrix3, XVal, YVal, ZVal):
    curScaleX, curScaleY, curScaleZ = get_matrix3_scale(matrix3)

    # 0이면 연산이 안되므로 미세하게라도 삽입.
    if XVal == 0 or curScaleX == 0.0:
        resultX = 0.000001
    else:
        resultX = float(XVal) / float(curScaleX)

    if YVal == 0 or curScaleY == 0.0:
        resultY = 0.000001
    else:
        resultY = float(YVal) / float(curScaleY)

    if ZVal == 0 or curScaleZ == 0.0:
        resultZ = 0.000001
    else:
        resultZ = float(ZVal) / float(curScaleZ)

    rt.scale(matrix3, rt.point3(resultX, resultY, resultZ))

    return matrix3


def set_matrix3_rotate(matrix3, XVal, YVal, ZVal):
    # 기존 로테이션은 계속 ADD 되므로
    # 아래와 같이 기본 매트릭스로 변환.

    # 기본 matrix
    BaseMtx = get_baseMatrix3()

    # 데이터얻기
    curScaleX, curScaleY, curScaleZ = get_matrix3_scale(matrix3)
    curPosX, curPosY, curPosZ = get_matrix3_translation(matrix3)

    # SRT 순으로 진행
    # scale
    matrix3 = set_matrix3_scale(matrix3, curScaleX, curScaleY, curScaleZ)

    # rotateion 증가함.
    matrix3 = set_matrix3_rotateX(matrix3, XVal)
    matrix3 = set_matrix3_rotateY(matrix3, YVal)
    matrix3 = set_matrix3_rotateZ(matrix3, ZVal)

    # 위치 이동
    matrix3 = set_matrix3_translate(matrix3, curPosX, curPosY, curPosZ)

    return matrix3


def get_INode_ByName(nodeName):
    return rt.getNodeByName(nodeName)


def get_INode_ByHandleNum(handleNum):
    return rt.maxOps.getNodeByHandle(handleNum)


def get_INode_auto(Data):
    # string 인지 검사
    curTypeText = str(type(Data))
    if 'str' in curTypeText:
        INode = get_INode_ByName(Data)
    elif 'int' in curTypeText:
        INode = get_INode_ByName(Data)
    elif 'MXSWrapperBase' in curTypeText:
        INode = Data
    else:
        # 에러인 경우 처리
        msg = 'Data is not rightValue. plase Check!\nCurData : {}'.format(Data)
        raise Exception(msg)

    return INode


def get_INode_parent(INode):
    # process
    return INode.parent


def set_INode_parent(INode, parentINode):
    # None이면 world에 페런트 됩니다.
    INode.parent = parentINode


def get_INode_world_matrix3(INode):
    return INode.transform


def set_INode_world_matrix3(INode, matrix3):
    INode.transform = matrix3


def get_INode_local_matrix3(INode):
    curParent = get_INode_parent(INode)

    if curParent:
        # 부모가 있다면 lcoal 계산
        parentMtx = curParent.transform
        return INode.transform * rt.inverse(parentMtx)
    else:
        # 부모가 없다면 world 계산
        return INode.transform


def set_INode_local_matrix3(INode, matrix3):
    curParent = get_INode_parent(INode)

    if curParent:
        parentMtx = curParent.transform
        INode.transform = matrix3 * parentMtx

    else:
        INode.transform = matrix3


def get_INode_local_position(INode):
    mtx = get_INode_local_matrix3(INode)
    return get_matrix3_translation(mtx)


def set_INode_local_position(INode, pos):
    x, y, z = pos
    mtx = get_INode_local_matrix3(INode)
    mtx = set_matrix3_row4(mtx, x, y, z)
    set_INode_local_matrix3(INode, mtx)


def get_INode_world_position(INode):
    mtx = get_INode_world_matrix3(INode)
    return get_matrix3_translation(mtx)


def set_INode_world_position(INode, pos):
    x, y, z = pos

    mtx = get_INode_world_matrix3(INode)
    mtx = set_matrix3_row4(mtx, x, y, z)
    set_INode_world_matrix3(INode, mtx)


def get_INode_local_rotate(INode):
    mtx = get_INode_local_matrix3(INode)

    return get_matrix3_rotate(mtx)


def set_INode_local_rotate(INode, eulerAngles):
    xRot, yRot, zRot = eulerAngles

    mtx = get_INode_local_matrix3(INode)
    mtx = set_matrix3_rotate(mtx, xRot, yRot, zRot)
    set_INode_local_matrix3(INode, mtx)


def get_INode_world_rotate(INode):
    mtx = get_INode_world_matrix3(INode)

    return get_matrix3_rotate(mtx)


def set_INode_world_rotate(INode, eulerAngles):
    xRot, yRot, zRot = eulerAngles

    mtx = get_INode_world_matrix3(INode)
    mtx = set_matrix3_rotate(mtx, xRot, yRot, zRot)
    set_INode_world_matrix3(INode, mtx)


def get_INode_world_scale(INode):
    mtx = get_INode_world_matrix3(INode)

    return get_matrix3_scale(mtx)


def set_INode_world_scale(INode, vector3):
    mtx = get_INode_world_matrix3(INode)
    sx, sy, sz = vector3
    mtx = set_matrix3_scale(mtx, sx, sy, sz)

    set_INode_world_matrix3(INode, mtx)


def get_INode_local_scale(INode):
    mtx = get_INode_local_matrix3(INode)

    return get_matrix3_scale(mtx)


def set_INode_local_scale(INode, vector3):
    # 기존에 rt 오브젝트로 하면 제대로 적용안되어
    mtx = get_INode_local_matrix3(INode)
    sx, sy, sz = vector3
    mtx = set_matrix3_scale(mtx, sx, sy, sz)

    set_INode_local_matrix3(INode, mtx)


def get_INode_type(INode):
    # $Box:Box010 @ [134.284454,0.000000,65.145920]
    # => Box
    result = str(INode)
    type, _ = result.split(':')
    type = type.replace('$', '')
    type = type.lower()

    return type


def get_INode_handle(INode):
    return INode.handle


def get_INode_name(INode):
    return INode.name


def set_INode_visibility(INode, value=True):
    INode.visibility = value


def get_INode_visibility(INode):
    return INode.visibility


def set_INode_boxMode(INode, value=True):
    INode.boxmode = value


def get_INode_boxMode(INode):
    return INode.boxmode


def get_INode_transform_controller(INode):
    return INode['transform'].controller
    # Controller:Position_Rotation_Scale


def get_INode_position_controller(INode):
    return INode['transform']['position'].controller
    # Controller:Position_XYZ


def get_INode_rotation_controller(INode):
    return INode['transform']['rotation'].controller
    # Controller:Euler_XYZ


def get_INode_scale_controller(INode):
    return INode['transform']['scale'].controller
    # Controller:Bezier_Scale


def set_TransformLockFlags(Nodes):
    rt.setTransformLockFlags(Nodes, rt.name("all"))


def set_InheritanceFlags(Nodes):
    rt.setInheritanceFlags(Nodes, rt.name("all"))


def set_Bone_length(Bone, value):
    Bone.length = value


def get_Bone_length(Bone):
    return Bone.length


def set_Bone_height(Bone, value=1.0):
    Bone.height = value


def get_Bone_height(Bone):
    return Bone.height


def set_width(Bone, value=1.0):
    Bone.width = value


def get_width(Bone):
    return Bone.width


def set_taper(Bone, value=90.0):
    Bone.Taper = value


def get_taper(Bone):
    return Bone.Taper


def set_sidefins(Bone, value=True):
    Bone.sidefins = value
    # bone.sidefins = False
    # bone.sidefinssize = 10.0


def get_sidefins(Bone):
    return Bone.sidefins


def set_sideFinsSize(Bone, value=1.0):
    Bone.sidefinssize = value


def get_sideFinsSize(Bone):
    return Bone.sidefinssize


def set_sideFinsEndTaper(Bone, value=10.0):
    Bone.sidefinsendtaper = value


def get_sideFinsEndTaper(Bone):
    return Bone.sidefinsendtaper


def set_sideFinsStartTaper(Bone, value=10.0):
    Bone.sidefinsstarttaper = value


def get_sideFinsStartTaper(Bone):
    return Bone.sidefinsstarttaper


def set_frontFin(Bone, value=True):
    Bone.frontfin = value


def get_frontFin(Bone):
    return Bone.frontfin


def set_frontFinSize(Bone, value=1.0):
    Bone.frontfinsize = value


def get_frontFinSize(Bone):
    return Bone.frontfinsize


def set_frontFinEndTaper(Bone, value=10.0):
    Bone.frontfinendtaper = value


def get_frontFinEndTaper(Bone):
    return Bone.frontfinendtaper


def set_frontFinStartTaper(Bone, value=10.0):
    Bone.frontfinstarttaper = value


def get_frontFinStartTaper(Bone):
    return Bone.frontfinstarttaper


def set_backFin(Bone, value=True):
    Bone.backfin = value


def get_backFin(Bone):
    return Bone.backfin


def set_backFinSize(Bone, value=1.0):
    Bone.backfinsize = value


def get_backFinSize(Bone):
    return Bone.backfinsize


def set_backFinEndTaper(Bone, value=10.0):
    Bone.backfinendtaper = value


def get_backFinEndTaper(Bone):
    return Bone.backfinendtaper


def set_backFinStartTaper(Bone, value=10.0):
    Bone.backfinstarttaper = value


def get_backFinStartTaper(Bone):
    return Bone.backfinstarttaper


def set_transformScript_DirectConnect_world(driver, target):
    # 파라미터가 들어가는 AttrBox를 리턴합니다.
    # 만약 AttrBox가 없다면 그냥 None이 리턴됩니다.
    # 이 함수는 Attr를 추가할 때 혹은 체크할 때 융용합니다.
    '''
    :param INode:
    :return: AttributeDef(your Attr), None
    '''

    driverNode_Num = get_INode_handle(driver)
    targetNode_Num = get_INode_handle(target)

    mxsCommand = """
	targetNode = maxOps.getNodeByHandle {targetNode_Num}
	driverNode = maxOps.getNodeByHandle {driverNode_Num}

	-- create a MaxScript controller
	s = transform_script()


	-- this will track the position of the object
	s.AddNode "driverNode" driverNode

	-- this is the script that will call our getBallRotation function
	str = "driverNode.transform"

	-- start the controller up
	s.script = str

	targetNode.transform.controller = s
	""".format(targetNode_Num=targetNode_Num, driverNode_Num=driverNode_Num)

    return rt.execute(mxsCommand)


def set_transformScript_DirectConnect_local(driver, target):
    # 파라미터가 들어가는 AttrBox를 리턴합니다.
    # 만약 AttrBox가 없다면 그냥 None이 리턴됩니다.
    # 이 함수는 Attr를 추가할 때 혹은 체크할 때 융용합니다.
    '''
    :param INode:
    :return: AttributeDef(your Attr), None
    '''

    driverNode_Num = get_INode_handle(driver)
    targetNode_Num = get_INode_handle(target)

    mxsCommand = """
	targetNode = maxOps.getNodeByHandle {targetNode_Num}
	driverNode = maxOps.getNodeByHandle {driverNode_Num}

	-- create a MaxScript controller
	s = transform_script()


	-- this will track the position of the object
	s.AddNode "driverNode" driverNode

	-- this is the script that will call our getBallRotation function
	str = "if  driverNode.parent != undefiend then ( driverNode.transform * (inverse driverNode.parent.transform)) else(driverNode.transform)"

	-- start the controller up
	s.script = str

	targetNode.transform.controller = s
	""".format(targetNode_Num=targetNode_Num, driverNode_Num=driverNode_Num)

    return rt.execute(mxsCommand)


def has_INode_Attr_inBaseObject(node, attr):
    # inBaseObject에 특정한 Attr가 존재 유무를 검색합니다.

    '''
    :param INode:
    :return: AttributeDef(your Attr), None
    '''

    node_Num = get_INode_handle(node)

    mxsCommand = '''
    __node = maxOps.getNodeByHandle {node_Num}
    isProperty __node.baseObject #{attr}
    '''.format(node_Num=node_Num, attr=attr)
    # print mxsCommand
    return rt.execute(mxsCommand)


def get_INode_AttrList(node, attrOrigName=False):
    '''
    최상단 modifiers 기준으로 모든 AttrList를 얻습니다.
    Attr 체크할때 유용합니다.
    '''
    cur_ModifierList = list(node.modifiers) + [ node.baseObject]
    cur_TopModifier = cur_ModifierList[0]

    cur_TopModifier_name = cur_TopModifier.name
    cur_TopModifier_name = cur_TopModifier_name.replace(' ', '_')

    print
    # [<EmptyModifier<EmptyModifier:Attribute Holder>>, <Edit_Mesh<Edit_Mesh:Edit Mesh>>]


    resultAttrList = []
    ParentAttrList = list(cur_TopModifier.custattributes)
    # print ParentAttrList
    # [<<AttributeDef:Custom_Attributes><Custom_Attributes:Custom_Attributes>>, <<AttributeDef:Custom_Attributes_Presets><Custom_Attributes_Presets:Custom_Attributes_Presets>>]

    for ParentAt in ParentAttrList:
        attrs = dir(ParentAt)
        resultList = ['{}.{}'.format(ParentAt.name, at) for at in attrs]
        resultAttrList.extend(resultList)

    # print resultAttrList
    # ['Custom_Attributes.getmxsprop', 'Custom_Attributes.setmxsprop', 'Custom_Attributes.test', 'Custom_Attributes.tset', 'Custom_Attributes_Presets.getmxsprop', 'Custom_Attributes_Presets.presetName_str', 'Custom_Attributes_Presets.preset_str', 'Custom_Attributes_Presets.rampOn', 'Custom_Attributes_Presets.setmxsprop']

    # wrap BaseObjects
    if attrOrigName == False:
        return [ cur_TopModifier_name+'.' + at for at in resultAttrList]
    else:
        return [at.split('.')[-1] for at in resultAttrList]


def set_PosScript_IKFK(IKNode, FKNode, OutNode, AdjustCtrl):
    # IKFK 연결을 진행합니다.
    # 기존의 PointConst로 활용한 방법은 기존의 로컬길이를 헤치므로 적합하지 않습니다.
    # 이 스크립트는 기존의 로컬 위치값을 기준으로 체인지 합니다.
    # AdjustCtrl 에는 IKFK Attr가 있어야 작동합니다.
    '''
    :param INode:
    :return: AttributeDef(your Attr), None
    '''

    IKNode_Num = get_INode_handle(IKNode)
    FKNode_Num = get_INode_handle(FKNode)
    OutNode_Num = get_INode_handle(OutNode)
    AdjustCtrl_Num = get_INode_handle(AdjustCtrl)

    mxsCommand = """
	FKNode = maxOps.getNodeByHandle {FKNode_Num}
	IKNode = maxOps.getNodeByHandle {IKNode_Num}
	OutNode = maxOps.getNodeByHandle {OutNode_Num}
    AdjustCtrl = maxOps.getNodeByHandle {AdjustCtrl_Num}

	-- create a MaxScript controller
	s = position_script()


	-- this will track the position of the object
	s.AddNode "IKNode" IKNode
	s.AddNode "FKNode" FKNode
	s.AddNode "OutNode" OutNode
	s.AddNode "AdjustCtrl" AdjustCtrl

	-- this is the script that will call our getBallRotation function

	str = " if  IKNode.parent != undefiend then (
            IKMtx = (IKNode.transform * (inverse IKNode.parent.transform))
            )
            else( 
                IKMtx  = IKNode.transform
            )

            if  FKNode.parent != undefiend then (
                FKMtx = (FKNode.transform * (inverse FKNode.parent.transform))
            )
            else( 
                FKMtx  = FKNode.transform
            )

            IKMtx.position * (1-(AdjustCtrl.IKFK/100) ) + FKMtx.position * ( (AdjustCtrl.IKFK/100) )
            "

	-- start the controller up
	s.script = str

	OutNode.pos.controller = s
	""".format(FKNode_Num=FKNode_Num, IKNode_Num=IKNode_Num, OutNode_Num=OutNode_Num, AdjustCtrl_Num=AdjustCtrl_Num)

    return rt.execute(mxsCommand)


def set_positionController_Position_Constraint(*INodes):
    '''
    example
    if you want to pointConstraint in 3ds max
    just like below

    selList = pm.get_currentSelection()
    set_positionController_Position_Constraint ( *selList )
    '''
    if len(INodes) < 2: return

    driverList = INodes[:-1]
    target = INodes[-1]

    driverList_INode = driverList
    target_INode = target

    # 컨트롤러 추가
    ctrl = rt.Position_Constraint()
    posConstraintInterface = ctrl.constraints
    rt.refs.replaceReference(target_INode.controller, 1, ctrl)

    # target 추가
    for drv in driverList_INode:
        posConstraintInterface.appendTarget(drv, 1.0)


def set_rotationController_Euler_XYZ(INode):
    ctrl = rt.Euler_XYZ()
    rt.refs.replaceReference(INode.controller, 2, ctrl)
    # 사용 예
    # for sel in pm.get_currentSelection():
    #	set_transformController_PositionRotationScale(sel)


def set_rotationController_Orientation_Constraint(*INodes):
    '''
    example
    if you want to pointConstraint in 3ds max
    just like below

    selList = pm.get_currentSelection()
    set_positionController_Position_Constraint ( *selList )
    '''
    if len(INodes) < 2: return

    driverList = INodes[:-1]
    target = INodes[-1]

    driverList_INode = driverList
    target_INode = target

    # 컨트롤러 추가
    ctrl = rt.Orientation_Constraint()
    posConstraintInterface = ctrl.constraints
    rt.refs.replaceReference(target_INode.controller, 2, ctrl)

    # target 추가
    for drv in driverList_INode:
        posConstraintInterface.appendTarget(drv, 1.0)


def set_rotateController_LookAt_Constraint(Driver_INode, Driven_INode, Up_INode,
                                           targetAxis='x',
                                           upnode_axis='z',
                                           Source_axis='z',
                                           target_axisFlip=False,
                                           StoUP_axisFlip=False):
    '''
    example
    if you want to pointConstraint in 3ds max
    just like below

    selList = pm.get_currentSelection()
    set_positionController_Position_Constraint ( *selList )
    '''

    # 컨트롤러 추가
    ctrl = rt.LookAt_Constraint()
    RotConstraintInterface = ctrl.constraints
    rt.refs.replaceReference(Driven_INode.controller, 2, ctrl)

    # 속성 변경
    RotConstraintInterface.appendTarget(Driver_INode, 1.0)
    RotConstraintInterface.pickUpNode(Up_INode)

    # axis 변경
    axisDict = {'x': 0, 'y': 1, 'z': 2}
    RotConstraintInterface.target_axis(axisDict[targetAxis.lower()])
    RotConstraintInterface.upnode_axis(axisDict[upnode_axis.lower()])
    RotConstraintInterface.StoUP_axis(axisDict[Source_axis.lower()])

    RotConstraintInterface.arget_axisFlip(target_axisFlip)
    RotConstraintInterface.StoUP_axisFlip(StoUP_axisFlip)


def set_rotationController_Bezier_Scale(INode):
    ctrl = rt.Bezier_Scale()
    rt.refs.replaceReference(INode.controller, 3, ctrl)
    # 사용 예
    # for sel in pm.get_currentSelection():
    #	set_transformController_PositionRotationScale(sel)


def set_autoBoneLength(boneList, persent=1.0):
    for i, _ in enumerate(boneList):
        startBone = boneList[i]
        if startBone == boneList[-1]: break
        EndBone = boneList[i + 1]

        pointA = startBone.get_world_position()
        pointB = EndBone.get_world_position()
        x1, y1, z1 = pointA
        x2, y2, z2 = pointB

        # get distance

        dis = math.sqrt(math.pow(x2 - x1, 2)
                        + math.pow(y2 - y1, 2)
                        + math.pow(z2 - z1, 2))
        dis = dis * persent
        set_Bone_length(startBone, dis)

    # 끝 처리
    # child가 있다면
    tipBone = boneList[-1]
    length = (tipBone.get_height() + tipBone.get_width()) / 2.0
    set_Bone_length(tipBone, length)


def create_floatAttr_spinner(INode, attrName, minVal=0, maxVal=10, defaultVal=0):
    targetHandleNum = INode.handle
    command = '''
undo "add Attr" on
(
	obj = maxOps.getNodeByHandle {targetHandleNum}

	attrExists = isProperty obj.baseObject #{attrName}

	if  attrExists == False do
	(

		CustomAttr= attributes Custom_Attributes
		(

		parameters {attrName} rollout:my_rollout
			(
			{attrName} type:#float ui:paramUI default:0
			)

		rollout my_rollout "Custom_Attributes"
			(
			Spinner paramUI "{attrName}" type: #float Range:[{minVal}, {maxVal}, {defaultVal}]
			)

		)

		custAttributes.add obj CustomAttr baseobject:True

	)
)
	'''.format(targetHandleNum=targetHandleNum,
               attrName=attrName,
               minVal=minVal,
               maxVal=maxVal,
               defaultVal=defaultVal)
    # for Debug
    # print command

    return rt.execute(command)


def create_floatAttr_slider(INode, attrName, minVal=0, maxVal=10, defaultVal=0):
    targetHandleNum = INode.handle
    command = '''
undo "add Attr" on
(
	obj = maxOps.getNodeByHandle {targetHandleNum}

	attrExists = isProperty obj.baseObject #{attrName}

	if  attrExists == False do
	(

		CustomAttr= attributes Custom_Attributes
		(

		parameters {attrName} rollout:my_rollout
			(
			{attrName} type:#float ui:paramUI default:0
			)

		rollout my_rollout "Custom_Attributes"
			(
			Slider paramUI "{attrName}" type: #float Range:[{minVal}, {maxVal}, {defaultVal}]
			)

		)

		custAttributes.add obj CustomAttr baseobject:True

	)
)
	'''.format(targetHandleNum=targetHandleNum,
               attrName=attrName,
               minVal=minVal,
               maxVal=maxVal,
               defaultVal=defaultVal)
    # for Debug
    # print command

    return rt.execute(command)

def get_startFrame() :
    return float( rt.animationRange.start )

def get_endFrame() :
    return float( rt.animationRange.end )

def set_sliderTime(value) :
    rt.sliderTime = value


def run_pythonFile_in3dsMax(pythonFilePath):
    '''
    python file을 3ds max에서 실행합니다.
    '''
    command = '''python.ExecuteFile "{}"'''.format(pythonFilePath)
    # debug
    # print 'command'
    # print command

    return rt.execute(command)
