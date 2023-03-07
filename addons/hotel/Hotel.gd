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

## a dict of arbitrary scene properties. Built from static packed_scenes,
## updated using passed nodes and dicts.
var scene_db = {}

func drop_db():
	Debug.warn("Dropping scene_db")
	scene_db = {}

######################################################################
# key

func node_to_entry_key(node):
	var parents = Util.get_all_parents(node)
	# reverse so our join puts the furthest ancestor first
	parents.reverse()
	if Engine.is_editor_hint():
		# remove nonsensy intermediary parents in editor
		parents = parents.filter(func(node):
			return not node.name.begins_with("@@") and not node.name == "MainScreen")
	var key = to_entry_key({path=node.name}, parents)
	return key

## converts the passed data dict and parents list into a path from area to the current scene
func to_entry_key(data, parents=[]):
	var prefix = ""
	for p in parents:
		var parent_path = p.get("path")
		if parent_path == null or parent_path == ^".":
			parent_path = p.get("name")
		prefix = prefix.path_join(parent_path).replace(".", "").replace("//", "/")
		prefix = prefix.trim_prefix("/").trim_suffix("/")
	var key = prefix.path_join(str(data.get("path")).replace(".", ""))
	return key.trim_prefix("/").trim_suffix("/")

######################################################################
# write

## add a packed scene (and children) to the scene_db. Accepts PackedScene or a path to one (sfp).
func book(packed_scene_or_path: Variant):
	var data = Util.packed_scene_data(packed_scene_or_path)
	book_data(data)

func book_data(data: Dictionary, parents = null):
	# TODO opt-in with group or duck-typing?
	var scene_name = data[^"."]["name"]

	if parents == null:
		parents = [data.values()[0]]

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

######################################################################
# checkin

## check-in some data that wasn't in the packed_scene
func check_in(node: Node, data=null):
	# TODO minimize updates by comparing key/vals?

	if data == null:
		if node.has_method("hotel_data"):
			data = node.hotel_data()
		else:
			Debug.warn(node, "does not implement hotel_data()")

	var key = node_to_entry_key(node)
	if key in scene_db:
		Debug.pr("Checking in data", node, data)
		scene_db[key].merge(data, true)
	else:
		Debug.warn("Cannot check_in. No entry in scene_db for node/key: ", node, key)

######################################################################
# read

## Returns true if an entry for this node was found in the db
func has(node: Node):
	return node_to_entry_key(node) in scene_db

## grab any stored properties from the scene_db
func check_out(node: Node):
	var key = node_to_entry_key(node)
	if key in scene_db:
		return scene_db[key]
	else:
		Debug.warn("Cannot check_out. No entry in scene_db for node: ", node, key)

## General access to the scene_db
func query(opts={}):
	var vals = scene_db.values()
	if "group" in opts:
		vals = vals.filter(func (s_dict): return opts["group"] in s_dict["groups"])

	# TODO make this work
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
