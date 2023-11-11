@tool
extends EditorPlugin


func _enter_tree():
	Log.prn("<Beehive>")


func _exit_tree():
	print("</Beehive>")
