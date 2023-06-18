@tool
extends Node2D
class_name MetroTravelPoint

## config warnings ###########################################################

func _get_configuration_warnings():
	return Util._config_warning(self, {expected_nodes=[
		"ActionArea", "AnimatedSprite2D", "ActionHint",
		], expected_animations={"AnimatedSprite2D": [
			"open", "opening", "closed", "closing"]}})

## vars ###########################################################

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
	Hotel.book(self)


## ready ##################################################################

func _ready():
	Hotel.register(self)

	action_area.register_actions(actions, {source=self, action_hint=action_hint})
	anim.animation_finished.connect(_on_anim_finished)

	z_index = 10
	anim.play("opening")

	var p = get_parent()
	if p is MetroRoom:
		room = p


## hotel ##################################################################

func check_out(_data):
	pass

func hotel_data():
	return {
		destination_zone_name=destination_zone_name,
		destination_travel_point_path=destination_travel_point_path,
		}


## actions ##################################################################

var actions = [
	Action.mk({label_fn=get_dest_label, fn=travel, show_on_source=true, show_on_actor=false,})
	]

func get_dest_label():
	if destination_zone_name:
		return "To %s" % destination_zone_name.capitalize()
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

###################################################################
# travel to destination

func travel(player):
	if is_traveling:
		return

	if room:
		room.deactivate_cam_points()

	player.force_move_to_target(global_position)
	is_traveling = true
	z_index = 10
	travel_dest = [destination_zone_name, destination_travel_point_path]
	anim.play("closing")

###################################################################
# fancy exported destination vars

## Helper to clear the destination area/travel_point path
@export var clear: bool :
	set(v):
		clear = v
		if v:
			destination_zone_name = ""
			destination_travel_point_path = ""

var destination_zone_name: String :
	set(v):
		destination_zone_name = v
		notify_property_list_changed()

var destination_travel_point_path: String :
	set(v):
		destination_travel_point_path = v
		notify_property_list_changed()

func _get_property_list() -> Array:
	var dest_travel_point_usage = PROPERTY_USAGE_NO_EDITOR
	if not destination_zone_name == null and len(destination_zone_name) > 0:
		dest_travel_point_usage = PROPERTY_USAGE_DEFAULT

	return [{
			name = "destination_zone_name",
			type = TYPE_STRING,
			hint = PROPERTY_HINT_ENUM,
			hint_string = list_zone_names()
		}, {
			name = "destination_travel_point_path",
			type = TYPE_STRING,
			usage = dest_travel_point_usage,
			hint = PROPERTY_HINT_ENUM,
			hint_string = list_travel_point_paths()
		}]

func list_zone_names():
	var areas = Hotel.query({"group": Metro.zones_group})
	return ",".join(areas.map(func(area): return area.get("name")))

func travel_point_path(entry):
	var rm = str(entry.get("room_name")).replace(destination_zone_name, ".")
	var path = str(entry.get("path"))
	if path.contains(rm):
		return str(path)
	else:
		return str(rm.path_join(path)).replace("/./", "/")

func list_travel_point_paths():
	if destination_zone_name == null or len(destination_zone_name) == 0:
		return ""

	var travel_points = Hotel.query({
		"group": group_name,
		"zone_name": destination_zone_name,
		# TODO fix/restore/remove this?
		# exclude THIS travel_point
		# "filter": func(travel_point): return travel_point["name"] != name \
		# include this to avoid excluding travel_point nodes that aren't renamed
		# or name == "Elevator",
		})

	if len(travel_points) == 1:
		destination_travel_point_path = travel_point_path(travel_points[0])
		return destination_travel_point_path

	return ",".join(travel_points.map(travel_point_path))
