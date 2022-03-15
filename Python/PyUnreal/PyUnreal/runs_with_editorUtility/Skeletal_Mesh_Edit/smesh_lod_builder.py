import unreal 

_num_lod : int = 3  #default -> create 3 LODs 
selected : list = unreal.EditorUtilityLibrary.get_selected_assets() #get selected assets using editorUtilityLib

def skeletal_mesh_lod_builder ( __num_lod : int, __asssets : list ) -> bool :  
    for each in __asssets :
        each.regenerate_lod(__num_lod, True)
    return True  
    #return TRUE if this has been run successfully 


skeletal_mesh_lod_builder( _num_lod, selected )