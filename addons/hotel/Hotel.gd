# Hotel is so-named because it is intended as a Room manager
# 'Room' being a game unit, specifically the level I want to design at
# A group of rooms is gathered into an 'Zone'. (These are MetroRoom
# and MetroZones for now)
#
# Hotel is primarily a database.
# It wants to be a light-weight manager for game state.
#
@tool
extends Node

func _enter_tree():
	Debug.prn("<Hotel>")

func _exit_tree():
	Debug.prn("</Hotel>")

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

var hotel_root_group_name = "hotel_singletons"
var root_groups = [Metro.zones_group, "player", hotel_root_group_name]

func is_in_root_group(x):
	if x is Dictionary:
		if "groups" in x:
			return root_groups.any(func(g): return g in x["groups"])
	elif x.has_method("is_in_group"):
		return root_groups.any(func(g): return x.is_in_group(g))

func node_to_entry_key(node):
	var parents
	if is_in_root_group(node):
		parents = []
	else:
		parents = Util.get_all_parents(node)
		# reverse so our join puts the furthest ancestor first
		parents.reverse()
		if Engine.is_editor_hint():
			# remove nonsensy intermediary parents in editor
			parents = parents.filter(func(node):
				return not node.name.begins_with("@@") and not node.name == "MainScreen")
	var key = to_entry_key({path=node.name}, parents)
	return key

## converts the passed data dict and parents list into a path from zone to the current scene
func to_entry_key(data, parents=[]):
	var key = data.get("path")
	if is_in_root_group(data):
		parents = []
		key = data.get("name")

	var prefix = ""
	for p in parents:
		var parent_path = p.get("path")
		if parent_path == null or parent_path == ^".":
			parent_path = p.get("name")
		prefix = prefix.path_join(parent_path).replace(".", "").replace("//", "/")
		prefix = prefix.trim_prefix("/").trim_suffix("/")

	key = prefix.path_join(str(key).replace(".", ""))
	return key.trim_prefix("/").trim_suffix("/")

######################################################################
# write

## add a packed scene (and children) to the scene_db. Accepts PackedScene or a path to one (sfp).
func book(packed_scene_or_path: Variant):
	var data = Util.packed_scene_data(packed_scene_or_path)
	book_data(data)

func book_data(data: Dictionary, parents = null, last_room = null):
	var scene_name = data[^"."]["name"]

	if parents == null:
		parents = [data.values()[0]]

	for path in data.keys():
		var ps = parents.duplicate()
		var d = data.get(path)
		var key = to_entry_key(d, ps)

		# basic properties
		var entry = d.get("properties", {})

		# basic metadata
		entry.merge({path=path, key=key, name=d.get("name")})

		if d.get("type"):
			entry["type"] = d.get("type")

		# instance properties
		if "instance" in d:
			var inst = d["instance"][^"."]

			for k in inst.get("properties", {}).keys():
				if not k in entry:
					entry[k] = inst["properties"][k]

		# groups
		entry["groups"] = d.get("groups", [])
		if "instance" in d:
			var inst = d["instance"][^"."]
			entry["groups"].append_array(inst["groups"])

		# update last_room based on groups
		if Metro.rooms_group in entry["groups"]:
			last_room = entry

		# set script data
		if "script" in entry:
			entry["script_path"] = entry["script"].resource_path
		if "instance" in d:
			var inst = d["instance"][^"."]
			if "properties" in inst and "script" in inst["properties"] and not "script_path" in entry:
				entry["script_path"] = inst["properties"]["script"].resource_path

		# instance name
		if "instance_name" in d:
			entry["instance_name"] = d["instance_name"]

		# set zone and room names via parents
		for p in ps:
			if Metro.zones_group in p["groups"]:
				entry["zone_name"] = p["name"]

		for p in ps:
			if Metro.rooms_group in p["groups"]:
				entry["room_name"] = str(p["zone_name"], "/", p["name"])

		# set room name for non-room-instance children (which are flattened here)
		if not "room_name" in entry and last_room != null:
			if key.contains(last_room["key"]):
				entry["room_name"] = last_room["key"]

		if key in scene_db:
			scene_db[key].merge(entry)
		else:
			scene_db[key] = entry

		# recurse into instances
		# we do this AFTER updating scene_db to prevent instance overwriting
		if "instance" in d:
			ps.append(entry)
			book_data(d["instance"], ps, last_room)

