import unreal

ar_asset_lists = unreal.EditorUtilityLibrary.get_selected_assets()
ar_selected_0 = ar_asset_lists[0]


for each in ar_asset_lists :
    import_data_selected = each.get_editor_property("asset_import_data")

    frame_rate_data = import_data_selected.get_editor_property("custom_sample_rate")
    using_default_sample_rate = import_data_selected.get_editor_property("use_default_sample_rate")
    
    import_data_selected.set_editor_property("use_default_sample_rate", False)
    import_data_selected.set_editor_property("custom_sample_rate", 60)
