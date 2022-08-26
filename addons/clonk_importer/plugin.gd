tool
extends EditorPlugin


var importer_c4


func _enter_tree():
    importer_c4 = preload("importer_c4.gd").new()
    importer_c4.plugin = self
    add_import_plugin(importer_c4)


func _exit_tree():
    remove_import_plugin(importer_c4)
    importer_c4 = null
