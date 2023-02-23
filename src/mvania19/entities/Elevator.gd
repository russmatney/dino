@tool
extends Node2D

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
	# TODO switch player/elevator z-index
	if anim.animation == "opening":
		z_index = 0
	if anim.animation == "closing":
		if travel_to_area:
			MvaniaGame.travel_to_area(travel_to_area, destination_elevator_path)

###################################################################
# travel to destination

func travel():
	z_index = 10
	travel_to_area = destination_area_full_path()
	anim.play("closing")
	# play closed animation
	# do travel

###################################################################
# fancy exported destination vars

## Helper to clear the destination area/elevator path
@export var clear: bool :
	set(v):
		clear = v
		destination_area_str = ""
		destination_elevator_path = ""
		notify_property_list_changed()

var destination_area_str: String :
	set(v):
		destination_area_str = v
		notify_property_list_changed()
var destination_elevator_path: String :
	set(v):
		destination_elevator_path = v
		notify_property_list_changed()

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
	# TODO is there a way to see a scene's children/grandchildren without loading and instantiating?
	# _bundle is close but does not go across packed scenes (i.e. packed rooms in packed areas)
	# maybe could still traverse into those...
	var area_scene = load(area_file_path)
	var area_inst = area_scene.instantiate()
	var elevators = []
	if area_inst:
		elevators = Util.get_children_in_group(area_inst, "elevators")

	var e_paths = ""
	for e in elevators:
		var parent_name = e.get_parent().name
		if parent_name.match("*Area*"):
			e_paths += e.name + ","
		else:
			e_paths += parent_name + "/" + e.name + ","

	return e_paths
