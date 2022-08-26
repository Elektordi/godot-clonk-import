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
    return "res"


func get_resource_type():
    return "Resource"


func get_preset_count():
    return 0


func get_import_options(preset):
    return []


func get_option_visibility(option, options):
    return true


func import(source_file, save_path, options, r_platform_variants, r_gen_files):
    var file = File.new()
    var err = file.open(source_file, File.READ)
    if err != OK:
        return err
    var text = file.get_buffer(65000).get_string_from_ascii()
    # file.as_text() decoding fails badly for non-utf8 text
    file.close()
    
    var filename = source_file.get_file()
    
    var type = GenericTxt
    if filename == "DefCore.txt":
        type = ClonkDefCore
    
    var res = type.new()
    res.set_from_text(text)
    return ResourceSaver.save("%s.%s" % [save_path, get_save_extension()], res)
