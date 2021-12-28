cnt = 0
for i=animationRange.start to animationRange.end do
(
	cnt += 1

	EvenNumber = mod cnt 2

	if EvenNumber == 0.0 do
	(   
		deleteKey $.pos.controller  cnt 
		deleteKey $.rotation.controller cnt 
		deleteKey $.scale.controller cnt 

	) 
)

    
--sliderTime = animationRange.start 