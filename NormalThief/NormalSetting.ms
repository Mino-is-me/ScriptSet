

fn makeSingleBitArray iNum =
(
    local ar = #()
    append ar iNum
    ar = ar as bitArray 
    return ar 
)

fn copyNormalValue iNum =
(
    $.modifiers[#Edit_Normals].EditNormalsMod.SetSelection #{}

    local bAr = makeSingleBitArray iNum

    $.modifiers[#Edit_Normals].EditNormalsMod.Select bAr
    $.modifiers[#Edit_Normals].EditNormalsMod.getNormal iNum
)

fn pasteNormalValue iNum =
(
    $.modifiers[#Edit_Normals].EditNormalsMod.SetSelection #{}

    local bAr = makeSingleBitArray iNum
    $.modifiers[#Edit_Normals].EditNormalsMod.Select bAr
    $.modifiers[#Edit_Normals].EditNormalsMod.setNormal iNum 
)

arOrigin = #(131,252,251,253,254,224,159,157,156,161,165,164,228,229,196,195,230,190,189,210,212,211,103,82,81,80,56,57,102,63,62,101,100,31,30,27,23,25,26,96,133,129,128,127)



arExtract =#(5541,11902,11903,11904,11905,11884,11827,11825,11823,11824,11841,11806,11807,11810,11872,11873,11874,11875,11890,11879,11876,11882,5511,5512,5506,5507,5525,5505,5504,5503,5502,5441,5439,5436,5471,5454,5453,5455,5457,5517,5545,5544,5543,5542)
arVectors = #()
fn tempfunc = 
(
    for i=1 to arOrigin.count do 
    (
        local v3 = $EVE_Head.modifiers[#Edit_Normals].EditNormalsMod.getNormal arOrigin[i]
        append arVectors v3
    )

    for i=1 to arExtract.count do 
    (
        $EVE_Basebody_N.modifiers[#Edit_Normals].EditNormalsMod.setNormal arExtract[i] arVectors[i]
    )
)

rollout vertexNoramlPaster "Vertex Normal Paster"
(
    Button 'btn_getNormalData' "Get Normal Data" --across:2
    Button 'btn_setNoramlData' "Set Normal Data"
    --BUtton 
)

createDialog vertexNoramlPaster