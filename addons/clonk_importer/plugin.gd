tool
extends EditorPlugin


var importer_c4d


func _enter_tree():
    importer_c4d = preload("importer_c4d.gd").new()
    add_import_plugin(importer_c4d)


func _exit_tree():
    remove_import_plugin(importer_c4d)
    importer_c4d = null
