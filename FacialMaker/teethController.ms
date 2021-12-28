TRY(destroyDialog teethController)
catch()


rollout teethController "Teeth Controller"
(
    spinner TeethUpperUp "Teeth Upper Up     " range:[0,100,0] type:#integer ticks:1 align:#left
	spinner TeethUpperDown "Teeth Upper Down" range:[0,100,0] type:#float ticks:1 align:#left
    button setKeyButton1 "Set Key" align:#left
	
    spinner TeethLowerUp "Teeth Lower Up     " range:[0,100,0] type:#integer ticks:1 align:#left
	spinner TeethLowerDown "Teeth Lower Down" range:[0,100,0] type:#float ticks:1 align:#left
    button setKeyButton2 "Set Key" align:#left
	
    button setZeroButton "Set 0 Value" 
	
    on TeethUpperUp changed val do 
    (
		$CH_P_EVE_Face_003.morpher[50].value = val 
	)
	on TeethUpperDown changed val do 
    (
		$CH_P_EVE_Face_003.morpher[51].value = val 
	)
	on TeethLowerUp changed val do 
    (
		$CH_P_EVE_Face_003.morpher[52].value = val 
	)
	on TeethLowerDown changed val do 
    (
		$CH_P_EVE_Face_003.morpher[53].value = val 
	)
	
    on setZeroButton pressed do 
    (
        teethController.TeethUpperUp.value = 0.0
        teethController.TeethUpperDown.value = 0.0
		teethController.TeethLowerUp.value = 0.0
        teethController.TeethLowerDown.value = 0.0
        $CH_P_EVE_Face_003.morpher[52].value = 0.0
        $CH_P_EVE_Face_003.morpher[53].value = 0.0
        $CH_P_EVE_Face_003.morpher[51].value = 0.0
        $CH_P_EVE_Face_003.morpher[50].value = 0.0
    )

    on setKeyButton1 pressed do 
    (
        undo on 
        (
            with Animate on 
            (
				$CH_P_EVE_Face_003.morpher[50].value = teethController.TeethUpperUp.value 
				$CH_P_EVE_Face_003.morpher[51].value = teethController.TeethUpperDown.value

            )   
        )
    )
    on setKeyButton2 pressed do 
    (
        undo on 
        (
            with Animate on 
            (
				$CH_P_EVE_Face_003.morpher[52].value = teethController.TeethLowerUp.value 
				$CH_P_EVE_Face_003.morpher[53].value = teethController.TeethLowerDown.value
            )   
        )
    )
)
createDialog teethController 200 170