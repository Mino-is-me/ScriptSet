# -*-coding: utf-8-*-
import pymxs

rt = pymxs.runtime
# import pymxs.runtime Not Work
import math


class Matrix3Plus():

    def __init__(self, matrix3):
        self.__set_matrix3(matrix3)

    def __mul__(self, other):
        return Matrix3Plus(self.get_matrix3() * other.get_matrix3())

    def __repr__(self):
        result = '(matrix3Plus [{},{},{},{}])'.format(self.get_row1(),
                                                      self.get_row2(),
                                                      self.get_row3(),
                                                      self.get_row4())
        return result

    def get_matrix3(self):
        return self.matrix3

    def __set_matrix3(self, matrix3):
        self.matrix3 = matrix3

    def get_row1(self):
        return self.get_matrix3().row1

    def get_row2(self):
        return self.get_matrix3().row2

    def get_row3(self):
        return self.get_matrix3().row3

    def get_row4(self):
        return self.get_matrix3().row4

    def set_row1(self, xVal, yVal, zVal):
        self.matrix3.row1 = rt.point3(xVal, yVal, zVal)

    def set_row2(self, xVal, yVal, zVal):
        self.matrix3.row2 = rt.point3(xVal, yVal, zVal)

    def set_row3(self, xVal, yVal, zVal):
        self.matrix3.row3 = rt.point3(xVal, yVal, zVal)

    def set_row4(self, xVal, yVal, zVal):
        self.matrix3.row4 = rt.point3(xVal, yVal, zVal)

    def get_translation(self):
        return self.get_matrix3().translation

    def get_rotateQuat(self):
        return self.get_matrix3().rotationpart

    def get_rotate(self):
        euler = rt.quatToEuler(self.get_matrix3().Rotation)
        return [euler.x, euler.y, euler.z]

    def get_scale(self):
        return self.get_matrix3().scalepart

    def get_inverse(self):
        return Matrix3Plus(rt.inverse(self.get_matrix3()))

    def get_isIdentity(self):
        return Matrix3Plus(rt.isIdentity(self.get_matrix3()))

    def set_rotateX(self, value):
        rt.rotateX(self.get_matrix3(), value)

    def set_rotateY(self, value):
        rt.rotateY(self.get_matrix3(), value)

    def set_rotateZ(self, value):
        rt.rotateZ(self.get_matrix3(), value)

    def set_rotate(self, XVal, YVal, ZVal):
        # 기존 로테이션은 계속 ADD 되므로
        # 아래와 같이 기본 매트릭스로 변환.

        # 기본 matrix
        BaseMtxPlus = get_matrixPlus()
        BaseMtx = BaseMtxPlus.get_matrix3()

        # SRT 순으로 진행
        # scale
        BaseMtxPlus.set_scale(*self.get_scale())

        # rotateion 증가함.
        BaseMtxPlus.set_rotateX(XVal)
        BaseMtxPlus.set_rotateY(YVal)
        BaseMtxPlus.set_rotateZ(ZVal)

        # 위치 이동
        BaseMtxPlus.set_translate(*self.get_translation())
        self.__set_matrix3(BaseMtxPlus.get_matrix3())

    def set_scale(self, XVal, YVal, ZVal):
        curScaleX, curScaleY, curScaleZ = self.get_scale()

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

        rt.scale(self.matrix3, rt.point3(resultX, resultY, resultZ))

    def set_translate(self, XVal, YVal, ZVal):
        rt.translate(self.matrix3, rt.point3(XVal, YVal, ZVal))


class get_matrixPlus(Matrix3Plus):
    def __init__(self, row1=[1, 0, 0], row2=[0, 1, 0], row3=[0, 0, 1], row4=[0, 0, 0]):
        self.matrix3 = rt.Matrix3(1)
        self.set_row1(*row1)
        self.set_row2(*row2)
        self.set_row3(*row3)
        self.set_row4(*row4)


