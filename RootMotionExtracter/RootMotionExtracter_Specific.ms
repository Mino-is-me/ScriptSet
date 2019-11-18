quat1 = biped.getTransform $Bip001 #rotation
quat2 = quat 180 [0,0,1]
quat3 = quat1 * quat2 

biped.setTransform $Bip001 #rotation quat3 false 



arFrames = #(24,46,114,138,160,182)


Animate on 
(

	for i=0 to 217 do 
	(
		SliderTime = i 
		$Root_Sub.transform = $Root.transform
		Biped.setTransform $Bip001 #pos Exposer.transform.pos true 
	)
)

COMExposer = Dummy() 
Animate on 
(
	for i=0 to 217 do 
	(
		sliderTime = i 
		COM.transform = $Bip001.transform 
	)
)


COM = Point()
COM.name = "COMExposer"



Animate on 
(
	for i=0 to 217 do 
	(
		SliderTime = i 
		$Bip001.transform = COM.transform 
	)
)