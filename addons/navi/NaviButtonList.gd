@tool
extends VBoxContainer
class_name NaviButtonList

@export var default_button_scene: PackedScene = preload("res://addons/navi/ui/MenuButton.tscn")

# set a local member for the Navi autoload, to ease testing
# TODO consider loading/falling back checked a load instead?
var _navi = Navi


func pw(msg: String, item = {}):
	if item:
		print("[NaviMenu] Warning: ", msg, " item: ", item)
	else:
		print("[NaviMenu] Warning: ", msg)


## config warnings #####################################################################


func _get_configuration_warnings():
	if not default_button_scene:
		return "No default_button_scene set"
	return ""


## ready #####################################################################


func _ready():
	# TODO assert checked nav paths?
	if Engine.is_editor_hint():
		request_ready()


func print_button_things():
	print("button button things things")


## add_menu_item #####################################################################


func get_buttons():
	return get_children()


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
		# wtf is this?
		arg = nav_to
		# TODO  could pass more args to nav_to here, like skip_pause_music
	else:
		obj = item.get("obj")
		method = item.get("method")
		arg = item.get("arg")

	if obj == null and method == null and nav_to == null:
		button.set_disabled(true)
		pw("Menu item missing handler", item)
		return
	elif nav_to:
		if not FileAccess.file_exists(nav_to):  # TODO does resource exist?
			button.set_disabled(true)
			pw("Menu item with non-existent nav-to", item)
			return
	elif obj and method:
		if not obj.has_method(method):
			button.set_disabled(true)
			pw("Menu item handler invalid", item)
			return

	if arg:
		button.connect("pressed",Callable(obj,method).bind(arg))
	else:
		button.connect("pressed",Callable(obj,method))


func add_menu_item(item):
	# read texts from buttons in scene
	var texts = []
	for but in get_buttons():
		texts.append(but.text)

	var button_scene = default_button_scene
	if "button_scene" in item:
		button_scene = item["button_scene"]

	if not button_scene:
		pw("No button_scene: ", button_scene)
		return

	var button = button_scene.instantiate()
	var label = item.get("label", "Fallback Label")
	if label in texts:
		pw("Refusing to add button with existing label.", item)
		button.free()
		return

	button.text = label
	connect_pressed_to_action(button, item)
	add_child(button)
