import unreal

blendSpace_dir = input()
#blendSpace_dir = "/Game/Art/Character/Monster/CH_M_NA_03/Animation/BlendSpace"

bs_lists = unreal.EditorAssetLibrary.list_assets(blendSpace_dir)
bs_assets_list = []
for i in bs_lists:
    bs_assets_list.append ( unreal.EditorAssetLibrary.load_asset(i) )

for i in bs_assets_list:
    num_sample = i.get_editor_property("sample_data")
    num_count = len(num_sample)
    if num_count == 0:
        print (num_count) 