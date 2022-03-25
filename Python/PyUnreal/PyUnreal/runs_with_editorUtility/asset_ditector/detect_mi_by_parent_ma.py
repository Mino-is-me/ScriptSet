import unreal
#import unreal module
from typing import List 
#import typing module for 'clearer' annotation 
##But, this is not Typescript though, :(

_seek_parent_material: unreal.Material
#pick from editor 

compare_class                           = unreal.MaterialInstanceConstant().get_class()

asset_lib: unreal.EditorAssetLibrary    = unreal.EditorAssetLibrary 
util_lib:  unreal.EditorUtilityLibrary  = unreal.EditorUtilityLibrary

selected_list : List[object] = util_lib.get_selected_assets()

for each in selected_list :
    classof = each.get_class()

    if classof == compare_class : 
        if each.parent == _seek_parent_material :
            need_to_print: str = each.get_name() + ' => parent of this material instance is ' + _seek_parent_material.get_name() + ' => OK '
            unreal.log(need_to_print)

        else :
            need_to_print: str = each.get_name() + ' => parent of this material instance is not ' + _seek_parent_material.get_name()
            unreal.log_warning(need_to_print)

    else :
        need_to_print: str = each.get_name() + ' => this is not MaterialInstanceConstant '
        unreal.log_error(need_to_print)

