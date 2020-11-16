PointA=$

PointB = $

ss = splineShape pos:PointA.pos

addNewSpline ss

addknot ss 1 #corner #line PointA.pos

addKnot ss 1 #corner #line PointB.pos

updateShape ss
