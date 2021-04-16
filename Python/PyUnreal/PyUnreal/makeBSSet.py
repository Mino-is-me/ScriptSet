import unreal 
assetPath = "/Game/Art/Character/Monster/CH_M_NA_23/Animation/BlendSpace/" 
bsNames = ["IdleRun_BS_Peaceful", "IdleRun_BS_Battle", "Down_BS", "Groggy_BS", "LieDown_BS", "LockOn_BS", "Airborne_BS"]
#animNames = ['Result_State_KnockDown_L'] #애니메이션 리스트 지정 
Base1D = assetPath + "Base_BS_1D"
Base2D = assetPath + "Base_BS_2D"


#공용 BlendSample 제작 
defaultSamplingVector = unreal.Vector(0.0, 0.0, 0.0)
defaultSampler = unreal.BlendSample()
defaultSampler.set_editor_property("sample_value",defaultSamplingVector)


for i in bsNames:
    bsDir = assetPath + i
    #2D BS로 제작해야할 경우 / LockOn_BS
    if i == "LockOn_BS":
        unreal.EditorAssetLibrary.duplicate_asset(Base2D,bsDir)
    else:
        BSLoaded = unreal.EditorAssetLibrary.duplicate_asset(Base1D,bsDir)


        

'''
testAssetLoaded = assetPath + bsNames[3]
BsLoaded = unreal.EditorAssetLibrary.load_asset(testAssetLoaded)

ASequence1 = unreal.EditorAssetLibrary.load_asset('/Game/Art/Character/Monster/CH_M_NA_23/Animation/Result_State_KnockDown_L')



defaultSamplingVector = unreal.Vector(0.0, 0.0, 0.0)
defaultSampler = unreal.BlendSample()


defaultSampler.set_editor_property("sample_value",defaultSamplingVector)
defaultSampler.set_editor_property("animation",ASequence1)

BsLoaded.set_editor_property("sample_data",[defaultSampler])
'''
