/*
for i in selection do 
(
    if findString i.name "_L" != undefined then
        i.name = substituteString i.name "_L" "Left"
    else findString i.name "_R" != undefined then 
        i.name = substituteString i.name "_R" "Right"
)
*/
for i in selection do 
(
    bisRight = findString i.name "_R"
    bisLeft = findstring i.name "_L"

    if bisRight != undefined then
        isRight = True 
    else 
        isRight = False 

    if bisLeft != undefined then
        isLeft = True
    else 
        isLeft = False 

    print isRight 
    print isLeft
    if isRight And Not isLeft then 
        i.name = substituteString i.name "_R" "Right"
    else if isLeft And Not isRight then
        i.name = substituteString i.name "_L" "Left"
)
