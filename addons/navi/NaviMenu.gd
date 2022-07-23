tool
extends Control
class_name NaviMenu

export(PackedScene) var button_scene = preload("res://addons/navi/ui/MenuButton.tscn")

# set a local member for the Navi autoload, to ease testing
# TODO consider loading/falling back on a load instead?
var _navi = Navi

var menu_list = null
var expected_nodes = {"MenuList": "menu_list"}


func pw(msg: String, item = {}):
	if item:
		print("[NaviMenu] Warning: ", msg, " item: ", item)
	else:
		print("[NaviMenu] Warning: ", msg)


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


func get_buttons():
	return menu_list.get_children()


func no_op():
	print("button created with no method")


func connect_pressed_to_action(button, item):
	var nav_to = item.get("nav_to", false)

	var obj
	var method
	var arg
	if nav_to:
		obj = _navi
		method = "nav_to"
		arg = nav_to
	else:
		obj = item.get("obj")
		method = item.get("method")

	if (not (obj and method)) and (not nav_to):
		button.set_disabled(true)
		pw("Menu item missing handler", item)
		return
	elif nav_to:
		if not File.new().file_exists(nav_to):  # TODO does resource exist?
			button.set_disabled(true)
			pw("Menu item with non-existent nav-to", item)
			return
	elif obj and method:
		if not obj.has_method(method):
			button.set_disabled(true)
			pw("Menu item handler invalid", item)
			return

	if arg:
		button.connect("pressed", obj, method, [arg])
	else:
		button.connect("pressed", obj, method)


func add_menu_item(item):
	var texts = []
	for but in get_buttons():
		texts.append(but.text)

	var button = button_scene.instance()
	var label = item.get("label", "Fallback Label")
	if label in texts:
		# TODO some better logging lib
		pw("Refusing to add button with existing label.", item)
		button.free()
		return

	button.text = label
	connect_pressed_to_action(button, item)
	menu_list.add_child(button)
