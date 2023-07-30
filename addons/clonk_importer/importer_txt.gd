@tool
extends EditorImportPlugin

var plugin: EditorPlugin


func _get_importer_name():
	return "clonk_txt_importer"


func _get_visible_name():
	return "Clonk TXT importer"


func _get_recognized_extensions():
	return ["txt"]


func _get_save_extension():
	return "scn"


func _get_resource_type():
	return "PackedScene"


func _get_preset_count():
	return 0


func _get_import_options(path, preset_index):
	return []


func _get_option_visibility(path, option_name, options):
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
	return ResourceSaver.save(scene, "%s.%s" % [save_path, _get_save_extension()])

