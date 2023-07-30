@tool
extends EditorImportPlugin


var plugin: EditorPlugin


func _get_importer_name():
	return "clonk_c4_importer"


func _get_visible_name():
	return "Clonk C4x importer"


func _get_recognized_extensions():
	return ["c4d", "c4g", "c4f", "c4s", "c4p"]


func _get_save_extension():
	return "res"


func _get_resource_type():
	return "Resource"


func _get_preset_count():
	return 0


func _get_import_options(path, preset_index):
	return [
		{
			"name": "c4group_path",
			"help": "Path to c4group executable. If empty, will try to use global system path.",
			"default_value": "",
			"hint": PROPERTY_HINT_GLOBAL_FILE
		}
	]


func _get_option_visibility(path, option_name, options):
	return true


func import(source_file, save_path, options, r_platform_variants, r_gen_files):
	# TODO: Confirmation
	var c4group = options.c4group_path
	if not c4group:
		c4group = "c4group"
	var source = ProjectSettings.globalize_path(source_file)
	var output = []
	var r = OS.execute(c4group, [source, "-x"], output, true, false) # Blocking
	for l in output:
		print(l)

	if r != 0:
		return ERR_CANT_CREATE

	#plugin.get_editor_interface().restart_editor()
	return ERR_SKIP