class INodePlus():
    def __init__(self, INode):
        self.__set_INode(INode)

    def get_INode(self):
        return self.INode

    def __set_INode(self, INode):
        self.INode = INode

    def get_name(self):
        return self.INode.Name

    def set_name(self, name):
        self.INode.Name = name

    def get_parent(self):
        # parent가 있으면 INode를 리턴하겠지만.
        # 없다면 None으로 리턴
        # 하지만 set 할때 None을 적용하면 월드에 적용됨

        parentNode = self.INode.parent
        if parentNode:
            parentNode = get_PyNodePlus_byINode(parentNode)

        return parentNode

    def set_parent(self, parent):
        if parent:
            self.INode.parent = parent.get_INode()
        else:
            # None인 경우 / world에 페런트 된다.
            self.INode.parent = None

    def get_world_matrix(self):
        return Matrix3Plus(self.get_INode().transform)

    def set_world_matrix(self, Matrix3Plus):

        self.get_INode().transform = Matrix3Plus.get_matrix3()

    def get_local_matrix(self):

        curParent = self.get_parent()
        if curParent: curParent = self.get_parent().get_INode()

        if curParent:
            # 부모가 있다면 lcoal 계산
            parentMtx = curParent.transform
            return Matrix3Plus(self.INode.transform * rt.inverse(parentMtx))

        else:
            # 부모가 없다면 world 계산
            return self.get_world_matrix()

    def set_local_matrix(self, Matrix3Plus):
        matrix = Matrix3Plus.get_matrix3()
        curParent = self.get_parent()
        if curParent: curParent = self.get_parent().get_INode()

        if curParent:
            parentMtx = curParent.transform
            self.get_INode().transform = matrix * parentMtx

        else:
            self.set_world_matrix(Matrix3Plus)

    def get_local_position(self):
        mtx = self.get_local_matrix()
        return mtx.get_translation()

    def set_local_position(self, pos):
        x, y, z = pos
        MtxPlus = self.get_local_matrix()
        MtxPlus.set_row4(x, y, z)
        self.set_local_matrix(MtxPlus)

    def get_world_position(self):
        MtxPlus = self.get_world_matrix()
        return MtxPlus.get_translation()

    def set_world_position(self, pos):
        x, y, z = pos

        MtxPlus = self.get_world_matrix()
        MtxPlus.set_row4(x, y, z)
        self.set_world_matrix(MtxPlus)

    def set_local_rotate(self, eulerAngles):
        xRot, yRot, zRot = eulerAngles

        MtxPlus = self.get_local_matrix()
        MtxPlus.set_rotate(xRot, yRot, zRot)
        self.set_local_matrix(MtxPlus)

    def get_world_rotate(self):
        MtxPlus = self.get_world_matrix()

        return MtxPlus.get_rotate()

    def set_world_rotate(self, eulerAngles):
        xRot, yRot, zRot = eulerAngles

        MtxPlus = self.get_world_matrix()
        MtxPlus.set_rotate(xRot, yRot, zRot)
        self.set_world_matrix(MtxPlus)

    def get_local_rotate(self):
        MtxPlus = self.get_local_matrix()

        return MtxPlus.get_rotate()

    def get_world_scale(self):
        MtxPlus = self.get_world_matrix()

        return MtxPlus.get_scale()

    def set_world_scale(self, vector3):
        MtxPlus = self.get_world_matrix()
        MtxPlus.set_scale(*vector3)

        self.set_world_matrix(MtxPlus)

    def get_local_scale(self):
        MtxPlus = self.get_local_matrix()

        return MtxPlus.get_scale()

    def set_local_scale(self, vector3):
        # 기존에 rt 오브젝트로 하면 제대로 적용안되어
        MtxPlus = self.get_local_matrix()
        MtxPlus.set_scale(*vector3)

        self.set_local_matrix(MtxPlus)

    def get_type(self):
        # $Box:Box010 @ [134.284454,0.000000,65.145920]
        # => Box
        result = str(self.get_INode())
        type, _ = result.split(':')
        type = type.replace('$', '')
        type = type.lower()

        return type

    def get_handle(self):
        return self.get_INode().handle

    def set_visibility(self, value=True):
        if value == True :
            rt.unhide(self.get_INode())
        else :
            rt.hide(self.get_INode())


    def get_visibility(self):
        if self.get_INode().isHidden :
            return False
        else :
            return True

    def set_boxMode(self, value=True):
        self.get_INode().boxmode = value

    def get_boxMode(self):
        return self.get_INode().boxmode

    def get_transform_controller(self):
        return self.get_INode()['transform'].controller
        # Controller:Position_Rotation_Scale

    def get_position_controller(self):
        return self.get_INode()['transform']['position'].controller
        # Controller:Position_XYZ

    def get_rotation_controller(self):
        return self.get_INode()['transform']['rotation'].controller
        # Controller:Euler_XYZ

    def get_scale_controller(self):
        return self.get_INode()['transform']['scale'].controller
        # Controller:Bezier_Scale


