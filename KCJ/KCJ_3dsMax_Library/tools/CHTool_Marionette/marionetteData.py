#-*-coding: utf-8-*-
# FK형으로 바꾸는 모든 데이터

Data_SetList = [
    ('CircleBody Ctrl', 'Follow_World_Bip001', 100),
    ('LeftArm_SetCtrl', 'IKFK', 100),
    ('LeftSubArm_IKFKCtrl', 'IKFK', 100),

    ('LeftThumbIKFKCtrl', 'IKFK', 100),
    ('LeftIndexIKFKCtrl', 'IKFK', 100),
    ('LeftMiddleIKFKCtrl', 'IKFK', 100),
    ('LeftRingIKFKCtrl', 'IKFK', 100),
    ('LeftPinkyIKFKCtrl', 'IKFK', 100),

    ('R_Arm_IKFKCtrl', 'IKFK', 100),
    ('R_SubArm2_IKFKCtrl', 'IKFK', 100),
    ('R_SubArm_IKFKCtrl', 'IKFK', 100)

]

# frame, ctrl, target, targetMtx

Data_MatchingList = [

        ('R_Arm_1_FKCtrl', 'R_Arm_1_OutJnt'),
        ('R_Arm_2_FKCtrl', 'R_Arm_2_OutJnt'),
        ('R_Arm_3_FKCtrl', 'R_Arm_3_OutJnt'),

        ('R_SubArm2_1_FKCtrl', 'R_SubArm2_1_OutJnt'),
        ('R_SubArm2_2_FKCtrl', 'R_SubArm2_2_OutJnt'),
        ('R_SubArm2_3_FKCtrl', 'R_SubArm2_3_OutJnt'),

        ('R_SubArm_1_FKCtrl', 'R_SubArm_1_OutJnt'),
        ('R_SubArm_2_FKCtrl', 'R_SubArm_2_OutJnt'),
        ('R_SubArm_3_FKCtrl', 'R_SubArm_3_OutJnt'),

        ('CircleBody Ctrl', 'Bip001 CircleBody'),
        ('CircleString Ctrl', 'Bip001 CircleString'),
        ('Bip001 CircleMidCtrl', 'Bip001 CircleMid'),

        ('LeftArm_FK1Ctrl', 'LeftArm_Out1'),
        ('LeftArm_FK2Ctrl', 'LeftArm_Out2'),
        ('LeftArm_FK3Ctrl', 'LeftArm_Out3'),
        ('LeftArm_FK4Ctrl', 'LeftArm_Out4'),


        ('LeftThumb1FKCtrl', 'LeftThumb1OutJnt'),
        ('LeftThumb2FKCtrl', 'LeftThumb2OutJnt'),
        ('LeftThumb3FKCtrl', 'LeftThumb3OutJnt'),
        ('LeftThumb4FKCtrl', 'LeftThumb4OutJnt'),

        ('LeftIndex1FKCtrl', 'LeftIndex1OutJnt'),
        ('LeftIndex2FKCtrl', 'LeftIndex2OutJnt'),
        ('LeftIndex3FKCtrl', 'LeftIndex3OutJnt'),

        ('LeftMiddle1FKCtrl', 'LeftMiddle1OutJnt'),
        ('LeftMiddle2FKCtrl', 'LeftMiddle2OutJnt'),
        ('LeftMiddle3FKCtrl', 'LeftMiddle3OutJnt'),

        ('LeftRing1FKCtrl', 'LeftRing1OutJnt'),
        ('LeftRing2FKCtrl', 'LeftRing2OutJnt'),
        ('LeftRing3FKCtrl', 'LeftRing3OutJnt'),

        ('LeftPinky1FKCtrl', 'LeftPinky1OutJnt'),
        ('LeftPinky2FKCtrl', 'LeftPinky2OutJnt'),
        ('LeftPinky3FKCtrl', 'LeftPinky3OutJnt')
]