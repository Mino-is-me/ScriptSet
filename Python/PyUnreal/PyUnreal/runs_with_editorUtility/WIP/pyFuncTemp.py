import unreal

_seek_comp_name : str = 'CapsuleComponent'
selected = unreal.EditorUtilityLibrary.get_selected_assets()[0]


name_selected = unreal.EditorAssetLibrary.get_path_name_for_loaded_asset(selected)
name_bp_c = name_selected + '_C'
loaded_bp = unreal.EditorAssetLibrary.load_blueprint_class(name_bp_c)