class INodePlus_byHandleNum(INodePlus):
    def __init__(self, handleNum):
        self.INode = rt.maxOps.getNodeByHandle(handleNum)


class INodePlus_byName(INodePlus):
    def __init__(self, name):
        self.INode = rt.getNodeByName(name)


class PointPlus(INodePlus):

    def set_box(self, value=True):
        self.get_INode().Box = value

    def set_cross(self, value=True):
        self.get_INode().cross = value

    def set_centermarker(self, value=True):
        self.get_INode().centermarker = value

    def set_axistripod(self, value=True):
        self.get_INode().axistripod = value

    def set_size(self, value=10.0):
        self.get_INode().size = value


class PointPlus_byHandleNum(PointPlus):
    def __init__(self, handleNum):
        self.INode = rt.maxOps.getNodeByHandle(handleNum)


class PointPlus_byName(PointPlus):
    def __init__(self, name):
        self.INode = rt.getNodeByName(name)


class BonePlus(INodePlus):
    def set_width(self, value=1.0):
        self.get_INode().width = value
        rt.redrawViews()

    def get_width(self):
        return self.get_INode().width

    def set_height(self, value=1.0):
        self.get_INode().height = value
        rt.redrawViews()

    def get_height(self):
        return self.get_INode().height

    def set_length(self, value=1.0):
        self.get_INode().length = value
        rt.redrawViews()

    def get_length(self):
        return self.get_INode().length

    def set_taper(self, value=90.0):
        self.get_INode().Taper = value
        rt.redrawViews()

    def get_taper(self):
        return self.get_INode().Taper

    def set_sidefins(self, value=True):
        self.get_INode().sidefins = value
        # bone.sidefins = False
        # bone.sidefinssize = 10.0
        rt.redrawViews()

    def get_sidefins(self):
        return self.get_INode().sidefins

    def set_sideFinsSize(self, value=1.0):
        self.get_INode().sidefinssize = value
        rt.redrawViews()

    def get_sideFinsSize(self):
        return self.get_INode().sidefinssize

    def set_sideFinsEndTaper(self, value=10.0):
        self.get_INode().sidefinsendtaper = value
        rt.redrawViews()

    def get_sideFinsEndTaper(self):
        return self.get_INode().sidefinsendtaper

    def set_sideFinsStartTaper(self, value=10.0):
        self.get_INode().sidefinsstarttaper = value
        rt.redrawViews()

    def get_sideFinsStartTaper(self):
        return self.get_INode().sidefinsstarttaper

    def set_frontFin(self, value=True):
        self.get_INode().frontfin = value
        rt.redrawViews()

    def get_frontFin(self):
        return self.get_INode().frontfin

    def set_frontFinSize(self, value=1.0):
        self.get_INode().frontfinsize = value
        rt.redrawViews()

    def get_frontFinSize(self):
        return self.get_INode().frontfinsize

    def set_frontFinEndTaper(self, value=10.0):
        self.get_INode().frontfinendtaper = value
        rt.redrawViews()

    def get_frontFinEndTaper(self):
        return self.get_INode().frontfinendtaper

    def set_frontFinStartTaper(self, value=10.0):
        self.get_INode().frontfinstarttaper = value
        rt.redrawViews()

    def get_frontFinStartTaper(self):
        return self.get_INode().frontfinstarttaper

    def set_backFin(self, value=True):
        self.get_INode().backfin = value
        rt.redrawViews()

    def get_backFin(self):
        return self.get_INode().backfin

    def set_backFinSize(self, value=1.0):
        self.get_INode().backfinsize = value
        rt.redrawViews()

    def get_backFinSize(self):
        return self.get_INode().backfinsize

    def set_backFinEndTaper(self, value=10.0):
        self.get_INode().backfinendtaper = value
        rt.redrawViews()

    def get_backFinEndTaper(self):
        return self.get_INode().backfinendtaper

    def set_backFinStartTaper(self, value=10.0):
        self.get_INode().backfinstarttaper = value
        rt.redrawViews()

    def get_backFinStartTaper(self):
        return self.get_INode().backfinstarttaper


