ExposeCOM = Point() 
sliderTime = AnimationRange.start 

BaseOrigin = $Root.transform 
set Animate On 
for i = AnimationRange.start to AnimationRange.end do 
(
    sliderTime = i 
    ExposeCOM.transform = $Bip001.transform 
)
sliderTime = AnimationRange.start
deleteKeys $Base.controller #allKeys

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