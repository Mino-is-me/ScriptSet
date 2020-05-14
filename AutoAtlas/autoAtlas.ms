for i in selection do 
(
    local iVertexCnt = i.verts.count

)

Global cSelected = selection as array 
Global aVerts = #()
for i=1 to cSelected.count do 
(
    local iVertexCnt = cSelected[i].verts.count 
    append aVerts iVertexCnt


)

format "Done"