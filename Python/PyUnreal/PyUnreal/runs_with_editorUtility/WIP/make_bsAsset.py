import unreal
factory = unreal.BlendSpaceFactory1D()

# target_skeleton = unreal.EditorAssetLibrary.load_asset('/Game/Art/Character/NPC/CH_NPC_03/CH_NPC_03_Skeleton')

# factory.set_editor_property('target_skeleton', target_skeleton)
# factory.set_editor_property


asset_tools = unreal.AssetToolsHelpers.get_asset_tools()

asset_tools.create_asset(
    'tt',
    '/Game/Art/Character/NPC/CH_NPC_Deadman_02',
    unreal.BlendSpace1D(),
    unreal.BlendSpaceFactory1D(),
    'None'
)