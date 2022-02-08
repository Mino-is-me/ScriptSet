#Discription
##Python 3.7 with UE4.26 Python Module by Minomi
###함수 사용시 import 방식이 아닌 복사해서 사용하는게 더 정신건강에 이롭습니다.


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


def set_bs_sample (__animation, __axis_x: float, __axis_y: float) : # returns [BlendSample] unreal native type 
    bs_sample = unreal.BlendSample()
    vec_sample = unreal.Vector(__axis_x, __axis_y, 0.0) #do not use 3D BlendSampleVector
    bs_sample.set_editor_property('animation', __animation)
    bs_sample.set_editor_property('sample_value', vec_sample)
    bs_sample.set_editor_property('rate_scale', 1.0)
    bs_sample.set_editor_property('snap_to_grid', True)
    return bs_sample



def set_blendSample_to_bs (__blendspace, __blendsample) : #returns [BlendSpace] unreal loaded asset
    __blendspace.set_editor_property('sample_data', __blendsample)
    return 0


def get_bp_c_by_name(__bp_dir:str):
    __bp_c = __bp_dir + '_C' 
    return __bp_c 

def get_bp_mesh_comp_by_name (__bp_c:str, __seek_comp_name:str) : 
    loaded_bp_c = unreal.EditorAssetLibrary.load_blueprint_class(__bp_c)
    bp_c_obj = unreal.get_default_object(loaded_bp_c)
    loaded_comp = bp_c_obj.get_editor_property(__seek_comp_name)
    return loaded_comp
    #인풋으로 받는 __bp_c 아규먼트 '/direc/*_Bluperint.*_Blueprint_c' << 와 같은 포맷으로 받아야함
    ##asset_path를 str로 끌어왔을 경우 상단의 get_bp_c_by_name 함수 이용하여 class로 한번 더 래핑해주세요.
    ###__seek_comp_name 아규먼트 동작 안하면 아래의 함수를 사용하세요.


def get_bp_instance (__bp_c:str) :
    loaded_bp_c = unreal.EditorAssetLibrary.load_blueprint_class(__bp_c)
    bp_c_obj = unreal.get_default_object(loaded_bp_c)
    return bp_c_obj
    #Object화된 Blueprint instance를 반환
    #컴포넌트는 반환된 bp_c_obj.get_editor_property('찾고자 하는 컴포넌트 이름')으로 끌어다 쓰세요.

# BP 컴포넌트 접근 순서
## 블루프린트 클래스 로드
### 디폴트 오브젝트 로드
#### 컴포넌트 로드 (get_editor_property)



#######################################functions end#######################################


#######################################class from here######################################

class wrapedBlendSpaceSetting:

   
    bs_dir: str = '/Animation/BlendSpace' #blend space relative path 
    post_fix: str = '' #edit this if variation
    pre_fix: str = '' #edit this if variation
    custom_input: str = pre_fix + '/Animation' + post_fix

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
