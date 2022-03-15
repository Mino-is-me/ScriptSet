import unreal


src_num = '_02' 
dst_num = '_46'

ar_asset_lists = unreal.EditorUtilityLibrary.get_selected_assets() 


if len(ar_asset_lists) > 0 :
    for each in ar_asset_lists :
        src_asset_path = unreal.EditorAssetLibrary.get_path_name_for_loaded_asset(each)
        dst_asset_path = src_asset_path.replace(src_num, dst_num)
        rename = unreal.EditorAssetLibrary.rename_asset(src_asset_path, dst_asset_path)




