@tool
extends EditorPlugin

const MENU_NAME = "Import Clonk (C4) files or directories..."


func _enter_tree():
	add_tool_menu_item(MENU_NAME, _click)


func _exit_tree():
	remove_tool_menu_item(MENU_NAME)


func _click():
	var import_window = preload("res://addons/clonk_importer/import_window.tscn").instantiate()
	import_window.interface = get_editor_interface()
	get_tree().root.add_child(import_window)
	import_window.popup()
