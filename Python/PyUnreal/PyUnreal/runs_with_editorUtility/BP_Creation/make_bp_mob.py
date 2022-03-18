import unreal 
import re

def get_bp_c_by_name(__bp_dir:str):
    __bp_c = __bp_dir + '_C' 
    return __bp_c 

def get_bp_mesh_comp (__bp_c:str) :
    #source_mesh = ue.load_asset(__mesh_dir)
    loaded_bp_c = unreal.EditorAssetLibrary.load_blueprint_class(__bp_c)
    bp_c_obj = unreal.get_default_object(loaded_bp_c)
    loaded_comp = bp_c_obj.get_editor_property('Mesh')
    return loaded_comp




ar_asset_lists = []
ar_asset_lists = unreal.EditorUtilityLibrary.get_selected_assets() 

SkeletalMesh = ar_asset_lists[0]

print (ar_asset_lists[0])

str_selected_asset = ''

if len(ar_asset_lists) > 0 :

    str_selected_asset = unreal.EditorAssetLibrary.get_path_name_for_loaded_asset(ar_asset_lists[0])
    #str_selected_asset = str(ar_asset_lists[0])
    print(str_selected_asset)
    ar_numbers = re.findall("\d+", str_selected_asset)
    i_number = ar_numbers[0]
    print(ar_numbers)
    print(i_number)

num = int(i_number)

BaseBP      = '/Game/Art/Character/Monster/CH_D_NA_Core/CH_M_NA_Core_BP'
BaseAnimBP  = '/Game/Art/Character/Monster/CH_D_NA_Core/CH_M_NA_Core_AnimBP'

Basepath    = '/Game/Art/Character/Monster/CH_M_NA_' + str(num) + '/'
assetPath   = Basepath + '/Animation/BlendSpace/' 
bsNames     = ["IdleRun_BS_Peaceful", "IdleRun_BS_Battle", "Down_BS", "Groggy_BS", "LockOn_BS", "Airborne_BS"]
#animNames = ['Result_State_KnockDown_L'] #애니메이션 리스트 지정 
Base1D      = Basepath + "Base_BS_1D"
Base2D      = Basepath + "Base_BS_2D"

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
Skeleton     = unreal.EditorAssetLibrary.load_asset(SkeletonPath)

asset_bp     = unreal.EditorAssetLibrary.duplicate_asset(BaseBP,BPPath)
AnimBP       = unreal.EditorAssetLibrary.duplicate_asset(BaseAnimBP,AnimBPPath)

AnimBP.set_editor_property("target_skeleton", Skeleton)

#BP Component Set
_bp_    = unreal.EditorAssetLibrary.get_path_name_for_loaded_asset(asset_bp)
_abp_   = unreal.EditorAssetLibrary.get_path_name_for_loaded_asset(AnimBP)

_bp_c  = get_bp_c_by_name(_bp_) 
_abp_c = get_bp_c_by_name(_abp_)

loaded_abp   = unreal.EditorAssetLibrary.load_blueprint_class(_abp_c)
bp_mesh_comp = get_bp_mesh_comp(_bp_c)

bp_mesh_comp.set_editor_property('skeletal_mesh',ar_asset_lists[0])
bp_mesh_comp.set_editor_property('anim_class', loaded_abp)