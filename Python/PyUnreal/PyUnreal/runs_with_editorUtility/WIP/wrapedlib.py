import unreal

def get_selected_asset_dir() :

    ar_asset_lists = unreal.EditorUtilityLibrary.get_selected_assets() 
    if len(ar_asset_lists) > 0 :
        str_selected_asset = unreal.EditorAssetLibrary.get_path_name_for_loaded_asset(ar_asset_lists[0])
        path = str_selected_asset.rsplit('/', 1)[0] + '/'
    return path