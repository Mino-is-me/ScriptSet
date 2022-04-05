import gc
import unreal 
import sys

__lo_d_level :str

_num_lod : int  = int(__lo_d_level)  # Binded value from Widget UI
selected : list = unreal.EditorUtilityLibrary.get_selected_assets() #get selected assets using editorUtilityLib

def skeletal_mesh_lod_builder ( __num_lod : int, __asssets : list ) -> bool :  
    for each in __asssets :
        each.regenerate_lod(__num_lod, True)
    return True  
    #return TRUE if this has been run successfully 

def static_mesh_lod_builder ( __num_lod : int, __asssets : list ) -> bool :  
    for each in __asssets :
        #unreal.EditorStaticMeshLibrary(each, )
        pass

skeletal_mesh_lod_builder( _num_lod, selected )


#Memory Free here 
del selected 
del _num_lod
