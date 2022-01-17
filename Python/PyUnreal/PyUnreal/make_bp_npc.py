import unreal 
#import re



ar_asset_lists = []
ar_asset_lists = unreal.EditorUtilityLibrary.get_selected_assets() 

print (ar_asset_lists[0])

str_selected_asset = ''

if len(ar_asset_lists) > 0 :

    str_selected_asset = unreal.EditorAssetLibrary.get_path_name_for_loaded_asset(ar_asset_lists[0])
    #str_selected_asset = str(ar_asset_lists[0])
    #print(str_selected_asset)
    path = str_selected_asset.rsplit('/', 1)[0] + '/'
    name = str_selected_asset.rsplit('/', 1)[1]
    name = name.rsplit('.', 1)[1]


BaseBP = '/Game/Art/Character/NPC/CH_NPC_Core/Blueprints/CH_NPC_Core_Blueprint'
BaseAnimBP = '/Game/Art/Character/NPC/CH_NPC_Core/Blueprints/CH_NPC_Core_AnimBP'

Basepath = path
assetPath = Basepath + '/Animation/BlendSpace/' 
#bsNames = ["IdleRun_BS_Peaceful", "IdleRun_BS_Battle", "Down_BS", "Groggy_BS", "LockOn_BS", "Airborne_BS"]
#animNames = ['Result_State_KnockDown_L'] #애니메이션 리스트 지정 
#Base1D = Basepath + "Base_BS_1D"
#Base2D = Basepath + "Base_BS_2D"

#공용 BlendSample 제작 
#defaultSamplingVector = unreal.Vector(0.0, 0.0, 0.0)
#defaultSampler = unreal.BlendSample()
#defaultSampler.set_editor_property("sample_value",defaultSamplingVector)


#for i in bsNames:
#    bsDir = assetPath + i
#    #2D BS로 제작해야할 경우 / LockOn_BS
#    if i == "LockOn_BS":
#        unreal.EditorAssetLibrary.duplicate_asset(Base2D,bsDir)
#    else:
#        BSLoaded = unreal.EditorAssetLibrary.duplicate_asset(Base1D,bsDir)
        
'''BP setting start'''

BPPath = Basepath + '/Blueprints/' + name + "_Blueprint"
AnimBPPath = Basepath + '/Blueprints/' + name + "_AnimBP"

SkeletonPath = Basepath + name + "_Skeleton"
Skeleton = ar_asset_lists[0].skeleton

asset_bp = unreal.EditorAssetLibrary.duplicate_asset(BaseBP,BPPath)
AnimBP = unreal.EditorAssetLibrary.duplicate_asset(BaseAnimBP,AnimBPPath)
AnimBP.set_editor_property("target_skeleton", Skeleton)
# '''BP setting end'''