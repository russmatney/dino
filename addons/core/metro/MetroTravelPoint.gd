@tool
extends Node2D
class_name MetroTravelPoint

## config warnings ###########################################################

func _get_configuration_warnings():
	return U._config_warning(self, {expected_nodes=[
		"ActionArea", "AnimatedSprite2D", "ActionHint",
		], expected_animations={"AnimatedSprite2D": [
			"open", "opening", "closed", "closing"]}})

## vars ###########################################################

@export var destination_travel_point: MetroTravelPointEntity

@onready var action_area = $ActionArea
@onready var anim = $AnimatedSprite2D
@onready var action_hint = $ActionHint

var room
var travel_dest
var is_traveling
var group_name = "travel_points"

## on_enter_tree ##################################################################

func _on_enter_tree():
	add_to_group(group_name, true)

## ready ##################################################################

func _ready():
	action_area.register_actions(actions, {source=self, action_hint=action_hint})
	anim.animation_finished.connect(_on_anim_finished)

	z_index = 10
	anim.play("opening")

	var p = get_parent()
	if p is MetroRoom:
		room = p

## actions ##################################################################

var actions = [
	Action.mk({label_fn=get_dest_label, fn=travel, show_on_source=true, show_on_actor=false,})
	]

func get_dest_label():
	if destination_travel_point:
		return "To %s" % destination_travel_point.get_destination_name().capitalize()
	else:
		return "Travel"

## on_anim_finished ##################################################################

func _on_anim_finished():
	if anim.animation == "opening":
		z_index = 0
	if anim.animation == "closing":
		if travel_dest != null:
			Metro.travel_to(travel_dest[0], travel_dest[1])
			is_traveling = false
			travel_dest = null
		else:
			z_index = 0

## travel to destination ##################################################################

func travel(player):
	if is_traveling:
		return

	if room:
		room.deactivate_cam_points()

	player.force_move_to_target(global_position)
	is_traveling = true
	z_index = 10
	# get and pass the node_path
	# pass a callable instead of this arg hand-off non-sense
	travel_dest = [destination_travel_point.get_destination_zone(), null]
	anim.play("closing")
