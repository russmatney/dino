@tool
extends Node2D
# class_name MvaniaElevator

@onready var action_area = $ActionArea
@onready var anim = $AnimatedSprite2D

###################################################################
# ready

var actions = [
	Action.mk({label_fn=get_dest_label, fn=travel})
	]

func get_dest_label():
	if destination_area_name:
		return "To %s" % destination_area_name.capitalize()
	else:
		return "Travel"

var room

func _ready():
	# TODO pass in validation function
	Hotel.register(self)

	action_area.register_actions(actions, self)
	anim.animation_finished.connect(_on_anim_finished)

	z_index = 10
	anim.play("opening")

	var p = get_parent()
	if p is MvaniaRoom:
		room = p

func check_out(_data):
	pass

func hotel_data():
	return {
		destination_area_name=destination_area_name,
		destination_elevator_path=destination_elevator_path,
		}

var travel_dest

func _on_anim_finished():
	if anim.animation == "opening":
		z_index = 0
	if anim.animation == "closing":
		if travel_dest != null:
			MvaniaGame.travel_to(travel_dest[0], travel_dest[1])
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

	player.move_to_target(global_position)
	traveling = true
	z_index = 10
	travel_dest = [destination_area_name, destination_elevator_path]
	anim.play("closing")

###################################################################
# fancy exported destination vars

## Helper to clear the destination area/elevator path
@export var clear: bool :
	set(v):
		clear = v
		if v:
			destination_area_name = ""
			destination_elevator_path = ""

var destination_area_name: String :
	set(v):
		destination_area_name = v
		notify_property_list_changed()

var destination_elevator_path: String :
	set(v):
		destination_elevator_path = v
		notify_property_list_changed()

func _get_property_list() -> Array:
	var dest_elevator_usage = PROPERTY_USAGE_NO_EDITOR
	if not destination_area_name == null and len(destination_area_name) > 0:
		dest_elevator_usage = PROPERTY_USAGE_DEFAULT

	return [{
			name = "destination_area_name",
			type = TYPE_STRING,
			hint = PROPERTY_HINT_ENUM,
			hint_string = list_area_names()
		}, {
			name = "destination_elevator_path",
			type = TYPE_STRING,
			usage = dest_elevator_usage,
			hint = PROPERTY_HINT_ENUM,
			hint_string = list_elevator_paths()
		}]

func list_area_names():
	var areas = Hotel.query({"group": "mvania_areas"})
	return ",".join(areas.map(func(area): return area.get("name")))

func ele_path(entry):
	var rm = str(entry.get("room_name")).replace(destination_area_name, ".")
	var path = str(entry.get("path"))
	if path.contains(rm):
		return str(path)
	else:
		return str(rm.path_join(path)).replace("/./", "/")

func list_elevator_paths():
	if destination_area_name == null or len(destination_area_name) == 0:
		return ""

	var elevators = Hotel.query({
		"group": "elevators",
		"area_name": destination_area_name,
		# exclude THIS elevator
		"filter": func(ele): return ele["name"] != name \
		# include this to avoid excluding elevator nodes that aren't renamed
		or name == "Elevator",
		})

	if len(elevators) == 1:
		destination_elevator_path = ele_path(elevators[0])
		return destination_elevator_path

	return ",".join(elevators.map(ele_path))
