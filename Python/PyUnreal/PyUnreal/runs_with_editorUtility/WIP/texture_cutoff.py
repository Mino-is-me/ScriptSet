import unreal as ue 


new_size    :int
#input from editor 

asset_lib   :object = ue.EditorAssetLibrary 
util_lib    :object = ue.EditorUtilityLibrary
##init 
asset_list  :list   = util_lib.get_selected_assets()



for each in asset_list :
    each.set_editor_property('max_texture_size', new_size)
    print(each.get_full_name())
    asset_lib.save_asset(each.get_full_name())
    #asset_lib.save_asset(each)