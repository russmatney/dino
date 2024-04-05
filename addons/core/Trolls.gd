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

static func is_move_up(event):
	return is_event(event, "move_up")

static func is_move_down(event):
	return is_event(event, "move_down")

static func is_restart(event):
	return is_event(event, "restart")

static func is_restart_held(event):
	return is_held(event, "restart")

static func is_restart_released(event):
	return is_released(event, "restart")

static func is_undo(event):
	return is_event(event, "undo")

static func is_fire(event):
	return is_event(event, "fire")

static func is_fire_released(event):
	return is_released(event, "fire")

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

static func is_debug_toggle(event):
	return is_event(event, "debug_toggle")
