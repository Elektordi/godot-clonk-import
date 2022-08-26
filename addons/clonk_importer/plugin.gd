tool
extends EditorPlugin


var importer_c4
var importer_txt


func _enter_tree():
    importer_c4 = preload("importer_c4.gd").new()
    importer_c4.plugin = self
    add_import_plugin(importer_c4)
    importer_txt = preload("importer_txt.gd").new()
    importer_txt.plugin = self
    add_import_plugin(importer_txt)


func _exit_tree():
    remove_import_plugin(importer_c4)
    importer_c4 = null
    remove_import_plugin(importer_txt)
    importer_txt = null
