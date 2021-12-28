--Create Morph Data from Base Mesh's skin data 
--Script by Minomi 2021.01.28 
/* Global Variables*/
global points = #()

fn getNumMorpher Base = -- count number of morph targets
(
    local morphModi = Base.Morpher

    for i=1 to 100 do 
    (
        local isValidMorphName = WM3_MC_GetName morphModi i
        if isValidMorphName == "- empty -" then exit with return (i-1)

    )

)


try(DestroyDialog rlt_ABS) catch()
rollout rlt_ABS "Morph Maker"
(
    
    editText edt_BaseMesh "Base Mesh Name : "
    label lb1 "Base Mesh Must Have a Morph Modifier"
    editText edt_DeformMesh "Mesh Name for Deform : "
    label lb2 "Deform Mesh Must be an Editable Poly/Mesh "
    Button btn_Execute "Execute"

    on btn_Execute pressed do 
    (
        BaseNode = (getNodebyName rlt_ABS.edt_BaseMesh.text)
        DeformNode = (getNodebyName rlt_ABS.edt_DeformMesh.text)

        numBaseVert = polyOp.getNumVerts BaseNode 

        Rands = #()
        for i=1 to 10 do 
        (
            local rVal = Random 1 numBaseVert
            append Rands rVal
        )

        select BaseNode 
        
        morphcnt = getNumMorpher $
        morphstack = $.morpher
        /*
        for i=1 to Rands.count do 
        (
            local vertexPoint = Point()
            vertexPoint.size = 1.0
            vertexPoint.pos.controller = position_script()
            vertexPoint.pos.controller.script = ("dependsOn "+"$"+$.name+"\n"+"PolyOp.getVert "+"$"+$.name+" "+(Rands[i] as string))
            append points vertexPoint 
        )

        select DeformNode 
        addModifier DeformNode (Skin ())
        for i in points do 
        (
            skinOps.addbone $.skin i 1
        )
        */

        undo on
        (
            with animate on 
            (
                for i=1 to morphcnt do 
                (
                    sliderTime = i 
                    (
                        for j=1 to morphcnt do 
                        (
                            if i == j then
                            (
                                WM3_MC_SetValue morphStack j 100.0 
                                --morphName = WM3_MC_GetName morphStack j

                            )
                            else 
                            (
                                WM3_MC_SetValue morphStack j 0.0

                            )
                        )
                    )
                    local copied = copy DeformNode 
                    copied.name = WM3_MC_GetName morphStack i
                    select copied 
                    macros.run "Modifier Stack" "Convert_to_Poly"
                    $.pos = [20*i,0,0]
                    deleteKeys $
                )
            )
        )

        sliderTime = 0f
    )
)
CreateDialog rlt_ABS 500 140