######################################################################
# register

func register(node, opts={}):
	if not node.has_method("hotel_data"):
		Debug.warn("skipping hotel register.", node, "missing expected hotel_data() method")
		return
	if not node.has_method("check_out"):
		Debug.warn("skipping hotel register.", node, "missing expected check_out() method")
		return

	# TODO consider booking if this node hasn't been found in the db?
	# maybe only for "root" elems that can store themselves?
	# OR, maybe any node should be able to book itself, b/c we can pull in parent detail/path
	# at _ready time without issue

	if opts.get("root", false):
		node.add_to_group(hotel_root_group_name, true)

	# restore node state with data from hotel
	var data = check_out(node)
	if data == null:
		if not Engine.is_editor_hint():
			Debug.warn("No data found for node: ", node, "passing empty dict.")
		data = {}
	node.check_out(data)

	# calls node.hotel_data(), stores the data in the db
	check_in(node)

	# Hood.dev_notif(node, "Registered")

######################################################################
# checkin

signal entry_updated(entry)

func update(key, data):
	scene_db[key].merge(data, true)
	entry_updated.emit(scene_db[key])

## check-in more data using an instanced node. This is 'Hotel.update'.
func check_in(node: Node, data=null):
	if data == null:
		if node.has_method("hotel_data"):
			data = node.hotel_data()
		else:
			Debug.warn(node, "does not implement hotel_data()")

	var key = node_to_entry_key(node)
	if key in scene_db:
		update(key, data)
	else:
		if not Engine.is_editor_hint():
			Debug.warn("Cannot check_in. No entry in scene_db for node/key: ", node, key)

func check_in_sfp(sfp: String, data: Dictionary):
	var entry = first({scene_file_path=sfp})
	if entry == null:
		Debug.warn("No entry for sfp found", sfp)
	var k = entry.get("key")
	if k in scene_db:
		update(k, data)
	else:
		Debug.warn("No entry for key (via sfp) found", sfp, k)

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
		if not Engine.is_editor_hint():
			Debug.warn("Cannot check_out. No entry in scene_db for node: ", node, key)

## Flexible access to the scene_db vals
func query(q={}):
	var vals = scene_db.values()
	if "group" in q:
		vals = vals.filter(func (s_dict): return q["group"] in s_dict.get("groups", []))

	if "zone_name" in q:
		vals = vals.filter(func (s_dict): return q["zone_name"] == s_dict.get("zone_name"))

	if "room_name" in q:
		vals = vals.filter(func (s_dict): return q["room_name"] == s_dict.get("room_name"))

	if "has_group" in q:
		vals = vals.filter(func (s_dict): return len(s_dict.get("groups", [])) > 0)

	if "is_player" in q:
		vals = vals.filter(func (s_dict): return "player" in s_dict.get("groups", []))

	if "is_enemy" in q:
		vals = vals.filter(func (s_dict): return "enemies" in s_dict.get("groups", []))

	if "is_boss" in q:
		vals = vals.filter(func (s_dict): return "bosses" in s_dict.get("groups", []))

	if "is_root" in q:
		vals = vals.filter(func (s_dict): return is_in_root_group(s_dict))

	if "filter" in q:
		vals = vals.filter(q["filter"])
	return vals

## mostly a debug helper, returns the first db entry
func first(q={}):
	var entries = query(q)
	if len(entries) > 0:
		return entries[0]
