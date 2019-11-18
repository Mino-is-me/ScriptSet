CameraBone = Bone()
CameraBone.parent = $Root
CAM = $

CAM.name = "Link_Camera_CAM"

CameraBone.name = "Link_Camera"

posCtrl = Position_Constraint()
CameraBone.position.controller = posCtrl
posCtrl.appendTarget $Link_Camera_CAM 100 

RotCtrl = Orientation_Constraint()
CameraBone.rotation.controller = RotCtrl
RotCtrl.appendTarget $Link_Camera_CAM 100 

CameraBone.wireColor = Red