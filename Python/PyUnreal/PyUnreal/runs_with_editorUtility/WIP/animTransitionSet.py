import unreal

eal = unreal.EditorAssetLibrary

animBP = '/Game/Art/Character/Monster/CH_M_NA_25/Blueprints/CH_M_NA_25_AnimBP'

animBPAsset = eal.load_asset(animBP)
animGraph = animBPAsset.get_editor_property("animation_graph")
