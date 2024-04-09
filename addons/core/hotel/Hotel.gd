# Hotel is primarily a database.
# It wants to be a light-weight manager and api for live-updating game state.
# It supports HUD and minimap use-cases, and entity data lifecycles.
#
@tool
extends Node

## scene_db #####################################################################

## a dict of arbitrary scene properties. Built from static packed_scenes,
## updated using passed nodes and dicts.
var scene_db = {}

func recreate_db():
	Log.pr("not impled")

## keys #####################################################################

func _is_root(node):
	return node.has_method("is_hotel_root") and node.is_hotel_root()

func _node_to_entry_key(node):
	var parents
	if _is_root(node):
		parents = []
	elif node.get_tree() == null:
		Log.warn("No tree found for node...", node)
		parents = []
	else:
		parents = U.get_all_parents(node)
		# reverse so our join puts the furthest ancestor first
		parents.reverse()

		# remove nonsensy intermediary parents
		parents = parents.filter(func(node):
			return not node.name.begins_with("@@") and not node.name == "MainScreen")

	var name = node.name
	if node.has_method("hotel_key_suffix"):
		name = "%s%s" % [name, node.hotel_key_suffix()]

	return _to_entry_key(name, parents)

func _to_entry_key(name, parents=[]):
	var key = name

	var prefix = ""
	for p in parents:
		var parent_path = p.get("path")
		if parent_path == null or parent_path == ^".":
			parent_path = p.get("name")
		prefix = prefix.path_join(parent_path).replace(".", "").replace("//", "/")
		prefix = prefix.trim_prefix("/").trim_suffix("/")

	key = prefix.path_join(str(key).replace(".", ""))
	return key.trim_prefix("/").trim_suffix("/")

## write #####################################################################

## add a packed scene (and children) to the scene_db. Accepts PackedScene, a path to one (sfp), or a node.
func _book(node: Node):
	var key = _node_to_entry_key(node)

	var entry = {
		name=node.name,
		key=key,
		groups=node.get_groups(),
		cls=node.get_class(),
		# consider optional properties from a scene_file_path
		}

	if node.scene_file_path:
		entry["scene_file_path"] = node.scene_file_path

	if key in scene_db:
		scene_db[key].merge(entry)
	else:
		scene_db[key] = entry

## register #####################################################################

func register(node, opts={}):
	if not node.has_method("hotel_data"):
		Log.warn("skipping hotel register.", node, "missing expected hotel_data() method")
		return
	if not node.has_method("check_out"):
		Log.warn("skipping hotel register.", node, "missing expected check_out() method")
		return

	if not node.get_tree():
		Log.warn("skipping hotel register.", node, "Node not in a tree")
		return

	var key = _node_to_entry_key(node)
	if not key in scene_db:
		_book(node)

	# restore node state with data from hotel
	var data = check_out(node)
	if data == null:
		if not Engine.is_editor_hint():
			Log.warn("No data found for node.check_out(d): ", node, "passing empty dict.")
		data = {}

	if not Engine.is_editor_hint():
		node.check_out(data)

	# calls node.hotel_data(), stores the data in the db
	check_in(node)

## check_in #####################################################################

signal entry_updated(entry)

func _update(key, data):
	scene_db[key].merge(data, true)
	entry_updated.emit(scene_db[key])

## check-in more data using an instanced node. This is 'Hotel.update'.
func check_in(node: Node, data=null):
	if data == null:
		if node.has_method("hotel_data"):
			data = node.hotel_data()
		else:
			Log.warn(node, "does not implement hotel_data()")
			return

	var key = _node_to_entry_key(node)
	if key in scene_db:
		_update(key, data)
	else:
		Log.warn("Cannot check_in. No entry in scene_db for node/key: ", node, key)

## read #####################################################################

## Returns true if an entry for this node was found in the db
func has(node: Node):
	return _node_to_entry_key(node) in scene_db

## grab any stored properties from the scene_db
func check_out(node: Node):
	var key = _node_to_entry_key(node)
	if key in scene_db:
		return scene_db[key]
	else:
		Log.warn("Cannot check_out. No entry in scene_db for node: ", node, key)

## Flexible access to the scene_db vals
func query(q={}):
	var vals = scene_db.values()

	# consider opts for fetching with nodes?
	# if "node" in q:
	# 	return [check_out(q.node)]
	# if "nodes" in q:
	# 	vals = q.nodes.map(check_out)

	if "group" in q:
		vals = vals.filter(func (s_dict): return q.group in s_dict.get("groups", []))

	if "scene_file_path" in q:
		vals = vals.filter(func (s_dict): return q.scene_file_path == s_dict.get("scene_file_path"))

	if "has_group" in q:
		vals = vals.filter(func (s_dict): return len(s_dict.get("groups", [])) > 0)

	if "is_player" in q:
		vals = vals.filter(func (s_dict): return "player" in s_dict.get("groups", []))

	if "is_enemy" in q:
		vals = vals.filter(func (s_dict): return "enemies" in s_dict.get("groups", []))

	if "is_boss" in q:
		vals = vals.filter(func (s_dict): return "bosses" in s_dict.get("groups", []))

	if "is_root" in q:
		vals = vals.filter(func (s_dict): return s_dict.get("is_root"))

	if "filter" in q:
		vals = vals.filter(q["filter"])
	return vals

## mostly a debug helper, returns the first db entry
func first(q={}):
	var entries = query(q)
	if len(entries) > 0:
		return entries[0]
