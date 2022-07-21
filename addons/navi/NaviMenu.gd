tool
extends Control

export(PackedScene) var button_scene = preload("res://src/ui/MenuButton.tscn")

var menu_list = null
var expected_nodes = {"MenuList": "menu_list"}

## config warnings #####################################################################


func _get_configuration_warning():
	for node_name in expected_nodes:
		var node = find_node("MenuList")
		if not node:
			return (
				"'NaviMenu' expected child node named '"
				+ node_name
				+ "' somewhere in its children."
			)
	return ""


## ready #####################################################################


func _ready():
	for node_name in expected_nodes:
		var local_var_name = expected_nodes[node_name]
		self[local_var_name] = find_node("MenuList")
		assert(
			self[local_var_name],
			(
				"'NaviMenu' expected "
				+ node_name
				+ " to be set as "
				+ local_var_name
				+ ", but found: "
				+ str(self[local_var_name])
			)
		)

	if Engine.editor_hint:
		request_ready()


func print_button_things():
	print("button button things things")


## add_menu_item #####################################################################


func no_op():
	print("button created with no method")

func add_menu_item(item):
	var button = button_scene.instance()
	var label = item.get("label", "Fallback Label")
	button.text = label
  # TODO consider using a funcref
	var obj = item.get("obj", self)
	var method = item.get("method", "no_op")
	button.connect("pressed", obj, method)
	menu_list.add_child(button)
