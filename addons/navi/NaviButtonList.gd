@tool
extends VBoxContainer
class_name NaviButtonList

@export var default_button_scene: PackedScene = preload("res://addons/navi/ui/MenuButton.tscn")

# set a local member for the Navi autoload, to ease testing
# TODO consider loading/falling back checked a load instead?
var _navi = Navi


func pw(msg: String, item = {}):
	if item:
		Debug.warn(msg, "item:", item)
	else:
		Debug.warn(msg)


## config warnings #####################################################################


func _get_configuration_warnings():
	if default_button_scene == null:
		return ["No default_button_scene set"]
	return []


## ready #####################################################################


func _ready():
	if Engine.is_editor_hint():
		request_ready()

	# nice default... if nothing else has focus?
	# do parents still get to override this?
	var chs = get_children()
	if len(chs) > 0:
		chs[0].grab_focus()
	else:
		Debug.pr(self, "no children, can't grab focus")


## add_menu_item #####################################################################


func get_buttons():
	return get_children()

func clear():
	for b in get_buttons():
		b.free()

func no_op():
	Debug.pr("button created with no method")


func connect_pressed_to_action(button, item):
	var nav_to = item.get("nav_to", false)

	var fn
	var arg
	var argv
	if nav_to:
		fn = _navi.nav_to
		arg = nav_to
	else:
		arg = item.get("arg")
		argv = item.get("argv")
		fn = item.get("fn")

	if nav_to == null and fn == null:
		button.set_disabled(true)
		pw("Menu item missing handler", item)
		return
	elif nav_to:
		if not ResourceLoader.exists(nav_to):  # TODO does resource exist?
			button.set_disabled(true)
			pw("Menu item with non-existent nav-to", item)
			return

	if fn == null:
		button.set_disabled(true)
		pw("Menu item handler invalid", item)
		return

	if arg:
		button.pressed.connect(fn.bind(arg))
	elif argv:
		button.pressed.connect(fn.bindv(argv))
	else:
		button.pressed.connect(fn)


func add_menu_item(item):
	# read texts from buttons in scene
	var texts = []
	for but in get_buttons():
		texts.append(but.text)

	var hide_fn = item.get("hide_fn")
	if hide_fn and hide_fn.call():
		return

	var button_scene = item.get("button_scene", default_button_scene)
	var button = button_scene.instantiate()
	var label = item.get("label", "Fallback Label")
	if label in texts:
		pw("Refusing to add button with existing label.", item)
		button.free()
		return

	button.text = label
	connect_pressed_to_action(button, item)
	add_child(button)
	if item.get("grab_focus"):
		button.grab_focus()
