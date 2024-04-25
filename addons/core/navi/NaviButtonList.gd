@tool
extends VBoxContainer
class_name NaviButtonList

@export var default_button_scene: PackedScene = preload("res://addons/core/navi/ui/MenuButton.tscn")

# set a local member for the Navi autoload, to ease testing
var _navi = Navi

## config warnings #####################################################################

func _get_configuration_warnings():
	if default_button_scene == null:
		return ["No default_button_scene set"]
	return []

## ready #####################################################################

func _ready():
	if Engine.is_editor_hint():
		request_ready()

	set_focus()

func set_focus():
	# nice default... if nothing else has focus?
	# do parents still get to override this?
	var chs = get_children()
	if len(chs) > 0:
		chs[0].grab_focus()
	else:
		Log.warn(self, "no children, can't grab focus")

	var btns = get_buttons()
	if len(btns) > 0:
		btns[0].grab_focus()

## add_menu_item #####################################################################

func get_buttons():
	return get_children()

func clear():
	for b in get_buttons():
		if is_instance_valid(b):
			b.queue_free()

func add_menu_item(item):
	# read texts from buttons in scene
	var texts = []
	for but in get_buttons():
		if not but.is_queued_for_deletion():
			texts.append(but.text)

	var hide_fn = item.get("hide_fn")
	if hide_fn and hide_fn.call():
		return

	var label = item.get("label", "Fallback Label")
	if label in texts:
		Log.warn("Found existing button with label, skipping add_menu_item", item)
		return
	var button_scene = item.get("button_scene", default_button_scene)
	var button = button_scene.instantiate()

	button.text = label
	connect_pressed_to_action(button, item)
	add_child(button)

func set_menu_items(items):
	clear()
	for it in items:
		add_menu_item(it)

func no_op():
	Log.warn("button created with no method")


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
		Log.warn("Menu item missing handler", item)
		return
	elif nav_to:
		if not ResourceLoader.exists(nav_to):
			button.set_disabled(true)
			Log.warn("Menu item with non-existent nav-to", item)
			return

	if fn == null:
		button.set_disabled(true)
		Log.warn("Menu item handler invalid", item)
		return

	if item.get("is_disabled"):
		if item.is_disabled.call():
			button.set_disabled(true)
			return

	if arg:
		button.pressed.connect(fn.bind(arg))
	elif argv:
		button.pressed.connect(fn.bindv(argv))
	else:
		button.pressed.connect(fn)
