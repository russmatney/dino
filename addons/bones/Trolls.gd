@tool
extends Node
class_name Trolls

## public #################################################################

static func is_event(event, event_name):
	if Debug.focused:
		return event.is_action_pressed(event_name)
	return false

static func is_pressed(event, event_name):
	return is_event(event, event_name)

static func is_held(event, event_name):
	return is_event(event, event_name)

static func is_released(event, event_name):
	if Debug.focused:
		return event.is_action_released(event_name)
	return false


# returns a normalized Vector2 based on the controller's movement
static func move_vector():
	if Debug.focused:
		return Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	return Vector2.ZERO

static func grid_move_vector(thresh=0.6):
	var move = move_vector()
	if move.x > thresh:
		return Vector2.RIGHT
	elif move.x < -1*thresh:
		return Vector2.LEFT
	elif move.y < -1*thresh:
		return Vector2.UP
	elif move.y > thresh:
		return Vector2.DOWN
	return Vector2.ZERO

static func is_move(event):
	return is_event(event, "ui_left") or is_event(event, "ui_right") or \
		is_event(event, "ui_up") or is_event(event, "ui_down")

static func is_move_released(event):
	return is_released(event, "ui_left") or is_released(event, "ui_right") or \
		is_released(event, "ui_up") or is_released(event, "ui_down")

static func is_undo(event):
	return is_event(event, "undo")

static func is_accept(event):
	return is_event(event, "ui_accept")

static func is_jump(event):
	return is_event(event, "jump")

static func is_dash(event):
	return is_event(event, "dash")

static func is_jetpack(event):
	return is_event(event, "jetpack")

static func is_attack(event):
	return is_event(event, "attack")

static func is_attack_released(event):
	return is_released(event, "attack")

static func is_action(event):
	return is_event(event, "action")

static func is_cycle_next_action(event):
	return is_event(event, "cycle_next_action")

static func is_cycle_prev_action(event):
	return is_event(event, "cycle_previous_action")

static func is_pause(event):
	return is_event(event, "pause")

static func is_close(event):
	return is_event(event, "close")

static func is_close_released(event):
	return is_released(event, "close")

static func is_debug_toggle(event):
	return is_event(event, "debug_toggle")

static func is_slowmo(event):
	return is_event(event, "slowmo")

static func is_slowmo_released(event):
	return is_released(event, "slowmo")

## input/keys helpers ################################################################3

static var inputs_by_action_label
static var action_labels_by_input


## build inputs dict ########################################################################

# TODO call this some time, maybe when the plugin loads?
# build_inputs_dict()
static func build_inputs_dict():
	# apparently we need to reload this
	InputMap.load_from_project_settings()

	inputs_by_action_label = {}
	action_labels_by_input = {}
	for ac in InputMap.get_actions():
		var evts = InputMap.action_get_events(ac)

		var setting = ProjectSettings.get_setting(str("input/", ac))

		var keys = []
		var buttons = []
		for evt in evts:
			if evt is InputEventKey:
				var key_str = OS.get_keycode_string(evt.keycode)
				# could support 'Enter, Shift, etc'
				keys.append(key_str)

				if not key_str in action_labels_by_input:
					action_labels_by_input[key_str] = []
				action_labels_by_input[key_str].append(ac)

			elif evt is InputEventJoypadButton:
				var btn_idx = evt.button_index
				buttons.append(btn_idx)

				# hopefully btn_idx doesn't collide with anything
				if not btn_idx in action_labels_by_input:
					action_labels_by_input[btn_idx] = []
				action_labels_by_input[btn_idx].append(ac)

		inputs_by_action_label[ac] = {events=evts, setting=setting, keys=keys, action=ac,
			buttons=buttons}

## inputs list ########################################################################

static func inputs_list(opts={}):
	if inputs_by_action_label == null or len(inputs_by_action_label) == 0:
		build_inputs_dict()

	var ignore_prefix = opts.get("ignore_prefix", "ui_text_")
	var only_prefix = opts.get("only_prefix", "")

	var inputs_list = inputs_by_action_label.values()

	var inps = []
	for inp in inputs_list:
		if ignore_prefix:
			if inp["action"].begins_with(ignore_prefix):
				continue

		if only_prefix:
			if not inp["action"].begins_with(only_prefix):
				continue

		inps.append(inp)

	return inps


static func keys_for_input_action(action_label):
	build_inputs_dict()
	if action_label in inputs_by_action_label:
		return inputs_by_action_label[action_label]["keys"]

static func _axs_for_input(input):
	var axs = []
	var action_labels = action_labels_by_input[input]
	for ac in action_labels:
		axs.append({
			input=inputs_by_action_label[ac],
			action_label=ac,
			})
	return axs


static func actions_for_input(event):
	var axs = []
	if event is InputEventKey:
		var key_str = OS.get_keycode_string(event.keycode)
		if key_str in action_labels_by_input:
			axs.append_array(_axs_for_input(key_str).map(func(ax):
				ax["key_str"] = key_str
				return ax))
	if event is InputEventJoypadButton:
		var btn_idx = event.button_index
		if btn_idx in action_labels_by_input:
			axs.append_array(_axs_for_input(btn_idx).map(func(ax):
				ax["btn_idx"] = btn_idx
				return ax))
	return axs

## simulate ################################################################

static func sim_action_pressed(action, release_after=null, released=null):
	var evt = InputEventAction.new()
	evt.action = action
	evt.pressed = true
	Input.parse_input_event(evt)
	# if release_after != null:
	# 	await get_tree().create_timer(release_after).timeout
	# 	sim_action_released.call_deferred(action)
	# 	if released != null:
	# 		released.emit()

static func sim_action_released(action):
	var evt = InputEventAction.new()
	evt.action = action
	evt.pressed = false
	Input.parse_input_event(evt)

static func close():
	sim_action_pressed("close", 0.2)

static func attack(t=0.5):
	if t:
		sim_action_pressed("attack", t)
	else:
		sim_action_pressed("attack")

static func sim_move(dir: Vector2, release_after=0.8, released=null):
	match dir:
		Vector2.LEFT: sim_action_pressed("move_left", release_after, released)
		Vector2.RIGHT: sim_action_pressed("move_right", release_after, released)
		Vector2.UP: sim_action_pressed("move_up", release_after, released)
		Vector2.DOWN: sim_action_pressed("move_down", release_after, released)
		_: Log.warn("Not-impled: simulated input in non-cardinal directions", dir)
