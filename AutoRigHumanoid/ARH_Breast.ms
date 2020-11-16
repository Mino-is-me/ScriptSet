--Dm R Breast A
RBreastA = Point()
RBreastA.name = "Dm R Breast A"
RBreastA.parent = $'Ab R Trap'
RBreastA.pos =(RBreastA.parent.transform.pos + $'Bip001 Spine2'.transform.pos) / 2
RBreastA.pos = RBreastA.pos + [0,0,2]
for i=1 to (getPropNames RBreastA).count do
(
    setProperty RBreastA (getPropNames RBreastA)[i] #(5.0, false, false, false, true, false, false)[i]
)
rotate RBreastA (angleaxis -90 [0,0,1])

--Dm R Breast B
RBreastB = Point()
RBreastB.name = "Dm R Breast B"
RBreastB.parent = $'Bip001 Spine2'
RBreastB.pos = (RBreastA.parent.transform.pos + $'Bip001 Spine2'.transform.pos) / 2
for i=1 to (getPropNames RBreastB).count do
(
    setProperty RBreastB (getPropNames RBreastB)[i] #(5.0, false, false, false, true, false, false)[i]
)
rotate RBreastB (angleaxis -90 [0,0,1])

--Dm R Breast 

RBreast = Point()

RBreast.name = "Dm R Breast"
RBreast.parent = $'Bip001 Spine2'
RBreast.position.controller = Position_Constraint()
RBreast.position.controller.appendTarget $'Dm R Breast A' 50.0
RBreast.position.controller.appendTarget $'Dm R Breast B' 50.0
rotate RBreast (angleaxis -90 [0,0,1])


--Ab R Breast
RBreastc = bonesys.createBone [0,0,1] [0,0,0] [1,0,0]
RBreastc.name = "Ab R Breast"
RBreastc.parent = $'Dm R Breast'
RBreastc.transform = RBreastc.parent.transform 
for i=1 to (getPropNames RBreastc).count do
(
    setProperty RBreastc (getPropNames RBreastc)[i] #(2.0, 2.0, 20.0, 8.59027, true, 2.0, 10.0, 10.0, true, 2.0, 10.0, 10.0, false, 2.0, 10.0, 10.0, false)[i]
)


------------------------------------------------------------------------------------------------

--Dm L Breast A
LBreastA = Point()
LBreastA.name = "Dm L Breast A"
LBreastA.parent = $'Ab L Trap'
LBreastA.pos =(LBreastA.parent.transform.pos + $'Bip001 Spine2'.transform.pos) / 2
LBreastA.pos = LBreastA.pos + [0,0,2]
for i=1 to (getPropNames LBreastA).count do
(
    setProperty LBreastA (getPropNames LBreastA)[i] #(5.0, false, false, false, true, false, false)[i]
)
rotate LBreastA (angleaxis -90 [0,0,1])

--Dm L Breast B
LBreastB = Point()
LBreastB.name = "Dm L Breast B"
LBreastB.parent = $'Bip001 Spine2'
LBreastB.pos = (LBreastA.parent.transform.pos + $'Bip001 Spine2'.transform.pos) / 2
for i=1 to (getPropNames LBreastB).count do
(
    setProperty LBreastB (getPropNames LBreastB)[i] #(5.0, false, false, false, true, false, false)[i]
)
rotate LBreastB (angleaxis -90 [0,0,1])

--Dm L Breast 

LBreast = Point()

LBreast.name = "Dm L Breast"
LBreast.parent = $'Bip001 Spine2'
LBreast.position.controller = Position_Constraint()
LBreast.position.controller.appendTarget $'Dm L Breast A' 50.0
LBreast.position.controller.appendTarget $'Dm L Breast B' 50.0
rotate LBreast (angleaxis -90 [0,0,1])


--Ab L Breast
LBreastc = bonesys.createBone [0,0,1] [0,0,0] [1,0,0]
LBreastc.name = "Ab L Breast"
LBreastc.parent = $'Dm L Breast'
LBreastc.transform = LBreastc.parent.transform 
for i=1 to (getPropNames LBreastc).count do
(
    setProperty LBreastc (getPropNames LBreastc)[i] #(2.0, 2.0, 20.0, 8.59027, true, 2.0, 10.0, 10.0, true, 2.0, 10.0, 10.0, false, 2.0, 10.0, 10.0, false)[i]
)

