 this = getFilenamePath (getThisScriptFilename() )
for i in selection do 
(
    posc = i.pos.controller 
    rotc = i.rotation.controller
    sclc = i.scale.controller 

    isPosScript = iskindof posc position_script
    if isPosScript == true do 
    (
        posScript = posc.script 
        numPosVari = posc.NumVariables()
        --arPosVaris=#()
        for j=5 to numPosVari do 
        (
            local varName = posc.GetName j
            local varVal = posc.GetVarValue varName 
            isNode = isKindof varVal node
            if isNode == true then 
            (
                varValName = substituteString varVal.name " " "_"
                posScript = substituteString posScript varName varValName
            )
            else 
            (
                posScript = substituteString posScript varName (varVal as string)
            )
        )
    )
    /*
    if rotc == rotation_script do 
    (

    )
    if sclc == scale_script do 
    (

    )
    */
)

print posScript

--Test1 = filterString posScript " "

Test1