# Hotel is so-named because it is intended as a Room manager
# 'Room' being a game unit, specifically the level I want to design at
# A group of rooms is gathered into an 'Area'
#
# Hotel is primarily a database.
# It wants to be a light-weight manager for game state.
#
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

func to_entry_key(data, parents=[]):
	var prefix = ""
	for p in parents:
		var parent_path = p.get("path")
		if parent_path == ^".":
			parent_path = p.get("name")
		prefix = prefix.path_join(parent_path).replace(".", "").replace("//", "/")
		prefix = prefix.trim_prefix("/").trim_suffix("/")
	var key = prefix.path_join(str(data.get("path")).replace(".", ""))
	return key.trim_prefix("/").trim_suffix("/")

######################################################################
# write

# TODO use 'register' or 'book' for static, packedScene data, 'check-in' from _ready for instances
# register/book should _never_ overwrite values (unless explicitly told to do so)
# check-in adds an object_id and makes it simple to pull from and write to the db later
# maybe consider an frp/eventy/reframey framework

## add a packed scene (and children) to the scene_db. Accepts PackedScene or a path to one (sfp).
func book(scene: Variant):
	var sfp
	if scene is String:
		sfp = scene
		scene = load(sfp)
	elif scene is PackedScene:
		# TODO can we get scene_file_path from an already loaded packed scene?
		sfp = null

	var data = Util.packed_scene_data(scene)

	if sfp:
		# ugh!
		data[^"."]["scene_file_path"] = sfp

	book_data(data)

func book_data(data: Dictionary, parents = null):
	var scene_name = data[^"."]["name"]

	if parents == null:
		parents = [data.values()[0]]

	# TODO get/pass parents to root (not possible without instance?)

	for path in data.keys():
		var ps = parents.duplicate()
		var d = data.get(path)
		var key = to_entry_key(d, ps)
		var entry = d.get("properties", {})

		entry.merge({
			path=path,
			key=key,
			groups=d.get("groups", []),
			name=d.get("name"),
			type=d.get("type"),
			})

		if d.get("scene_file_path"):
			entry["scene_file_path"] = scene_file_path

		if "script" in entry:
			entry["script_path"] = entry["script"].resource_path

		if "instance_name" in d:
			entry["instance_name"] = d["instance_name"]

		if "instance" in d:
			var inst = d["instance"][^"."]
			entry["groups"].append_array(inst["groups"])

			for k in inst.get("properties", {}).keys():
				if not k in entry:
					entry[k] = inst["properties"][k]

			if "properties" in inst and "script" in inst["properties"] and not "script_path" in entry:
				entry["script_path"] = inst["properties"]["script"].resource_path

			# TODO update/add to this dict before recursing?
			# is it ok for this to book first?
			ps.append(entry)
			book_data(d["instance"], ps)

		if key in scene_db:
			# TODO expose flag to support overwriting
			scene_db[key].merge(entry)
		else:
			scene_db[key] = entry


## add a packed scene (and children) to the scene_db
func book_area(scene: PackedScene):
	var scene_data = Util.packed_scene_data(scene, true)
	var area_name = scene_data[^"."]["name"]
	Debug.prn("Booking area", area_name)
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
			# indeed - this misses elevators in instanced-rooms
			# should we dig for it here, or should we register/book elevators/entities independently?
			# It might be better to give entities (enemies, action-detectors) their own
			# registration/data life-cycle handling

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

######################################################################
# drop

func drop_db():
	Debug.warn("Dropping scene_db")
	scene_db = {}

######################################################################
# update

## update relevant properties stored in the scene_db
## TODO help nodes register so they can update without area/path_name
func update(area_name: String, path: String = "", update: Dictionary = {}):
	Debug.pr("Update:", area_name, path)
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

# query
func query(opts={}):
	var vals = scene_db.values()
	if "group" in opts:
		vals = vals.filter(func (s_dict): return opts["group"] in s_dict["groups"])
	if "area_name" in opts:
		vals = vals.filter(func (s_dict): return opts["area_name"] == s_dict["area_name"])
	if "filter" in opts:
		vals = vals.filter(opts["filter"])
	return vals

## mostly a debug helper, returns the first db entry
func first():
	var entries = query()
	if len(entries) > 0:
		return entries[0]

## grab a list of scene data dicts that belong to the passed group
func check_out_for_group(group: String):
	return scene_db.values().filter(func (s_dict): return group in s_dict["groups"])

## grab a list of scene data dicts that belong to the passed group
func check_out_for_area_and_group(area_name: String, group: String):
	return scene_db.values()\
		.filter(func (s_dict): return area_name == s_dict["area_name"])\
		.filter(func (s_dict): return group in s_dict["groups"])
