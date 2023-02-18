@tool
extends Area2D

var destination_area_str
var destination_elevator

var maps_dir_path := "res://src/mvania19/maps"

func destination_area_full_path():
	return maps_dir_path.path_join(destination_area_str)

func _get_property_list() -> Array: # Allows to make custom exports
	return [{
			name = "destination_area_str",
			type = TYPE_STRING,
			hint = PROPERTY_HINT_ENUM,
			hint_string = list_areas()
		}]

func list_areas(): # Simply lists the filenames in a folder
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
						if fname:
							area_paths += ","
			file_name = maps_dir.get_next()
	return area_paths

func _ready():
	# TODO validate elevator destinations
	pass # Replace with function body.
