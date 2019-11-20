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
                varValName = substituteString varVal.name " " "-"
                posScript = substituteString posScript varName varValName
            )
            else 
            (
                posScript = substituteString posScript varName (varVal as string)
            )
        )
    )
    isRotSCript = isKindof rotc rotation_script
    if isRotSCript == true do 
    (
        rotScript = rotc.script 
        numRotVari = rotc.NumVariables()

        for j=5 to numRotVari do 
        (
            local varName = rotc.GetName j 
            local varVal = rotc.GetVarValue varName 
            isNode = isKindof varVal node 
            if isNode = true then 
            (
                varValName = substituteString varVal.name " " "-"
                rotScript = substituteString rotScript varName varValName
            )
            else 
            (
                rotScript = substituteString rotScript varName (varVal as string)
            )
        )
    )
    isScaleScript = isKindof sclc scale_script 
    if isScaleScript == true  do 
    (
        scaleScript = sclc.script 
        numScaleVari = sclc.NumVaribales()

        for j=5 to numSCaleVari do 
        (
            local varName = sclc.GetName j
            local varVal = sclc.GetVarValue varName 
            isNode = isKindof varVal node 
            if isNode = true then 
            (
                varValName = substituteString varVal.name " " "-"
                scaleScript = substituteString scaleScript varName varValName

            )
            else 
            (
                scaleScript = substituteString scaleScript varName (varVal as string)
            )
        )
    )
)
print (substituteString $.name " " "-")
print (substituteString $.parent.name " " "-")
print "<Position Script>"
print posScript
print "<Rotation Script>"
print rotScript 
print "<Scale Script>"
print scaleScript 
