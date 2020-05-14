import unreal

dirAnimBP = '/Game/Art/Character/Monster/CH_M_NA_10/Blueprints/CH_M_NA_10_AnimBP'
dirNew = dirAnimBP.replace('CH_M_NA_10','Master')
dirAnimBP = str(dirAnimBP)

print(dirAnimBP.replace('CH_M_NA_10','Master'))
bpAnimBP = unreal.EditorAssetLibrary.load_asset(dirAnimBP)


bpCloned = unreal.EditorAssetLibrary.duplicate_asset(dirAnimBP,dirNew) 
#bpCloned1 = unreal.EditorAssetLibrary.load_asset(dirNew)
A = bpCloned.get_editor_property("target_skeleton")
#bpCloneAnimBP = unreal.EditorAssetLibrary.load_asset(bpAnimBP)


#for i in bs_assets_list:
 #   num_sample = i.get_editor_property("sample_data")
  #  num_count = len(num_sample)
   # if num_count == 0:
    #    print (num_count)  