import unreal 
assetPath = "/Game/Art/Character/PC/CH_P_EVE_01/Procedural_Animation/AnimSequence" 

all_Asset = unreal.EditorAssetLibrary.list_assets(assetPath)

all_Asset_Load = [unreal.EditorAssetLibrary.load_asset(a) for a in all_Asset]

for i in all_Asset_Load:
    i.set_editor_property("enable_root_motion", True)
