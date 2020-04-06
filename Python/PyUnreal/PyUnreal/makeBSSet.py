import unreal 
#Find and Make MOB BS Set 
__blendspace_dir__ = "/Game/Art/Character/Monster/CH_M_NA_03/Animation/BlendSpace"
#Find && Make BS Assets 

__bs_lists__ = ['Airborne_BS','Dead_BS','Down_BS','GetUp_BS','Groggy_BS','IdleRun_BS_Peaceful','LockOn_BS','IdleRun_BS_Battle']


for i in __bs_lists__:
    __to_find_bs_name__ = __blendspace_dir__ + "/" + i 
    #__loaded_asset__ = unreal.load_asset(__to_find_bs_name__)
    __is_valid_asset__ = unreal.EditorAssetLibrary.does_asset_exist(__to_find_bs_name__)
    #find asset by be made name py
    if __is_valid_asset__: #when is asset valid 
        print("this BlendSpace is Exist ")
        __temp_bs_asset_for_duplicate__ = __to_find_bs_name__
    else: #when is asset NOT Valid 
        __str_to_print__ = "Need Asset : " + i 
        print(__str_to_print__) #print log 
        __duplicated_bs_asset__ = unreal.EditorAssetLibrary.duplicate_asset(__temp_bs_asset_for_duplicate__)
        #__loaded_bs_asset__ = unreal.EditorAssetLibrary.load_asset(__duplicated_bs_asset__) 오브젝트 찾았으니 굳이 로드 한번 더 안해도 됨 
        __path_of_loaded_asset__ = unreal.EditorAssetLibrary.get_path_name_for_loaded_asset(__loaded_bs_asset__)
        __renamed_asset_path__ = unreal.EditorAssetLibrary.rename_asset( __path_of_loaded_asset__, __str_to_print__)
        print(__renamed_asset_path__) #print log for duplicate&&rename Success
        
        __loaded_renamed_asset__ = unreal.EditorAssetLibrary.load_asset(__renamed_asset_path__)
        #Load BlendSpace Object and Set Animsequence by founded Name 


