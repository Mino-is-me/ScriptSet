CameraBone = Bone()
CameraBone.parent = $Root
CAM = $

CAM.name = "camera"

CameraBone.name = "camera_Bone"

posCtrl = Position_Constraint()
CameraBone.position.controller = posCtrl
posCtrl.appendTarget $camera 100 

RotCtrl = Orientation_Constraint()
CameraBone.rotation.controller = RotCtrl
RotCtrl.appendTarget $camera 100 

CameraBone.wireColor = Red