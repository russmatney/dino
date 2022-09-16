tool
extends Node2D

var velocity := Vector2.ZERO

export(int) var speed := 500

var initial_pos

onready var state_label = $StateLabel
onready var machine = $Machine

#######################################################################33
# config warning

func _get_configuration_warning():
	for n in ["StateLabel", "Machine"]:
		var node = find_node(n)
		if not node:
			return "Missing expected child named '" + n + "'"
	return ""

#######################################################################33
# ready

func _ready():
	print("bowling boss ready")
	initial_pos = get_global_position()
	machine.connect("transitioned", self, "on_transit")

func on_transit(new_state):
	set_state_label(new_state)

func set_state_label(label: String):
	state_label.bbcode_text = "[center]" + label + "[/center]"

#######################################################################33
# process

#func _process(delta):
#	pass


#######################################################################33
# signals

var bodies = []
var detects_group = "player"

func _on_DetectBox_body_entered(body:Node):
	if body.is_in_group(detects_group):
		bodies.append(body)

func _on_DetectBox_body_exited(body:Node):
	bodies.erase(body)
