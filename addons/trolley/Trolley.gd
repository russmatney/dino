tool
extends Node

var actions

func _ready():
	if Engine.editor_hint:
		request_ready()

	actions = InputMap.get_actions()

	print("Trolley autoload ready")

##################################################################
# public
##################################################################

# returns a normalized Vector2 based on the controller's movement
func move_dir():
	var v_diff = Vector2()

	if Input.is_action_pressed("move_right"):
		v_diff.x += 1
	if Input.is_action_pressed("move_left"):
		v_diff.x -= 1
	if Input.is_action_pressed("move_down"):
		v_diff.y += 1
	if Input.is_action_pressed("move_up"):
		v_diff.y -= 1

	return v_diff.normalized()


func is_attack(event):
	return event.is_action_pressed("attack")

func is_action(event):
	return event.is_action_pressed("action")

func is_pause(event):
	return event.is_action_pressed("pause")
