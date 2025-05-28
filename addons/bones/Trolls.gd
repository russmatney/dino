@tool
extends Node
class_name Trolls

## public #################################################################

static func is_event(event: InputEvent, event_name: String) -> bool:
	if Debug.focused:
		return event.is_action_pressed(event_name)
	return false

static func is_pressed(event: InputEvent, event_name: String) -> bool:
	return is_event(event, event_name)

static func is_held(event: InputEvent, event_name: String) -> bool:
	return is_event(event, event_name)

static func is_released(event: InputEvent, event_name: String) -> bool:
	if Debug.focused:
		return event.is_action_released(event_name)
	return false


# returns a normalized Vector2 based on the controller's movement
static func move_vector() -> Vector2:
	if Debug.focused:
		return Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	return Vector2.ZERO

static func grid_move_vector(thresh: float = 0.6) -> Vector2:
	var move := move_vector()
	if move.x > thresh:
		return Vector2.RIGHT
	elif move.x < -1*thresh:
		return Vector2.LEFT
	elif move.y < -1*thresh:
		return Vector2.UP
	elif move.y > thresh:
		return Vector2.DOWN
	return Vector2.ZERO

static func is_move(event: InputEvent) -> bool:
	return is_event(event, "ui_left") or is_event(event, "ui_right") or \
		is_event(event, "ui_up") or is_event(event, "ui_down")

static func is_move_released(event: InputEvent) -> bool:
	return is_released(event, "ui_left") or is_released(event, "ui_right") or \
		is_released(event, "ui_up") or is_released(event, "ui_down")

static func is_move_up(event: InputEvent) -> bool:
	return is_event(event, "move_up")

static func is_move_down(event: InputEvent) -> bool:
	return is_event(event, "move_down")

static func is_undo(event: InputEvent) -> bool:
	return is_event(event, "undo")

static func is_accept(event: InputEvent) -> bool:
	return is_event(event, "ui_accept")

static func is_jump(event: InputEvent) -> bool:
	return is_event(event, "jump")

static func is_dash(event: InputEvent) -> bool:
	return is_event(event, "dash")

static func is_jetpack(event: InputEvent) -> bool:
	return is_event(event, "jetpack")

static func is_attack(event: InputEvent) -> bool:
	return is_event(event, "attack")

static func is_attack_released(event: InputEvent) -> bool:
	return is_released(event, "attack")

static func is_action(event: InputEvent) -> bool:
	return is_event(event, "action")

static func is_cycle_next_action(event: InputEvent) -> bool:
	return is_event(event, "cycle_next_action")

static func is_cycle_prev_action(event: InputEvent) -> bool:
	return is_event(event, "cycle_previous_action")

static func is_pause(event: InputEvent) -> bool:
	return is_event(event, "pause")

static func is_close(event: InputEvent) -> bool:
	return is_event(event, "close")

static func is_close_released(event: InputEvent) -> bool:
	return is_released(event, "close")

static func is_debug_toggle(event: InputEvent) -> bool:
	return is_event(event, "debug_toggle")

static func is_slowmo(event: InputEvent) -> bool:
	return is_event(event, "slowmo")

static func is_slowmo_released(event: InputEvent) -> bool:
	return is_released(event, "slowmo")

## input/keys helpers ################################################################3

static var inputs_by_action_label: Dictionary
static var action_labels_by_input: Dictionary

## build inputs dict ########################################################################

