@tool
extends Window

var interface: EditorInterface
var settings: EditorSettings

func _on_about_to_popup():
	settings = interface.get_editor_settings()
	if settings.has_setting("addons/clonk_importer/c4group"):
		%config_c4group.text = settings.get_setting("addons/clonk_importer/c4group")
	if settings.has_setting("addons/clonk_importer/source"):
		%config_source.text = settings.get_setting("addons/clonk_importer/source")
	if settings.has_setting("addons/clonk_importer/target"):
		%config_target.text = settings.get_setting("addons/clonk_importer/target")


func _on_close_requested():
	queue_free()


func _on_button_close_pressed():
	queue_free()


func _on_button_import_pressed():
	settings.set_setting("addons/clonk_importer/c4group", %config_c4group.text)
	settings.set_setting("addons/clonk_importer/source", %config_source.text)
	settings.set_setting("addons/clonk_importer/target", %config_target.text)
	var importer = load("res://addons/clonk_importer/importer.gd").new()
	importer.interface = interface
	var r = importer.import(%config_c4group.text, %config_source.text, %config_target.text)
	if r == null:
		r = ERR_SCRIPT_FAILED
	$AcceptDialog.dialog_text = "Import result: %s" % error_string(r)
	$AcceptDialog.popup_centered()
	await $AcceptDialog.confirmed
	interface.get_resource_filesystem().scan()
	if r == OK:
		queue_free()


func _on_button_browse_c4group_pressed():
	$FileDialog_c4group.popup_centered()


func _on_button_browse_source_pressed():
	$FileDialog_source.popup_centered()


func _on_button_browse_target_pressed():
	$FileDialog_target.popup_centered()



func _on_file_dialog_c4group_file_selected(path):
	%config_c4group.text = path


func _on_file_dialog_source_dir_selected(dir):
	%config_source.text = dir


func _on_file_dialog_target_dir_selected(dir):
	%config_target.text = dir

