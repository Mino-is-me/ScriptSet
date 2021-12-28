import unreal

tempSkeleton = '/Game/Art/Character/Monster/CH_M_NA_27/CH_M_NA_27_Skeleton'
tempSkeleton = unreal.EditorAssetLibrary.load_asset(tempSkeleton)


unreal.AssetTools.create_asset('BS','/Game/Art/Character/Monster/CH_M_NA_27')


BP = '/Game/Art/Character/Monster/CH_M_NA_13/BluePrints/CH_M_NA_13_Blueprint'
BP1 = unreal.EditorAssetLibrary.load_asset(BP)

unreal.EditorAssetLibrary.get_editor_property(BP1)