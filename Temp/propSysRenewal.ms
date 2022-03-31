files = Exporter.mlb_FileNames.items


for each in files do (
    loadMaxFile each quiet:true

    nameWithoutType = getFilenameFile MaxFileName 
    saveName = MaxFilePath + nameWithoutType + "_baked.max"

    weaponXpose = dummy() 
    weaponXpose.name = "weaponXpose"
    weaponXpose.parent = $Root 

    with animate on (
        for i in animationRange.start to animationRange.end do (
            sliderTime = i 
            weaponXpose.transform = $'Bip001 Prop1'.transform 
        )
    )
    sliderTime = animationRange.start 

    saveMaxFile saveName quiet:true 
)



/* test code here */

