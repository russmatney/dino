@tool
extends Node2D

@onready var action_area = $ActionArea
@onready var anim = $AnimatedSprite2D

###################################################################
# ready

var actions = [
	# TODO action hint on elevator
	Action.mk({label_fn=get_dest_label, fn=travel})
	]

func get_dest_label():
	if destination_zone_name:
		return "To %s" % destination_zone_name.capitalize()
	else:
		return "Travel"

var room

func _ready():
	# TODO pass in validation function
	Hotel.register(self)

	action_area.register_actions(actions, {source=self})
	anim.animation_finished.connect(_on_anim_finished)

	z_index = 10
	anim.play("opening")

	var p = get_parent()
	if p is MetroRoom:
		room = p

func check_out(_data):
	pass

func hotel_data():
	return {
		destination_zone_name=destination_zone_name,
		destination_elevator_path=destination_elevator_path,
		}

var travel_dest

func _on_anim_finished():
	if anim.animation == "opening":
		z_index = 0
	if anim.animation == "closing":
		if travel_dest != null:
			Metro.travel_to(travel_dest[0], travel_dest[1])
			traveling = false
			travel_dest = null
		else:
			z_index = 0

###################################################################
# travel to destination

# TODO action to open door before travel action is available
# TODO close door when player walks away

var traveling
func travel(player):
	if traveling:
		return

	if room:
		room.deactivate_cam_points()

	player.force_move_to_target(global_position)
	traveling = true
	z_index = 10
	travel_dest = [destination_zone_name, destination_elevator_path]
	anim.play("closing")

###################################################################
# fancy exported destination vars

## Helper to clear the destination area/elevator path
@export var clear: bool :
	set(v):
		clear = v
		if v:
			destination_zone_name = ""
			destination_elevator_path = ""

var destination_zone_name: String :
	set(v):
		destination_zone_name = v
		notify_property_list_changed()

var destination_elevator_path: String :
	set(v):
		destination_elevator_path = v
		notify_property_list_changed()

func _get_property_list() -> Array:
	var dest_elevator_usage = PROPERTY_USAGE_NO_EDITOR
	if not destination_zone_name == null and len(destination_zone_name) > 0:
		dest_elevator_usage = PROPERTY_USAGE_DEFAULT

	return [{
			name = "destination_zone_name",
			type = TYPE_STRING,
			hint = PROPERTY_HINT_ENUM,
			hint_string = list_zone_names()
		}, {
			name = "destination_elevator_path",
			type = TYPE_STRING,
			usage = dest_elevator_usage,
			hint = PROPERTY_HINT_ENUM,
			hint_string = list_elevator_paths()
		}]

func list_zone_names():
	var areas = Hotel.query({"group": Metro.zones_group})
	return ",".join(areas.map(func(area): return area.get("name")))

func ele_path(entry):
	var rm = str(entry.get("room_name")).replace(destination_zone_name, ".")
	var path = str(entry.get("path"))
	if path.contains(rm):
		return str(path)
	else:
		return str(rm.path_join(path)).replace("/./", "/")

func list_elevator_paths():
	if destination_zone_name == null or len(destination_zone_name) == 0:
		return ""

	var elevators = Hotel.query({
		"group": "elevators",
		"zone_name": destination_zone_name,
		# exclude THIS elevator
		"filter": func(ele): return ele["name"] != name \
		# include this to avoid excluding elevator nodes that aren't renamed
		or name == "Elevator",
		})

	if len(elevators) == 1:
		destination_elevator_path = ele_path(elevators[0])
		return destination_elevator_path

	return ",".join(elevators.map(ele_path))
