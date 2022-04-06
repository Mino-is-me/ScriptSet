import unreal 
#from typing import List

world_setting   :object   = unreal.EditorLevelLibrary.get_editor_world().get_world_settings()
is_HLOD_enabled :bool     = world_setting.get_editor_property('enable_hierarchical_lod_system') 

need_to_print   :str      = 'HLOD enabled = ' + str(is_HLOD_enabled)

unreal.log_warning(need_to_print)