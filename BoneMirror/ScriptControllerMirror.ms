include "\\\\10.220.70.12\\eve\\ART_Backup\\Script\\Library\\stella.ms"
--Stella Library Include--

arPosValueName = #()
arPosValueVar = #() 

arRotValueName = #() 
arRotValueVar = #() 

arScaleValueName = #() 
arScaleValueVar = #() 

isPosScript = isKindOf $.position.controller position_Script 
if isPosScript == true do 
(
	PosScript = $.position.controller.Script
	posNumVar = $.position.controller.NumVariables() 
	for i=5 to posNumVar do 
	(
		local valueName = $.position.controller.getName i 
		local valueVar = $.position.controller.getValue valueName  
		append arPosValueName valueName 
		append arPosValueVar valueVar 
	)
)

isRotScript = isKindOf $.Rotation.controller rotation_script
if isRotScript == true do 
(
    RotScript = $.Rotation.controller.Script 
    RotNumVar = $.Rotation.controller.NumVariables()
    for i=5 to RotNumVar do 
    (
        local valueName = $.Rotation.controller.getName i 
        local valueVar = $.Rotation.controller.getValue valueName
        append arRotValueName valueName
        append arRotValueVar valueVar 
    )
)

isScaleScript = isKindOf $.scale.controller scale_script
if isScaleScript == true  do 
(
    scaleScript = $.scale.controller.script 
    scaleNumVar = $.scale.controller.NumVariables()
    for i=5 to scaleNumVar do 
    (
        local valueName = $.scale.controller.getName i 
        local valueVar = $.scale.controller.getValue valueName
        append arScaleValueName valueName
        append arScaleValueVar valueVar 
    )
) 

for i=1 to arPosValueVar.count do 
(
	if ( isKindof arPosValueVar[i] Node ) == true do 
	(
		arPosValueVar[i] = getNodeByName (makePastedBoneName arPosValueVar[i].name)
	)
)

for i=1 to arRotValueVar.count do 
(
	if ( isKindOf arRotValueVar[i] Node ) == true do 
	(
		arRotValueVar[i] = getNodeByName (makePastedBoneName arRotValueVar[i].name)
	)
)

for i=1 to arScaleValueVar.count do 
(
	if ( isKindOf arScaleValueVar[i] Node ) == true do 
	(
		arScaleValueVar[i] = getNodeByName (makePastedBoneName arScaleValueVar[i].name)
	)
)



oppositeRiggedBone = makePastedBoneName $.name 
select (getNodeByName oppositeRiggedBone)

if isPosScript == true do 
(
	$.position.controller = position_script()
	for i=1 to arPosValueName.count do 
	(
		$.position.controller.addConstant arPosValueName[i] arPosValueVar[i]
    )
    $.position.controller.script = PosScript
)

if isRotScript == true do 
(
	$.Rotation.Controller = Rotation_Script()
    for i=1 to arRotValueName.count do 
    (
        $.rotation.controller.addConstant arRotValueName[i] arRotValueVar[i]
    )
    $.rotation.controller.script = RotScript 
)

if isScaleScript == true do 
(
    $.Scale.Controller = scale_script() 

    for i=1 to arScaleValueName.count do 
    (
        $.scale.controller.addConstant arScaleValueName[i] arScaleValueVar[i]
    )
    $.scale.controller.script = ScaleScript
)