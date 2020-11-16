for i in selection do
(
	Controller = i
	BoneName = i.name

	isLeftController = findString BoneName "_L_"

	if isLeftController != undefined then
	(
		OppositeControllerName = substituteString BoneName "_L_" "_R_"
	)
	else 
	(
		OppositeControllerName = substituteString BoneName "_R_" "_L_"
	)

	OppositeController = (getNodeByName OppositeControllerName)

	OppositeController.position.x = Controller.position.x * -1
	OppositeController.position.y = Controller.position.y 
	OppositeController.position.z = Controller.position.z

	select OppositeController
)


