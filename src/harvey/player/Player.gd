extends KinematicBody2D

onready var anim = $AnimatedSprite

############################################################
# ready

func _ready():
	machine.connect("transitioned", self, "on_transit")

############################################################
# _input

func _unhandled_input(event):
	if actions and Trolley.is_action(event):
		perform_action()

############################################################
# machine

onready var machine = $Machine
onready var state_label = $StateLabel

func on_transit(new_state):
	set_state_label(new_state)

func set_state_label(label: String):
	state_label.bbcode_text = "[center]" + label + "[/center]"

############################################################
# movement

var velocity = Vector2.ZERO
var speed := 100

############################################################
# facing

enum DIR { left, right }
var facing_direction = DIR.left

func face_right():
	facing_direction = DIR.right
	anim.flip_h = true

func face_left():
	facing_direction = DIR.left
	anim.flip_h = false

############################################################
# actions

onready var action_label = $ActionLabel
var actions = {}

func update_action_label():
	if not actions:
		action_label.bbcode_text = ""
		return

	if actions:
		var ax = actions.values()[0]
		action_label.bbcode_text = "[center]" + ax["method"].capitalize() + "[/center]"

func add_action(ax):
	actions[ax["method"]] = ax
	update_action_label()

func remove_action(ax):
	actions.erase(ax["method"])
	update_action_label()

func perform_action():
	if not actions:
		return

	var ax = actions.values()[0]
	print("performing action: ", ax)
	if ax["arg"]:
		ax["obj"].call(ax["method"], ax["arg"])
	else:
		ax["obj"].call(ax["method"])

############################################################
# pickup seed

func pickup_seed(produce_type):
	print("player picking up seed type: ", produce_type)
