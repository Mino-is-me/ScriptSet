wpRootTM = $Weapon_Root.transform 
tempDM = dummy()

$Point003.parent = tempDM 

tempDM.rotation = (eulerAngles 90 0 -90)


$Weapon_Root.rotation = (EulerAngles 0 0 0)

$Point003.parent = $Weapon_Root


delete tempDM