class BonePlus_byHandleNum(BonePlus):
    def __init__(self, handleNum):
        self.INode = rt.maxOps.getNodeByHandle(handleNum)


class BonePlus_byName(BonePlus):
    def __init__(self, name):
        self.INode = rt.getNodeByName(name)


class ExposeTmPlus(PointPlus):

    def set_exposeNode(self, targetINode):
        self.get_INode().exposeNode = targetINode

    def set_useParent(self, value=True):
        self.get_INode().useParent = value

    def get_useParent(self):
        return self.get_INode().useParent

    def set_localReferenceNode(self, targetINode):
        if self.get_useParent() == False:
            self.set_useParent(True)
        self.get_INode().localReferenceNode = targetINode

    def get_angle(self):
        return self.get_INode().angle

    def get_distance(self):
        return self.get_INode().distance

    def get_localPosition(self):
        return self.get_INode().localPosition

    def get_localEuler(self):
        return self.get_INode().localEuler


class ExposeTmPlus_byHandleNum(ExposeTmPlus):
    def __init__(self, handleNum):
        self.INode = rt.maxOps.getNodeByHandle(handleNum)


class ExposeTmPlus_byName(ExposeTmPlus):
    def __init__(self, name):
        self.INode = rt.getNodeByName(name)


# ===========================
# utils
# ===========================

class create_PointPlus(PointPlus):
    def __init__(self, name='Point1'):
        self.INode = rt.Point()
        self.set_name(name)


class create_GroupPlus(PointPlus):
    def __init__(self, name='Group1'):
        self.INode = rt.Point(cross=0, box=0, axisTripod=0, centerMarker=0)
        self.set_name(name)


class create_BonePlus(BonePlus):
    def __init__(self, name='Bone1'):
        self.INode = rt.BoneSys.createBone(rt.point3(0, 0, 0), rt.point3(0, 10, 0), rt.point3(1, 0, 0))
        self.set_name(name)


class create_ExposeTmPlus(ExposeTmPlus):
    def __init__(self, name='ExposeTm1'):
        self.INode = rt.ExposeTm()
        self.set_name(name)


def get_PyNodePlus_byHandle(handleNum):
    _baseINode = INodePlus_byHandleNum(handleNum)
    type = _baseINode.get_type().lower()

    if type == 'point_helper':
        result = PointPlus_byHandleNum(handleNum)
    elif type == 'exposetransformhelper':
        result = ExposeTmPlus_byHandleNum(handleNum)
    elif type == 'bone':
        result = BonePlus_byHandleNum(handleNum)
    else:
        result = _baseINode

    return result


def get_PyNodePlus_byINode(INode):
    _baseINode = INodePlus(INode)
    type = _baseINode.get_type().lower()

    if type == 'point_helper':
        result = PointPlus(INode)
    elif type == 'exposetransformhelper':
        result = ExposeTmPlus(INode)
    elif type == 'bone':
        result = BonePlus(INode)
    else:
        result = _baseINode

    return result


