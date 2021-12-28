/*objs = #()
append objs $'Bip001 Spine1_1'
append objs $'Bip001 Spine1'
append objs $'Scale_L1_Bone_03'
append objs $'Scale_L1_Bone_02'
append objs $'Scale_L1_Bone_01'
append objs $'Scale_L2_Bone_03'
append objs $'Scale_L2_Bone_02'
append objs $'Scale_L2_Bone_01'
append objs $'Scale_L3_Bone_03'
append objs $'Scale_L3_Bone_02'
append objs $'Scale_L3_Bone_01'
append objs $'Scale_R3_Bone_03'
append objs $'Scale_R3_Bone_02'
append objs $'Scale_R3_Bone_01'
append objs $'Scale_R1_Bone_03'
append objs $'Scale_R1_Bone_02'
append objs $'Scale_R1_Bone_01'
append objs $'Scale_R2_Bone_03'
append objs $'Scale_R2_Bone_02'
append objs $'Scale_R2_Bone_01'
append objs $'Bone_Joint_R2'
append objs $'Bone_Joint_R3'
append objs $'Bone_Joint_L3'
append objs $'Bone_Joint_L1'
append objs $'Bone_Joint_R1'
append objs $'Bone_Joint_L2'*/

for i in $* do 
(
    if i.scale.controller.keys.count != 0 do 
    (
        if i.parent.scale.controller.keys.count == 0 do 
        (
            selectMore i 
        )
    )
)
objs = selection as array 