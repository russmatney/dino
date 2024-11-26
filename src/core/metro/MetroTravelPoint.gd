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
@export_file("*.tscn") var destination_metsys_room: String
@export var destination_name: String

@onready var anim = $AnimatedSprite2D

var room
var do_travel: Callable
var is_traveling
var group_name = "travel_points"

## on_enter_tree ##################################################################

func _on_enter_tree():
	add_to_group(group_name, true)

## ready ##################################################################

func _ready():
	anim.animation_finished.connect(_on_anim_finished)

	z_index = 10
	anim.play("opening")

	var p = get_parent()
	if p is MetroRoom:
		room = p

## actions ##################################################################

var actions = [
	Action.mk({label_fn=get_dest_label, fn=enter_travel_point, show_on_source=true, show_on_actor=false,})
	]

func get_dest_label() -> String:
	if destination_name:
		return destination_name
	elif destination_travel_point:
		return "To %s" % destination_travel_point.get_destination_name().capitalize()
	elif destination_metsys_room:
		return Log.to_pretty(destination_metsys_room)
	else:
		return "Travel"

## on_anim_finished ##################################################################

func _on_anim_finished():
	if anim.animation == "opening":
		z_index = 0
	if anim.animation == "closing":
		if do_travel != null and is_traveling:
			do_travel.call()
		else:
			z_index = 0

## travel to destination ##################################################################

func enter_travel_point(player):
	if is_traveling:
		return

	if room and room.has_method("deactivate_cam_points"):
		room.deactivate_cam_points()

	player.force_move_to_target(global_position)
	is_traveling = true

	# looks a bit like the player is inside it
	z_index = 10

	# this is invoked once the closing animation finishes
	do_travel = func():
		if destination_travel_point:
			Metro.travel_to(destination_travel_point.get_destination_zone())
		elif destination_metsys_room:
			Metro.travel_to(destination_metsys_room)
		# maybe await tick?
		is_traveling = false
		player.clear_forced_movement_target()
	anim.play("closing")
