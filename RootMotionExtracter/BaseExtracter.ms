ExposeCOM = Point() 
sliderTime = AnimationRange.start 
MovementBones = #($'Bip001',$'Bip001 Pelvis')

for i in MovementBones do 
(
    if i.modifiers.count > 0  do 
    (
        i.modifiers[1].enabled = false 
    )
)

BaseOrigin = $Root.transform 
set Animate On 
for i = AnimationRange.start to AnimationRange.end do 
(
    sliderTime = i 
    ExposeCOM.transform = $Bip001.transform 
)
sliderTime = AnimationRange.start


deleteKeys $Root.children[1].controller #allKeys

numLayersCOM = biped.numLayers $Bip001.controller
if numLayersCOM != 0 then 
(
	biped.createLayer $Bip001.controller (numLayersCOM+1) "BaseExtracter"
)
else 
(
	biped.createLayer $Bip001.controller 1 "BaseExtracter"
)

for i = AnimationRange.start to AnimationRange.end do 
(
    sliderTime = i 
    $Bip001.transform = ExposeCOM.transform 
)

Set Animate Off


for i in MovementBones do 
(
    if i.modifiers.count > 0  do 
    (
        i.modifiers[1].enabled = true 
    )
)