Try 
(
    $Bip001_prop1.transform = (matrix3 [1.66893e-06,-0.0996767,-0.99502] [1,2.38419e-07,1.57952e-06] [0,-0.99502,0.0996767] [-33.6535,0.318159,89.4697])
    $'Bip001 Prop2'.transform = (matrix3 [0.383622,0.15621,-0.910183] [-0.036496,-0.982256,-0.183962] [-0.922769,0.10379,-0.371114] [33.6535,-0.26938,97.0986])
)
catch()


if isValidNode $'SC_WeaponConstraint' != true do 
(
    WPC = Dummy()
    WPC.parent = $Bip001_R_Hand 
    WPC.transform = (matrix3 [-0.601258,-0.270582,-0.751847] [-0.772422,-0.044084,0.633577] [-0.204579,0.961687,-0.182497] [-35.2338,-1.59015,92.1166])
    WPC.name = "SC_WeaponConstraint"
)

if isValidNode $'SC_BurstStanceConstraint' != true do 
(
    WPC2 = Dummy()
    WPC2.parnt = $Bip001_L_Hand 
    WPC2.transform  = (matrix3 [0.94881,0.0150124,0.31549] [0.286194,0.381689,-0.878867] [-0.133613,0.924169,0.357854] [33.9202,-11.5206,86.8161])
    WPC2.name = "SC_BurstStanceConstraint"
)
