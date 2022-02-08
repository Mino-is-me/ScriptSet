import unreal 
#import re

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
'''BP setting start'''

BPPath = Basepath + '/Blueprints/' + name + "_Blueprint"
AnimBPPath = Basepath + '/Blueprints/' + name + "_AnimBP"

#SkeletonPath = Basepath + name + "_Skeleton"
Skeleton = ar_asset_lists[0].skeleton

asset_bp = unreal.EditorAssetLibrary.duplicate_asset(BaseBP,BPPath)
AnimBP = unreal.EditorAssetLibrary.duplicate_asset(BaseAnimBP,AnimBPPath)
AnimBP.set_editor_property("target_skeleton", Skeleton)

# BPPath_C = get_bp_c_by_name(BPPath)
# BP_mesh_comp = get_bp_mesh_comp_by_name(BPPath_C, 'Mesh')

# BP_mesh_comp.set_editor_property('skeletal_mesh',ar_asset_lists[0])
# BP_mesh_comp.set_editor_property('anim_class', loaded_a)
# '''BP setting end'''

# BP Component Setting Start #
_bp_ = unreal.EditorAssetLibrary.get_path_name_for_loaded_asset(asset_bp)
_abp_ = unreal.EditorAssetLibrary.get_path_name_for_loaded_asset(AnimBP)

_bp_c = get_bp_c_by_name(_bp_) 
_abp_c = get_bp_c_by_name(_abp_)

loaded_abp = unreal.EditorAssetLibrary.load_blueprint_class(_abp_c)
bp_mesh_comp = get_bp_mesh_comp(_bp_c)

bp_mesh_comp.set_editor_property('skeletal_mesh',ar_asset_lists[0])
bp_mesh_comp.set_editor_property('anim_class', loaded_abp)

# BP Component Setting End #