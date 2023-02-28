@tool
extends Node2D
# class_name MvaniaElevator

@onready var action_area = $ActionArea
@onready var anim = $AnimatedSprite2D

###################################################################
# ready

var actions = [
	Action.mk({label="Travel", fn=travel})
	]

func _ready():
	# TODO validate elevator destinations via MvaniaGame startup
	# there we can load all the areas and make sure elevator destinations can be loaded

	action_area.register_actions(actions, self)
	anim.animation_finished.connect(_on_anim_finished)

	z_index = 10
	anim.play("opening")

var travel_to_area

func _on_anim_finished():
	if anim.animation == "opening":
		z_index = 0
	if anim.animation == "closing":
		if travel_to_area:
			MvaniaGame.travel_to_area(travel_to_area, destination_elevator_path)
			traveling = false
		else:
			z_index = 0

###################################################################
# travel to destination

# TODO action to open door before travel action is available
# TODO close door when player walks away

var traveling
func travel():
	if traveling:
		return
	MvaniaGame.set_forced_movement_target(global_position)
	traveling = true
	z_index = 10
	travel_to_area = destination_area_full_path()
	anim.play("closing")

###################################################################
# fancy exported destination vars

## Helper to clear the destination area/elevator path
@export var clear: bool :
	set(v):
		clear = v
		if v:
			destination_area_str = ""
			destination_elevator_path = ""

var destination_area_str: String :
	set(v):
		destination_area_str = v
		notify_property_list_changed()
var destination_elevator_path: String :
	set(v):
		destination_elevator_path = v
		notify_property_list_changed()

# TODO refactor towards selecting an elevator from the game_db (MvaniaGame)
var maps_dir_path := "res://src/mvania19/maps"

func destination_area_full_path():
	return maps_dir_path.path_join(destination_area_str)

func _get_property_list() -> Array:
	var dest_elevator_usage = PROPERTY_USAGE_NO_EDITOR
	if not destination_area_str == null and len(destination_area_str) > 0:
		dest_elevator_usage = PROPERTY_USAGE_DEFAULT

	return [{
			name = "destination_area_str",
			type = TYPE_STRING,
			hint = PROPERTY_HINT_ENUM,
			hint_string = list_areas()
		}, {
			name = "destination_elevator_path",
			type = TYPE_STRING,
			usage = dest_elevator_usage,
			hint = PROPERTY_HINT_ENUM,
			hint_string = list_elevator_paths()
		}]

func list_areas():
	var area_paths = ""
	var maps_dir := DirAccess.open(maps_dir_path)
	if maps_dir:
		maps_dir.list_dir_begin()
		var file_name = maps_dir.get_next()
		while file_name != "":
			if maps_dir.current_is_dir():
				var area_dir = DirAccess.open(maps_dir_path.path_join(file_name))
				if area_dir:
					area_dir.list_dir_begin()
					var fname = area_dir.get_next()
					while fname != "":
						if fname.match("*Area0*"):
							area_paths += file_name.path_join(fname)
						fname = area_dir.get_next()
						area_paths += ","
			file_name = maps_dir.get_next()
	return area_paths

func list_elevator_paths():
	if destination_area_str == null or len(destination_area_str) == 0:
		return ""
	var area_file_path = destination_area_full_path()
	var elevator_paths = ""

	if owner.scene_file_path == area_file_path:
		# depends on elevators having an 'elevators' group
		for c in Util.get_children_in_group(owner, "elevators"):
			elevator_paths += str(owner.get_path_to(c)) + ","
		return elevator_paths

	# DANGER do not try to 'load' the current owner! (should return above)
	# if you do, the editor can crash while trying to save the scene.
	# technically a load is fine, but using get_state or instantiating can be problemmatic anyway
	var area_scene = load(area_file_path)
	if area_scene == null:
		Hood.warn("Failed to load area scene: ", area_file_path)
		return ""

	var scene_data = Util.packed_scene_data(area_scene, true)
	if scene_data:
		for node_state in scene_data.values():
			# depends on the Elevator instance name itself
			# maybe could check the instance properties for a group?
			if "Elevator" == node_state.get("instance_name"):
				var path = node_state["path"]
				elevator_paths += str(path).substr(2, -1) + ","

	return elevator_paths