# TODO call this some time, maybe when the plugin loads?
# build_inputs_dict()
static func build_inputs_dict() -> void:
	# apparently we need to reload this
	InputMap.load_from_project_settings()

	inputs_by_action_label = {}
	action_labels_by_input = {}
	for ac in InputMap.get_actions():
		var evts := InputMap.action_get_events(ac)

		var setting: Variant = ProjectSettings.get_setting(str("input/", ac))

		var keys := []
		var buttons := []
		for evt in evts:
			if evt is InputEventKey:
				var key_str := OS.get_keycode_string((evt as InputEventKey).keycode)
				# could support 'Enter, Shift, etc'
				keys.append(key_str)

				if not key_str in action_labels_by_input:
					action_labels_by_input[key_str] = []
				@warning_ignore("unsafe_method_access")
				action_labels_by_input[key_str].append(ac)

			elif evt is InputEventJoypadButton:
				var btn_idx := (evt as InputEventJoypadButton).button_index
				buttons.append(btn_idx)

				# hopefully btn_idx doesn't collide with anything
				if not btn_idx in action_labels_by_input:
					action_labels_by_input[btn_idx] = []
				@warning_ignore("unsafe_method_access")
				action_labels_by_input[btn_idx].append(ac)

		inputs_by_action_label[ac] = {events=evts, setting=setting, keys=keys, action=ac,
			buttons=buttons}

## inputs list ########################################################################

static func inputs_list(opts: Dictionary = {}) -> Array:
	if inputs_by_action_label == null or len(inputs_by_action_label) == 0:
		build_inputs_dict()

	var ignore_prefix: String = opts.get("ignore_prefix", "ui_text_")
	var only_prefix: String = opts.get("only_prefix", "")

	var inpts_lst: Array = inputs_by_action_label.values()

	var inps := []
	for inp: Dictionary in inpts_lst:
		var act_str: String = inp.get("action", "")
		if ignore_prefix:
			if act_str.begins_with(ignore_prefix):
				continue

		if only_prefix:
			if not act_str.begins_with(only_prefix):
				continue

		inps.append(inp)

	return inps


static func keys_for_input_action(action_label: String) -> Array:
	build_inputs_dict()
	if action_label in inputs_by_action_label:
		return inputs_by_action_label[action_label]["keys"]
	return []

static func _axs_for_input(input: Variant) -> Array:
	var axs := []
	var action_labels: Array = action_labels_by_input[input]
	for ac: String in action_labels:
		axs.append({
			input=inputs_by_action_label[ac],
			action_label=ac,
			})
	return axs


static func actions_for_input(event: InputEvent) -> Array:
	var axs := []
	if event is InputEventKey:
		var key_str := OS.get_keycode_string((event as InputEventKey).keycode)
		if key_str in action_labels_by_input:
			axs.append_array(_axs_for_input(key_str).map(func(ax: Dictionary) -> Dictionary:
				ax["key_str"] = key_str
				return ax))
	if event is InputEventJoypadButton:
		var btn_idx := (event as InputEventJoypadButton).button_index
		if btn_idx in action_labels_by_input:
			axs.append_array(_axs_for_input(btn_idx).map(func(ax: Dictionary) -> Dictionary:
				ax["btn_idx"] = btn_idx
				return ax))
	return axs

## simulate ################################################################

static func sim_action_pressed(action: String, _release_after: float = 0.0, _released: Variant = null) -> void:
	var evt := InputEventAction.new()
	evt.action = action
	evt.pressed = true
	Input.parse_input_event(evt)
	# if release_after != null:
	# 	await get_tree().create_timer(release_after).timeout
	# 	sim_action_released.call_deferred(action)
	# 	if released != null:
	# 		released.emit()

static func sim_action_released(action: String) -> void:
	var evt := InputEventAction.new()
	evt.action = action
	evt.pressed = false
	Input.parse_input_event(evt)

static func close() -> void:
	sim_action_pressed("close", 0.2)

static func attack(t: float = 0.5) -> void:
	if t:
		sim_action_pressed("attack", t)
	else:
		sim_action_pressed("attack")

static func sim_move(dir: Vector2, release_after: float = 0.8, released: Variant = null) -> void:
	match dir:
		Vector2.LEFT: sim_action_pressed("move_left", release_after, released)
		Vector2.RIGHT: sim_action_pressed("move_right", release_after, released)
		Vector2.UP: sim_action_pressed("move_up", release_after, released)
		Vector2.DOWN: sim_action_pressed("move_down", release_after, released)
		_: Log.warn("Not-impled: simulated input in non-cardinal directions", dir)
