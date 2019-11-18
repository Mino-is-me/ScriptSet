import unreal 

__anim_notify_name__ = "ChangeState"
__anim_sequence_dir__ = "/Game/Art/Character/Monster/CH_M_NA_03/Animation"

__anim_sequence_lists__ = unreal.EditorAssetLibrary.list_assets(__anim_sequence_dir__)

__anim_assets_lists__ = []

for i in __anim_sequence_lists__:
    __anim_assets_lists__.append(unreal.EditorAssetLibrary.load_asset(i))

for i in __anim_assets_lists__:
    


/Game/Art/Character/Monster/CH_M_NA_03/Animation/Hit_Sword_Beta_Absorption_end