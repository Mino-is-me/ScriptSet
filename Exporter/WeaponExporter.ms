Try(DestroyDialog 'MultiWeaponExporter')
Catch()

exportName = ""

Rollout 'MultiWeaponExporter' "Multi Weapon Exporter"
(
    button 'btn_selectweaponMeshes' "Press After Select Weapon Meshes"
    multilistbox 'mlb_weaponList' "Weapons : " height:5 width:230
    button 'btn_exportMultiWeapons' "Export"

    on 'btn_selectweaponMeshes' pressed do 
    (
        A = for i in selection collect i.name 
        mlb_weaponList.items = A
    )


    on btn_exportMultiWeapons pressed do 
    (
        if MultiWeaponExporter.mlb_weaponList.items.count > 0 then 
        (
            for i in MultiWeaponExporter.mlb_weaponList.items do 
            (
                local validedNode = getNodeByName i 
                local SkinnedBones = getSkinBone validedNode

                for nodes in SkinnedBones do 
                (
                    if nodes.parent.name == "Weapon_Root" do 
                    (
                        select nodes.parent 
                        exportName = (substituteString maxFileName ".max" "") + "_" + nodes.name 
                    )
                )

                weaponRoot = $
                weaponRoot.parent = undefined
                weaponRoot.position.controller = Position_XYZ()
                weaponRoot.rotation.controller = Euler_XYZ()
                weaponRoot.transform = $Root.transform 

                select (grabchildren weaponRoot)
                selectMore validedNode

                exportDir = BatchDir + "\\" + exportName + ".fbx"

                animationExportSetUp (frameRate as float) exportWithMorph

                validMorphers = for i in $* where ( (classof i.modifiers[2]) == Morpher ) collect i 
                for i in validMorphers do
                (
                    basedMorpher = i.modifiers[2]
                    addModifier i basedMorpher 
                    deleteModifier i 3
                    --morphShuffle = true 
                )

                exportFile exportDir #noPrompt selectedOnly:True using:FBXEXPORTER  
            )
            
        )
    )
)
CreateDialog 'MultiWeaponExporter' 250 150




