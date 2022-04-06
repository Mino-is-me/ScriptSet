#from typing_extensions import Self
from typing_extensions import Self
import unreal

class wrapped_sb_bp :

    dir         :str 
    bp_class    :object
    loaded_bp   :object
    name        :str

    def get_selected_asset_dir() -> str :
        selected_asset = unreal.EditorUtilityLibrary.get_selected_assets()[0]
        str_selected_asset = unreal.EditorAssetLibrary.get_path_name_for_loaded_asset(selected_asset)
        path = str_selected_asset.rsplit('/', 1)[0]
        return path

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

    def get_bp_comp_by_name (__bp_c: str, __seek: str) : 
        #source_mesh = ue.load_asset(__mesh_dir)
        loaded_bp_c = unreal.EditorAssetLibrary.load_blueprint_class(__bp_c)
        bp_c_obj = unreal.get_default_object(loaded_bp_c)
        loaded_comp = bp_c_obj.get_editor_property(__seek)
        return loaded_comp
