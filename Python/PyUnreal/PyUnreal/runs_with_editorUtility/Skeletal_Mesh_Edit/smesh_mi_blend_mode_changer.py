import unreal 

asset_lists :list = unreal.EditorUtilityLibrary.get_selected_assets()

asset = asset_lists[0]

for each in asset.materials :
    MI = each.get_editor_property('material_interface')
    MI_overridable_properties = MI.get_editor_property('base_property_overrides')
    MI_overridable_properties.set_editor_property( 'override_blend_mode', True )

    if MI_overridable_properties.get_editor_property( 'override_blend_mode') :
        MI_overridable_properties.set_editor_property( 'blend_mode', unreal.BlendMode.cast(1) )

