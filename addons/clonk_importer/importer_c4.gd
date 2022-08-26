tool
extends EditorImportPlugin


var plugin: EditorPlugin


func get_importer_name():
    return "clonk_c4_importer"


func get_visible_name():
    return "Clonk C4x importer"


func get_recognized_extensions():
    return ["c4d", "c4g", "c4f", "c4s", "c4p"]


func get_save_extension():
    return "res"


func get_resource_type():
    return "Resource"


func get_preset_count():
    return 0


func get_import_options(preset):
    return [
        {
            "name": "c4group_path",
            "help": "Path to c4group executable. If empty, will try to use global system path.",
            "default_value": "",
            "hint": PROPERTY_HINT_GLOBAL_FILE
        }
    ]


func get_option_visibility(option, options):
    return true


func import(source_file, save_path, options, r_platform_variants, r_gen_files):
    # TODO: Confirmation
    var c4group = options.c4group_path
    if not c4group:
        c4group = "c4group"
    var source = ProjectSettings.globalize_path(source_file)
    var output = []
    var r = OS.execute(c4group, [source, "-x"], true, output, true) # Blocking
    for l in output:
        print(l)

    if r != 0:
        return ERR_CANT_CREATE

    #plugin.get_editor_interface().restart_editor()
    return ERR_SKIP
