tool
extends EditorImportPlugin

var plugin: EditorPlugin


func get_importer_name():
    return "clonk_txt_importer"


func get_visible_name():
    return "Clonk TXT importer"


func get_recognized_extensions():
    return ["txt"]


func get_save_extension():
    return "scn"


func get_resource_type():
    return "PackedScene"


func get_preset_count():
    return 0


func get_import_options(preset):
    return []


func get_option_visibility(option, options):
    return true


func import(source_file, save_path, options, r_platform_variants, r_gen_files):
    var filename = source_file.get_file()

    var type = null
    if filename.begins_with("DefCore"):
        type = ClonkObject

    if type == null:
        return ERR_SKIP

    var node = type.new()
    node.set_from_file(source_file)

    var scene = PackedScene.new()
    var result = scene.pack(node)
    if result != OK:
        return result
    return ResourceSaver.save("%s.%s" % [save_path, get_save_extension()], scene)

