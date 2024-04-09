@tool
extends Node2D

@onready var bottom: Area2D = $Bottom
@onready var top: Marker2D = $Top

var height

## config warning ##########################################################

func _get_configuration_warnings():
	return U._config_warning(self, {expected_nodes=["Bottom", "Top"]})

## ready ##########################################################

func _ready():
	bottom.body_shape_entered.connect(_on_bottom_entered)

func _on_bottom_entered(_body_rid, body: Node, _body_index, local_shape_index):
	if height == null:
		var bottom_collision_shape = bottom.shape_owner_get_owner(bottom.shape_find_owner(local_shape_index))
		var bot_pos = bottom.global_position + bottom_collision_shape.position
		height = (bot_pos - top.global_position).abs().y
		Log.pr("using bot_pos to set height", bot_pos, height)

	# filtering is done based on collision masks
	if body != null:
		body.global_position.y -= height