def get_PyNodePlus_byName(name):
    _baseINode = INodePlus_byName(name)
    type = _baseINode.get_type().lower()

    if type == 'point_helper':
        result = PointPlus_byName(name)
    elif type == 'exposetransformhelper':
        result = ExposeTmPlus_byName(name)
    elif type == 'bone':
        result = BonePlus_byName(name)
    else:
        result = _baseINode

    return result


def get_currentSelection(type=None):
    resultList = []
    # rt.GetCurrentSelection() --> #()
    # 3dsmax 데이터 형태로 나오니 이렇게 변환 사용.
    curSelected = list(rt.GetCurrentSelection())

    for iNode in curSelected:
        _baseINode = INodePlus(iNode)
        cur_type = _baseINode.get_type().lower()

        if cur_type == 'point_helper':
            result = PointPlus(iNode)

        elif cur_type == 'exposetransformhelper':
            result = ExposeTmPlus(iNode)

        elif cur_type == 'bone':
            result = BonePlus(iNode)

        else:
            result = _baseINode

        resultList.append(result)

    # 타입에 따른 필터링
    if type:
        return [n for n in resultList if type in n.get_type()]
    else:
        return resultList


def set_removeCallBacks(idName):
    mxsCommand = '''deleteAllChangeHandlers id:#{}'''.format(idName)
    return rt.execute(mxsCommand)


def set_removeCallBacks_transform():
    '''
    함수 set_callBack_transform 통해 생성한 callback들을 모두 제거합니다.
    '''
    mxsCommand = '''deleteAllChangeHandlers id:#callBack_transform'''
    return rt.execute(mxsCommand)


def set_callBack_transform(INodePlusList, customFuct_longName):
    '''
    input받은 INodeList 움직이면 콜백을 해주는 명령어 입니다.
    INodeList : callBack를 적용시킬 오브젝트를 넣어주세요.
    customFuct_longName : CallBack과 연결 해줄 함수를 넣어주세요. 안정성을 위해 풀네이밍을 넣어주세요.
    ex. customFuct (x) -> yourModule.customFuct (o)

    '''
    mxsCommand = ''
    for _INodePlus in INodePlusList:
        handleNum = _INodePlus.get_handle()
        mxsCommand += """
		_INode = maxOps.getNodeByHandle {handleNum}
		when transform _INode changes id:#callBack_transform do (
			python.execute("{CustomFuct}()" )
		)
		""".format(CustomFuct=customFuct_longName, handleNum=handleNum)
    rt.execute(mxsCommand)


def __get_functionName(toQuaryFuct):
    '''
    function 제대로 연결하기 위해
    Function의 네이밍을 정확히 얻어네 줍니다.
    ex. 주로 CallBack에 연결

    '''
    parent = toQuaryFuct.__module__
    if parent == '__main__':
        result = '{}'.format(toQuaryFuct.func_name)

    else:
        result = '{}.{}'.format(parent, toQuaryFuct.func_name)

    return result


def set_callback_selectionSetChanged(customFuct):
    customFuct_longName = __get_functionName(customFuct)
    mxsCommand = """
	fn selectionSetChanged_Command=
	(
		python.execute("{CustomFuct}()" )
	)

	 callbacks.addScript #selectionSetChanged "selectionSetChanged_Command()" id:#selectionSetChanged_1
	""".format(CustomFuct=customFuct_longName)

    rt.execute(mxsCommand)


def set_removeCallBacks_selectionSetChanged():
    '''
    함수 set_callback_selectionSetChanged 통해 생성한 callback들을 모두 제거합니다.
    '''
    mxsCommand = '''callbacks.removeScripts #selectionSetChanged id:#selectionSetChanged_1'''
    return rt.execute(mxsCommand)


