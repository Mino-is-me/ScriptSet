# py automise script by Minomi 
## run with python 2.7 in UE4

#######################################import modules from here#######################################
import unreal 
#######################################import modules end#######################################



#######################################functions from here#######################################
def get_selected_asset_dir() -> str :
    ar_asset_lists = unreal.EditorUtilityLibrary.get_selected_assets() 

    if len(ar_asset_lists) > 0 :
        str_selected_asset = unreal.EditorAssetLibrary.get_path_name_for_loaded_asset(ar_asset_lists[0])
        path = str_selected_asset.rsplit('/', 1)[0]

    else : 
        path = '' 

    return path


def get_anim_list (__path: str) -> list :
    seq_list = unreal.EditorAssetLibrary.list_assets(__path, True, False)
    return seq_list


def check_animseq_by_name_in_list (__anim_name: str, __list: list ) -> str :
    for each in __list :
        name = each.rsplit('.', 1)[1]
        found_name = name.find(__anim_name)
        if found_name != -1 :
            break 
    return each


def set_bs_sample (__animation, __sample_value: list, __axis_x: float, __axis_y: float) : # returns [BlendSample] unreal native type 
    bs_sample = unreal.BlendSample()
    vec_sample = unreal.Vector(__axis_x, __axis_y, 0.0) #do not use 3D BlendSampleVector
    bs_sample.set_editor_property('animation', __animation)
    bs_sample.set_editor_property('sample_value', vec_sample)
    bs_sample.set_edtior_property('rate_scale', 1.0)
    bs_sample.set_editor_property('snap_to_grid', True)
    return bs_sample



def set_blendSample_to_bs (__blendspace, __blendsample) : #returns [BlendSpace] unreal loaded asset
    __blendspace.set_editor_property('sample_data', __blendsample)
    return 0

#######################################functions end#######################################


#######################################class from here######################################

class wrapedBlendSpaceSetting:

    custom_input: str = '/Animation' + ''
    bs_dir: str = '/Animation/BlendSpace' #blend space relative path 
    post_fix: str = '' #if variation

    bs_names: list = [
        "IdleRun_BS_Peaceful", 
        "IdleRun_BS_Battle", 
        "Down_BS", 
        "Groggy_BS", 
        "Airborne_BS",
        "LockOn_BS"
        ]

    seq_names: list = [
        '_Idle01',
        '_Walk_L',
        '_BattleIdle01',
        '_Run_L',
        '_KnockDown_L',
        '_Groggy_L',
        '_Airborne_L',
        '_Caution_Cw',
        '_Caution_Fw',
        '_Caution_Bw',
        '_Caution_Lw',
        '_Caution_Rw'
    ]

#######################################class end#######################################

#######################################run from here#######################################
wraped = wrapedBlendSpaceSetting
main_path = get_selected_asset_dir()

seek_anim_path = main_path + wraped.custom_input
bs_path = main_path + wraped.bs_dir

anim_list = get_anim_list(seek_anim_path)
name_list: list = []

for each in wraped.seq_names :
    anim_name = check_animseq_by_name_in_list(each, anim_list)
    name_list.append(anim_name)
    print(anim_name)



#######################################run end#######################################