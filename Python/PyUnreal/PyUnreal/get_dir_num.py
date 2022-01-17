import unreal
import re

ar_asset_lists = []
ar_asset_lists = unreal.EditorUtilityLibrary.get_selected_assets() 

print (ar_asset_lists[0])

str_selected_asset = ''

if len(ar_asset_lists) > 0 :

    str_selected_asset = unreal.EditorAssetLibrary.get_path_name_for_loaded_asset(ar_asset_lists[0])
    #str_selected_asset = str(ar_asset_lists[0])
    print(str_selected_asset)
    ar_numbers = re.findall("\d+", str_selected_asset)
    i_number = ar_numbers[0]
    print(ar_numbers)
    print(i_number)