from array import array
import unreal 

_num_lod : int = 3 
#default -> create 3 LODs 

selected : array = unreal.EditorUtilityLibrary.get_selected_assets()

for each in selected :
    each.regenerate_lod(_num_lod, True)