def create_NodeInfo_Attributes(_INodePlus, Target_INodePlus, AttrName='obj'):
    '''
    노드에 INode를 저장하고 싶을때 사용합니다.
    데이터 셋을 만들때 유용합니다.
    '''
    handleNum = _INodePlus.get_handle()
    target_handleNum = Target_INodePlus.get_handle()
    mxsCommand = '''
	CustomAttr= attributes NodeInfo_Attributes(
	parameters NodeInfo_Attributes rollout:params
	(
	{AttrName} type:#node
	)

	rollout params "NodeInfo_Attributes"
	(
	)

	)
	_INode = maxOps.getNodeByHandle {handleNum}
	target = maxOps.getNodeByHandle {target_handleNum}
	custAttributes.add _INode CustomAttr baseobject:True
	_INode.{AttrName} = target
	'''.format(AttrName=AttrName, handleNum=handleNum, target_handleNum=target_handleNum)
    rt.execute(mxsCommand)


def get_NodeInfo_Attributes(_INodePlus, AttrName='obj'):
    '''
    create_NodeInfo_Attributes 펑션으로 만들어진게 있다면
    해당된 연결된 노드을 INodePlus로 리턴합니다.
    '''
    _INode = _INodePlus.get_INode()
    resultINode = eval("_INode.{}".format(AttrName))
    return get_PyNodePlus_byINode(resultINode)


def set_TransformLockFlags_Seleted():
    rt.setTransformLockFlags(rt.getCurrentSelection(), rt.name("all"))


def set_transformScript_DirectConnect_world(Driver_INodePlus, Target_INodePlus):
    # 파라미터가 들어가는 AttrBox를 리턴합니다.
    # 만약 AttrBox가 없다면 그냥 None이 리턴됩니다.
    # 이 함수는 Attr를 추가할 때 혹은 체크할 때 융용합니다.
    '''
    :param INode:
    :return: AttributeDef(your Attr), None
    '''

    driverNode_Num = Driver_INodePlus.get_handle()
    targetNode_Num = Target_INodePlus.get_handle()

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


def set_transformScript_DirectConnect_local(Driver_INodePlus, Target_INodePlus):
    # 파라미터가 들어가는 AttrBox를 리턴합니다.
    # 만약 AttrBox가 없다면 그냥 None이 리턴됩니다.
    # 이 함수는 Attr를 추가할 때 혹은 체크할 때 융용합니다.
    '''
    :param INode:
    :return: AttributeDef(your Attr), None
    '''

    driverNode_Num = Driver_INodePlus.get_handle()
    targetNode_Num = Target_INodePlus.get_handle()

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


def set_transformScript_DirectConnect_world(Driver_INodePlus, Target_INodePlus):
    # 파라미터가 들어가는 AttrBox를 리턴합니다.
    # 만약 AttrBox가 없다면 그냥 None이 리턴됩니다.
    # 이 함수는 Attr를 추가할 때 혹은 체크할 때 융용합니다.
    '''
    :param INode:
    :return: AttributeDef(your Attr), None
    '''

    driverNode_Num = Driver_INodePlus.get_handle()
    targetNode_Num = Target_INodePlus.get_handle()

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


def get_layer(layerName):
    return pymxsPlus.runtime.LayerManager.getLayerFromName(layerName)


def set_select(INodePlusList):
    INodeList = [INodePlus.get_INode() for INodePlus in INodePlusList]
    rt.select(INodeList)


def set_transformController_PositionRotationScale(pymxsPlusNode):
    INode = pymxsPlusNode.get_INode()
    ctrl = rt.PRS()
    INode.controller = ctrl


# 사용 예
# for sel in pm.get_currentSelection():
#	set_transformController_PositionRotationScale(sel)

def set_positionController_Position_XYZ(pymxsPlusNode):
    INode = pymxsPlusNode.get_INode()
    ctrl = rt.Position_XYZ()
    rt.refs.replaceReference(INode.controller, 1, ctrl)
    # 사용 예
    # for sel in pm.get_currentSelection():
    #	set_transformController_PositionRotationScale(sel)


