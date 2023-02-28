@tool
extends Node

func _enter_tree():
	Debug.prn("Hotel entered tree")

func _ready():
	Debug.prn("Hotel ready")

######################################################################
# scene_db

## a dict of arbitrary scene properties with a composite area + node_path key
##
## scenes are any properties
var scene_db = {}

func db_key(area_name, path):
	return str(area_name).path_join(str(path).replace(".", ""))

######################################################################
# write

## add a packed scene (and children) to the scene_db
func check_in(scene: PackedScene):
	# TODO impl
	pass

## add a packed scene (and children) to the scene_db
func check_in_area(scene: PackedScene):
	var scene_data = Util.packed_scene_data(scene, true)
	var area_name = scene_data[^"."]["name"]
	Debug.prn("checking in area", area_name)
	for path in scene_data.keys():
		var d = scene_data[path]
		var key = db_key(area_name, path)

		# we may not want to overwrite properties
		# q, how to mix with 'saved' data states
		var db_data = d["properties"]

		db_data["area_name"] = area_name
		db_data["path"] = path
		db_data["key"] = key

		db_data["groups"] = d.get("groups", [])
		db_data["name"] = d["name"]

		if d["type"]:
			db_data["type"] = d["type"]

		if "script" in d["properties"]:
			db_data["script_path"] = d["properties"]["script"].resource_path

		if "instance" in d:
			# TODO lift and store nested instance data too?
			# maybe opt-in with groups? will need to traverse to check them...
			# probably need to do this if we have room instances...
			var inst = d["instance"][^"."]
			db_data["groups"].append_array(inst["groups"])

			for k in inst.get("properties", {}).keys():
				if not k in db_data:
					db_data[k] = inst["properties"][k]

			if "properties" in inst and "script" in inst["properties"] and not "script_path" in db_data:
				db_data["script_path"] = inst["properties"]["script"].resource_path

		if "instance_name" in d:
			db_data["instance_name"] = d["instance_name"]

		scene_db[key] = db_data

## update relevant properties stored in the scene_db
## TODO help nodes register so they can update without area/path_name
func update(area_name: String, path: String = "", update: Dictionary = {}):
	Debug.pr("updating", area_name, path)
	# TODO minimize updates?
	# Debug.pr("updating", area_name, path, update)
	var key = db_key(area_name, path)
	if key in scene_db:
		scene_db[key].merge(update, true)
	else:
		if path:
			Debug.warn("No area_name + path in scene_db: ", area_name, " ", path)
		else:
			Debug.warn("No area_name in scene_db: ", area_name)

######################################################################
# read

func has(area_name: String, path: String = ""):
	return db_key(area_name, path) in scene_db

## grab any stored properties from the scene_db
func check_out(area_name: String, path: String = ""):
	var key = db_key(area_name, path)
	if key in scene_db:
		return scene_db[key]
	else:
		if path:
			Debug.warn("No area_name + path in scene_db: ", area_name, " ", path)
		else:
			Debug.warn("No area_name in scene_db: ", area_name)

## grab a list of scene data dicts that belong to the passed group
func check_out_for_group(group: String):
	return scene_db.values().filter(func (s_dict): return group in s_dict["groups"])

## grab a list of scene data dicts that belong to the passed group
func check_out_for_area_and_group(area_name: String, group: String):
	return scene_db.values()\
		.filter(func (s_dict): return area_name == s_dict["area_name"])\
		.filter(func (s_dict): return group in s_dict["groups"])
