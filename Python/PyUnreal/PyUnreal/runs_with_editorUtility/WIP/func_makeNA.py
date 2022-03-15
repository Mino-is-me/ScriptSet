import unreal 


# '''BP setting end'''

def make_NA(index): 
    num = index
    BaseBP = '/Game/Art/Character/Monster/CH_D_NA_Core/CH_M_NA_Core_BP'
    BaseAnimBP = '/Game/Art/Character/Monster/CH_D_NA_Core/CH_M_NA_Core_AnimBP'

    Basepath = '/Game/Art/Character/Monster/CH_M_NA_' + str(num) + '/'
    assetPath = Basepath + '/Animation/BlendSpace/' 
    bsNames = ["IdleRun_BS_Peaceful", "IdleRun_BS_Battle", "Down_BS", "Groggy_BS", "LockOn_BS", "Airborne_BS"]
    #animNames = ['Result_State_KnockDown_L'] #애니메이션 리스트 지정 
    Base1D = Basepath + "Base_BS_1D"
    Base2D = Basepath + "Base_BS_2D"

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
            
    '''BP setting start'''

    BPPath = Basepath + '/Blueprints/' +  "CH_M_NA_" + str(num) + "_Blueprint"
    AnimBPPath = Basepath + '/Blueprints/' + "CH_M_NA_" + str(num) + "_AnimBP"

    SkeletonPath = Basepath + "CH_M_NA_" + str(num) + "_Skeleton"
    Skeleton = unreal.EditorAssetLibrary.load_asset(SkeletonPath)

    unreal.EditorAssetLibrary.duplicate_asset(BaseBP,BPPath)
    AnimBP = unreal.EditorAssetLibrary.duplicate_asset(BaseAnimBP,AnimBPPath)
    AnimBP.set_editor_property("target_skeleton", Skeleton)
