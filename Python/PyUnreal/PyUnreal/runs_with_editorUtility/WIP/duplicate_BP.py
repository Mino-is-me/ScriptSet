from asyncio.windows_events import NULL
import unreal

def get_selected_asset_dir() -> str :
    ar_asset_lists = unreal.EditorUtilityLibrary.get_selected_assets() 

    if len(ar_asset_lists) > 0 :
        str_selected_asset = unreal.EditorAssetLibrary.get_path_name_for_loaded_asset(ar_asset_lists[0])
        path = str_selected_asset.rsplit('/', 1)[0]

    else : 
        path = '' 

    return path



# listing #
li_skeletal_meshs :list = unreal.EditorUtilityLibrary.get_selected_assets()

BP_dir :str = '/Game/Art/Character/ETC/Fish/Blueprints/Main' # edit here when run

BP_origin :str = 'BP_Fish_Origin' # edit here when run

# listing end #


# execute #

if len(li_skeletal_meshs) > 0 :
    for each in li_skeletal_meshs :
        dir = unreal.EditorAssetLibrary.get_path_name_for_loaded_asset(each)
        name = dir.rsplit('.',1)[1]
        unreal.EditorAssetLibrary.duplicate_asset( BP_dir + '/' + BP_origin  , BP_dir + '/' + 'BP_' +  name )

# execute end #




# li_actors = unreal.EditorLevelLibrary.get_selected_level_actors()

# for each in li_actors :
#     SBSkeletalMeshComp = each.get_component_by_class(unreal.SBSkeletalMeshComponent)
#     SBSkeletalMeshComp.set_editor_property('skeletal_mesh', li_skeletal_meshs[2])




# aa.EditorAssetLibrary.set_editor_property('skeletal_mesh', NULL)





