extends KinematicBody2D
class_name Player

var move_accel := 800
var max_speed := 300
var velocity := Vector2.ZERO

#######################################################################33
# ready

var initial_pos
func _ready():
	initial_pos = get_global_position()

#######################################################################33
# process

func _process(delta):
	var move_dir = Trolley.move_dir()
	if move_dir.length() == 0:
		velocity = lerp(velocity, Vector2.ZERO, 0.5)
	else:
		velocity += move_accel * move_dir * delta
		velocity = velocity.limit_length(max_speed)
	velocity = move_and_slide(velocity)

#######################################################################33
# _input

func _unhandled_input(event):
	if Trolley.is_action(event):
		if actions:
			# TODO select an action
			var ax = actions[0]
			execute_action(ax)

#######################################################################33
# actions

const actions = []

var action_label_scene = preload("res://src/dungeonCrawler/player/ActionLabel.tscn")
onready var actions_list = $ActionsList

func add_action(ax):
	var label_text = ax.get("label", "fallback label")
	var new_label = action_label_scene.instance()
	new_label.bbcode_text = "[center]" + label_text
	actions_list.add_child(new_label)
	actions.append(ax)

func remove_action(ax):
	var to_remove
	for action_label in actions_list.get_children():
		if action_label.text == ax.get("label", "fallback label"):
			to_remove = action_label
			break

	if to_remove:
		actions_list.remove_child(to_remove)

	actions.erase(ax)

func execute_action(ax):
	var fn = ax["func"]
	fn.call_func()

	remove_action(ax)
