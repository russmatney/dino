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

func db_key(area_name, path):
	return str(area_name).path_join(str(path).replace(".", ""))

func node_to_entry_key(node):
	var parents = Util.get_all_parents(node)
	Debug.pr("to entry key", node.name, parents)
	var key = to_entry_key({path=node.name}, parents)
	Debug.pr("node to entry key", node, key)
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

######################################################################
# update

## update relevant properties stored in the scene_db
func update(node: Node, update: Dictionary = {}):
	Debug.pr("Updating node:", node)
	# TODO minimize updates by comparing key/vals?

	var key = node_to_entry_key(node)
	if key in scene_db:
		scene_db[key].merge(update, true)
	else:
		Debug.warn("No entry in scene_db for node: ", node)

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
		Debug.warn("No entry in scene_db for node: ", node)

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
