@tool
extends EditorPlugin


func _enter_tree():
	Debug.prn("<Beehive>")


func _exit_tree():
	print("</Beehive>")
