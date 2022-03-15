from array import array
import unreal 

_seek_comp_name : str = 'CapsuleComponent'
_seek_property_name : str = ''
selected : array = unreal.EditorUtilityLibrary.get_selected_assets()

def swap_bp_obj_to_bp_c ( __bp_list:list) -> list : 
    bp_c_list : list = []
    for each in __bp_list :
        name_selected : str = unreal.EditorAssetLibrary.get_path_name_for_loaded_asset(each)
        name_selected = name_selected + '_C'
        loaded_bp = unreal.EditorAssetLibrary.load_blueprint_class(name_selected)
        bp_c_obj = unreal.get_default_object(loaded_bp)
        bp_c_list.append(bp_c_obj)
    return bp_c_list 

def get_bp_comp_by_name (__bp_c, __seek: str) : 
    #loaded_bp_c = unreal.EditorAssetLibrary.load_blueprint_class(__bp_c)
    loaded_comp = __bp_c.get_editor_property(__seek)
    return loaded_comp

def change_comp_property (__comp, __seek : str , __val : any) :
    __comp.set_editor_property(__seek, __val)

def get_comp_property (__comp, __seek : str ) :
    __comp.get_editor_property(__seek)


## exectue from here 

converted = swap_bp_obj_to_bp_c(selected)

for each in converted :
    seeked_comp = get_bp_comp_by_name(each, _seek_comp_name)
    debugprint = seeked_comp.get_editor_property(_seek_property_name)
    print(debugprint)
