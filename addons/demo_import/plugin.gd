tool
extends EditorPlugin

var import_plugin


func _enter_tree():
	print("demo-import entering tree")
	import_plugin = preload("import_plugin.gd").new()
	add_import_plugin(import_plugin)


func _exit_tree():
	print("demo-import exiting tree")
	remove_import_plugin(import_plugin)
	import_plugin = null
