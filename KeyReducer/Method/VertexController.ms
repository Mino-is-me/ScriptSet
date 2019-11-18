-- fn callBack_moveByVerts =
-- (
--BaseVertPos = polyOp.getVert $Base 5
--TargetElementsParentPos = polyOp.getVert $Target 21


	
	
BaseVertPosL = [60.3871,-74.9846,119.008]
BaseVertPosR = [60.3871,84.4321,119.008]





VertPosL = polyOp.getVert $Base 6
VertPosR = polyOp.getVert $Base 8


VertPosL[1] = VertPosL[1] - BaseVertPosL[1]

VertPosL[2] = VertPosL[2] - BaseVertPosL[2]

VertPosL[3] = VertPosL[3] - BaseVertPosL[3]


VertPosR[1] = VertPosR[1] - BaseVertPosR[1]

VertPosR[2] = VertPosR[2] - BaseVertPosR[2]

VertPosR[3] = VertPosR[3] - BaseVertPosR[3]




for i=1 to 25 do
(
	polyOp.setVert $Target i ((polyOp.getVert $Target i ) - VertPosR)
)

for i=26 to 50 do
(
	polyOp.setVert $Target i ((PolyOp.getVert $Target i) - VertPosL)
)






OriginPos = $Root.pos  -- Root가 움직이면 움직인 값 만큼 버텍스 움직임에서 제해줘야 함.

BasePos1 = [-2.48189,-4.25783,2.74499]

Base1 = polyop.getVert $'166-42-i' 1649

Pos1 = Base1 - BasePos1 


for i= 961 to 975 do
(
	polyOp.setVert $'Object002' i((polyop.getVert $'Object002' i) + Pos1)
)1





OriginPos = $Root.pos  -- Root가 움직이면 움직인 값 만큼 버텍스 움직임에서 제해줘야 함.

BasePos1 = [-2.48189,-4.25783,2.74499]

Base1 = polyop.getVert $'166-42-i' 1649

Pos1 = Base1 - BasePos1 


for i= 961 to 975 do
(
	polyop.moveVert $'Object002' i Pos1 
)



polyop.getVertsUsingFace $ 469

