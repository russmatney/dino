@tool
extends VBoxContainer
class_name NaviButtonList

@export var default_button_scene: PackedScene = preload("res://addons/bones/navi/ui/MenuButton.tscn")

# set a local member for the Navi autoload, to ease testing
var _navi: Navi = Navi

## config warnings #####################################################################

func _get_configuration_warnings() -> PackedStringArray:
	if default_button_scene == null:
		return ["No default_button_scene set"]
	return []

## ready #####################################################################

func _ready() -> void:
	if Engine.is_editor_hint():
		request_ready()

	set_focus()

func set_focus() -> void:
	# nice default... if nothing else has focus?
	# do parents still get to override this?
	var chs := get_children()
	if len(chs) > 0:
		for ch: Node in chs:
			if ch is Control:
				(ch as Control).grab_focus()
				break
	else:
		Log.warn(self, "no children, can't grab focus")

	var btns := get_buttons()
	if len(btns) > 0:
		for btn: Node in btns:
			if btn is Control:
				(btn as Control).grab_focus()
				break

## add_menu_item #####################################################################

func get_buttons() -> Array:
	return get_children()

func clear() -> void:
	for b: Node in get_buttons():
		if is_instance_valid(b):
			b.queue_free()

func add_menu_item(item: Dictionary) -> void:
	# read texts from buttons in scene
	var texts := []
	for but: Button in get_buttons():
		if not but.is_queued_for_deletion():
			texts.append(but.text)

	var hide_fn: Variant = item.get("hide_fn", null)
	@warning_ignore("unsafe_method_access")
	if hide_fn != null and hide_fn is Callable and hide_fn.call():
		return

	var label: Variant = item.get("label", "Fallback Label")
	if label is Callable:
		@warning_ignore("unsafe_method_access")
		label = label.call()
	if label in texts:
		Log.warn("Found existing button with label, skipping add_menu_item", item)
		return
	var button_scene: PackedScene = item.get("button_scene", default_button_scene)
	var button: Variant
	if button_scene != null:
		button = button_scene.instantiate()

	if button == null:
		return
	
	var btn: Button = button

	btn.text = label
	connect_pressed_to_action(btn, item)
	add_child(btn)

func set_menu_items(items: Array) -> void:
	clear()
	for it: Dictionary in items:
		add_menu_item(it)

func no_op() -> void:
	Log.warn("button created with no method")


func connect_pressed_to_action(button: Button, item: Dictionary) -> void:
	var nav_to: Variant = item.get("nav_to", false)

	var fn: Variant
	var arg: Variant
	var argv: Array
	if nav_to:
		fn = _navi.nav_to
		arg = nav_to
	else:
		arg = item.get("arg", null)
		argv = item.get("argv", [])
		fn = item.get("fn")

	if nav_to == null and fn == null:
		button.set_disabled(true)
		Log.warn("Menu item missing handler", item)
		return
	elif nav_to is String:
		var nav_str: String = nav_to
		if not ResourceLoader.exists(nav_str):
			button.set_disabled(true)
			Log.warn("Menu item with non-existent nav-to", item)
			return

	if fn == null:
		button.set_disabled(true)
		Log.warn("Menu item handler invalid", item)
		return
	var f: Callable = fn

	if item.get("is_disabled"):
		@warning_ignore("unsafe_method_access")
		if item.is_disabled.call():
			button.set_disabled(true)
			return

	if arg:
		button.pressed.connect(f.bind(arg))
	elif argv:
		button.pressed.connect(f.bindv(argv))
	else:
		button.pressed.connect(f)