def set_positionController_Position_Constraint(*pymxsPlusNodes):
    '''
    example
    if you want to pointConstraint in 3ds max
    just like below

    selList = pm.get_currentSelection()
    set_positionController_Position_Constraint ( *selList )
    '''
    if len(pymxsPlusNodes) < 2: return

    driverList = pymxsPlusNodes[:-1]
    target = pymxsPlusNodes[-1]

    driverList_INode = [drv.get_INode() for drv in driverList]
    target_INode = target.get_INode()

    # 컨트롤러 추가
    ctrl = rt.Position_Constraint()
    posConstraintInterface = ctrl.constraints
    rt.refs.replaceReference(target_INode.controller, 1, ctrl)

    # target 추가
    for drv in driverList_INode:
        posConstraintInterface.appendTarget(drv, 1.0)


def set_rotationController_Euler_XYZ(pymxsPlusNode):
    INode = pymxsPlusNode.get_INode()
    ctrl = rt.Euler_XYZ()
    rt.refs.replaceReference(INode.controller, 2, ctrl)
    # 사용 예
    # for sel in pm.get_currentSelection():
    #	set_transformController_PositionRotationScale(sel)


def set_rotationController_Orientation_Constraint(*pymxsPlusNodes):
    '''
    example
    if you want to pointConstraint in 3ds max
    just like below

    selList = pm.get_currentSelection()
    set_positionController_Position_Constraint ( *selList )
    '''
    if len(pymxsPlusNodes) < 2: return

    driverList = pymxsPlusNodes[:-1]
    target = pymxsPlusNodes[-1]

    driverList_INode = [drv.get_INode() for drv in driverList]
    target_INode = target.get_INode()

    # 컨트롤러 추가
    ctrl = rt.Orientation_Constraint()
    posConstraintInterface = ctrl.constraints
    rt.refs.replaceReference(target_INode.controller, 2, ctrl)

    # target 추가
    for drv in driverList_INode:
        posConstraintInterface.appendTarget(drv, 1.0)


def set_rotateController_LookAt_Constraint(TargetNode, ApplyNode, UpNode,
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

    Target_INode = TargetNode.get_INode()
    Apply_INode = ApplyNode.get_INode()
    UpNode_INode = UpNode.get_INode()

    # 컨트롤러 추가
    ctrl = rt.LookAt_Constraint()
    RotConstraintInterface = ctrl.constraints
    rt.refs.replaceReference(Apply_INode.controller, 2, ctrl)

    # 속성 변경
    RotConstraintInterface.appendTarget(Target_INode, 1.0)
    RotConstraintInterface.pickUpNode(UpNode_INode)

    # axis 변경
    axisDict = {'x': 0, 'y': 1, 'z': 2}
    RotConstraintInterface.target_axis(axisDict[targetAxis.lower()])
    RotConstraintInterface.upnode_axis(axisDict[upnode_axis.lower()])
    RotConstraintInterface.StoUP_axis(axisDict[Source_axis.lower()])

    RotConstraintInterface.arget_axisFlip(target_axisFlip)
    RotConstraintInterface.StoUP_axisFlip(StoUP_axisFlip)


def set_rotationController_Bezier_Scale(pymxsPlusNode):
    INode = pymxsPlusNode.get_INode()
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
        startBone.set_length(dis)

    # 끝 처리
    tipBone = boneList[-1]
    length = (tipBone.get_height() + tipBone.get_width()) / 2.0
    tipBone.set_length(length)


def get_allObjects():
    oldSel = get_currentSelection()

    rt.select(rt.objects)
    allObjects = get_currentSelection()
    if oldSel : 
        set_select(oldSel)
    else :
        rt.clearSelection()

    return allObjects


def get_allObjects_byName():
    result = [node.get_name() for node in get_allObjects()]
    return result


def get_sameName_Num(name='', checkInList=[]):
    if checkInList == []:
        checkInList = get_allObjects_byName()

    return checkInList.count(name)


def is_unique(name, checkInList=[]):
    if checkInList == []:
        checkInList = get_allObjects_byName()

    if checkInList.count(name) == 1:
        return True
    else:
        return False

def redrawViews() :
    rt.redrawViews()

def get_startFrame() :
    return float( rt.animationRange.start )

def get_endFrame() :
    return float( rt.animationRange.end )

def set_sliderTime(value) :
    rt.sliderTime = value
