@tool
extends Node
class_name U

############################################################
# misc

static func node_name_from_path(path):
	var parts = path.split("/")
	return parts[-1]

# TODO move to Log.gd ?
static func p_script_vars(node):
	for prop in node.get_property_list():
		if "usage" in prop and prop.get("usage") & PROPERTY_USAGE_SCRIPT_VARIABLE != 0:
			Log.info("\t", prop.get("name"), ": ", node.get(prop["name"]))

############################################################
# ready helpers

static func set_optional_nodes(node, node_map):
	for k in node_map:
		var val = node_map[k]
		if val is String:
			node[k] = node.get_node_or_null(node_map[k])
		# else:
		# 	# TODO this does not work (custom `class_name`s aren't exposed, and string vs static class)
		# 	# https://github.com/godotengine/godot/issues/21789
		# 	for ch in node.get_children():
		# 		if ch.get_class() == str(val):
		# 			node[k] = ch
		# 			break

############################################################
# nearby

# https://godotengine.org/qa/27869/how-to-get-the-nearest-object-in-a-group
static func nearest_node(source: Node, targets) -> Node:
	if targets == null or targets.size() == 0:
		return null

	# assume the first is closest
	var nearest_target = targets[0]

	# look through spawn nodes to see if any are closer
	for target in targets:
		if (
			target.global_position.distance_to(source.global_position)
			< nearest_target.global_position.distance_to(source.global_position)
		):
			nearest_target = target

	return nearest_target

static func are_points_close(a, b, diff=5):
	return abs(a.x - b.x) < diff and abs(a.y - b.y) < diff

static func are_nodes_close(a, b, diff=5):
	return are_points_close(a.global_position, b.global_position, diff)

############################################################
# groups

static func first_node_in_group(node, group_name: String) -> Node:
	if not node.is_inside_tree():
		var chs = get_children_in_group(node, group_name, true)
		if len(chs) > 0:
			return chs[0]
		Log.warn("No child in group found", node, group_name)
		return null
	for c in node.get_tree().get_nodes_in_group(group_name):
		return c
	return null


static func get_first_child_in_group(node: Node, group_name: String) -> Node:
	# only checks first children
	for c in node.get_children():
		if c.is_in_group(group_name):
			return c
	return null


static func get_children_in_group(node: Node, group_name: String, include_nested=true) -> Array:
	var in_group = []
	for c in node.get_children():
		if c.is_in_group(group_name):
			in_group.append(c)

		if include_nested:
			in_group.append_array(get_children_in_group(c, group_name, include_nested))
	return in_group

static func free_children_in_group(node: Node, group_name: String):
	if not node:
		return
	for c in node.get_children():
		if c.is_in_group(group_name):
			c.queue_free()

static func free_children(node: Node):
	if not node:
		return
	for c in node.get_children():
		c.queue_free()

# not sure what difference this makes
static func remove_children(node: Node, opts={}):
	for ch in node.get_children():
		if opts.get("defer", false):
			node.remove_child.call_deferred(ch)
			ch.queue_free()
		else:
			node.remove_child(ch)
			ch.queue_free()

############################################################
# children/parents/...siblings? familes?

static func get_children_by_name(node: Node):
	var by_name = {}
	for ch in node.get_children():
		by_name[ch.name] = ch
	return by_name

## Returns all of a node's parents EXCEPT the root.
static func get_all_parents(node: Node, parents=[]):
	if node == null:
		return []
	var p = node.get_parent()
	if p == node.get_tree().get_root():
		return parents
	if p:
		parents.append(p)
		return get_all_parents(p, parents)
	else:
		return parents

## Returns all of a node's children
static func get_all_children(node: Node):
	if node == null:
		return []
	var chs = []
	for ch in node.get_children():
		chs.append(ch)
		chs.append_array(get_all_children(ch))
	return chs

static func each_sibling(node: Node):
	var p = node.get_parent()
	return p.get_children().filter(func(ch): return ch != node)

static func ensure_owned_child(parent, var_name, node_name, cls):
	if parent.get(var_name) == null:
		parent.set(var_name, parent.get_node_or_null(node_name))
	if parent.get(var_name) == null:
		var node = cls.new()
		node.name = node_name
		parent.set(var_name, node)
		parent.add_child(node)
		node.set_owner(parent)


############################################################
# packed_scene reading

# Returns a dict full of data for the passed packed_scene or path to one.
# If a path is passed, the scene_file_path will be included as a property
# on the first dictionary (the root of the packed scene).
static func packed_scene_data(packed_scene_or_path, include_properties=false):
	var scene
	var sfp
	if packed_scene_or_path is String:
		scene = load(packed_scene_or_path)
		sfp = packed_scene_or_path
	elif packed_scene_or_path is PackedScene:
		scene = packed_scene_or_path
		sfp = packed_scene_or_path.resource_path
	else:
		Log.warn("unexpected packed_scene_data input", packed_scene_or_path)
	if not scene:
		Log.warn("could not create state in packed_scene_data", packed_scene_or_path)
		return
	var state = scene.get_state()
	var by_path = {}
	for node_idx in state.get_node_count():
		var path = state.get_node_path(node_idx)
		var node_data = {
			"name": state.get_node_name(node_idx),
			"type": state.get_node_type(node_idx),
			"owner_path": state.get_node_owner_path(node_idx),
			"path": state.get_node_path(node_idx),
			"groups": state.get_node_groups(node_idx),
			}

		var node_instance = state.get_node_instance(node_idx)
		if node_instance:
			node_data["instance"] = packed_scene_data(node_instance, include_properties)
			node_data["instance_name"] = node_instance.get_state().get_node_name(0)

		var prop_count = 0
		if include_properties:
			prop_count = state.get_node_property_count(node_idx)
		var properties = {}
		for prop_idx in prop_count:
			var prop_name = state.get_node_property_name(node_idx, prop_idx)
			var prop_val = state.get_node_property_value(node_idx, prop_idx)
			properties[prop_name] = prop_val
		node_data["properties"] = properties

		# hack to get scene_file_path on packed scene data
		if sfp and node_data["path"] == ^".":
			node_data["properties"]["scene_file_path"] = sfp

		by_path[path] = node_data
	return by_path

static func to_scene_path(path_or_scene):
	var path
	if path_or_scene is String:
		path = path_or_scene
	elif path_or_scene is PackedScene:
		path = path_or_scene.resource_path
	else:
		Log.warn("Unrecognized type in to_scene_path", path_or_scene)
	return path

############################################################
# collisions

# https://github.com/godotengine/godot-proposals/issues/3424#issuecomment-943703969
# unconfirmed
static func set_collisions_enabled(node, enabled):
	if enabled:
		if node.has_meta("col_mask"):
			node.collision_mask = node.get_meta("col_mask")
			node.collision_layer = node.get_meta("col_layer")
	else:
		node.set_meta("col_mask", node.collision_mask)
		node.set_meta("col_layer", node.collision_layer)
		node.collision_mask = 0
		node.collision_layer = 0

############################################################
# connections

# NOTE connections can be deferred or one_shot via ConnectFlags
static func _connect(sig, callable, flags=null):
	if sig == null:
		Log.warn("Could not connect null signal")
		return
	if sig.is_connected(callable):
		return
	var err
	if flags:
		err = sig.connect(callable, flags)
	else:
		err = sig.connect(callable)
	if err:
		Log.error("error in _connect()", err, sig, callable)  # useless enum digit

static func call_in(node, callable, s):
	if not callable.is_valid():
		Log.warn("callable is not valid!!")
		return
	await node.get_tree().create_timer(s).timeout
	var obj = callable.get_object()
	if obj and is_instance_valid(obj) and not callable.is_null():
		callable.call()

############################################################
# menus/buttons/popup

static func setup_popup_items(popup: PopupMenu, items: Array, on_select: Callable):
	# clear items
	popup.clear()

	# clear connections
	for conn in popup.index_pressed.get_connections():
		popup.index_pressed.disconnect(conn.callable)

	# add items using item.label
	for item in items:
		popup.add_item(item.label)

	# when selected
	popup.index_pressed.connect(func(index):
		# call passed func with selected item
		on_select.call(items[index]), CONNECT_ONE_SHOT)


############################################################
## repeate/random ###########################################################

static func repeat(s, n):
	return range(n).map(func(_x): return s)

static func repeat_fn(callable, n):
	return range(n).map(func(_x): return callable.call())

static func rand_of(arr, n=null, force_list=false):
	if len(arr) == 0:
	# 	push_warning("U.rand_of passed empty array")
		return
	arr.shuffle()
	if n == null and not force_list:
		return arr[0]
	if n == null:
		# forcing a list and no n specified?
		n = 1
	return arr.slice(0, n)

static func set_random_frame(anim):
	anim.frame = randi() % anim.sprite_frames.get_frame_count(anim.animation)

## misc functional ###########################################################

static func _or(a, b = null, c = null, d = null, e = null):
	if a:
		return a
	if b:
		return b
	if c:
		return c
	if d:
		return d
	if e:
		return e

static func _and(a, b = null, c = null, d = null, e = null):
	# expand impl to support 5 inputs
	# support vars as callables, call if previous were non-nil
	if a != null and b != null:
		return b

# could be more efficient
# https://github.com/godotengine/godot-proposals/issues/3116#issuecomment-1363222780
static func remove_matching(arr, to_remove):
	return arr.filter(func(a): return a in to_remove)

static func min_of(arr, to_val, default=null):
	var m
	for x in arr:
		var val = to_val.call(x)
		if m == null:
			m = val
		if val < m:
			m = val
	if m == null:
		return default
	return m

static func max_of(arr, to_val, default=null):
	var m
	for x in arr:
		var val = to_val.call(x)
		if m == null:
			m = val
		if val > m:
			m = val
	if m == null:
		return default
	return m

static func flatten(arr):
	return arr.reduce(func(acc, xs):
		acc.append_array(xs)
		return acc, [])

static func flat_map(arr, to_xs):
	return U.flatten(arr.map(to_xs))

# a reverse that returns the updated array
static func reverse(arr):
	arr.reverse()
	return arr

############################################################
# Facing

static func update_h_flip(facing, node):
	if not node:
		return
	if facing.x > 0 and node.position.x <= 0:
		node.position.x = -node.position.x
		# forces positive x scale
		if node.scale.x < 0:
			node.scale.x = abs(node.scale.x)
	elif facing.x < 0 and node.position.x >= 0:
		node.position.x = -node.position.x
		# forces negative x scale
		if node.scale.x > 0:
			node.scale.x = -1 * abs(node.scale.x)

static func update_los_facing(facing, node):
	if not node:
		return
	if facing.x > 0 and node.target_position.y > 0:
		node.target_position.y = -node.target_position.y
	elif facing.x < 0 and node.target_position.y < 0:
		node.target_position.y = -node.target_position.y


#################################################################
## Animations

static func animate_rotate(node):
	if not node.is_inside_tree():
		return
	var tween = node.create_tween()
	tween.set_loops(0)
	tween.tween_property(node.anim, "rotation", node.rotation + PI / 8, 0.3).set_ease(Tween.EASE_IN_OUT).set_trans(
		Tween.TRANS_CUBIC
	)
	tween.tween_property(node.anim, "rotation", node.rotation - PI / 8, 0.3).set_ease(Tween.EASE_IN_OUT).set_trans(
		Tween.TRANS_CUBIC
	)
	tween.tween_interval(randf_range(0.1, 0.4))


static func animate(node):
	if not node.is_inside_tree():
		return
	var n = 10
	var og_pos = node.position
	var rand_offset = Vector2(randi() % n - n / 2.0, randi() % n - n / 2.0)
	var tween = node.create_tween()

	tween.set_loops(0)
	tween.tween_property(node, "position", node.position + rand_offset, 0.3).set_ease(Tween.EASE_IN_OUT).set_trans(
		Tween.TRANS_CUBIC
	)
	tween.tween_property(node, "position", og_pos, 0.3).set_ease(Tween.EASE_IN_OUT).set_trans(
		Tween.TRANS_CUBIC
	)
	tween.tween_interval(randf_range(0.3, 2.0))

#################################################################
## AnimatedSprite2D

# plays the passed animation, then returns to the previous animation
# NOTE the passed animation cannot be looping, or animation_finished will never fire
static func play_then_return(anim, animation):
	var current_anim = anim.animation
	anim.animation_finished.connect(func():
		anim.play(current_anim),
		ConnectFlags.CONNECT_ONE_SHOT)
	anim.play(animation)

#################################################################
## dictionaries

# A get that:
# - returns `default` if the value for key `k` in dict `d` is null.
# - returns null if the value is a freed object (instead of crashing)
# - returns null if both the value and default are invalid instances
static func get_(d, k: String, default: Variant=null):
	if d == null:
		return default

	var v
	if k in d:
		v = d[k]

	if v != null:
		if not is_instance_valid(v):
			if is_instance_valid(default):
				return default
		return v
	else:
		return default

static func ensure_default(d, k: String, default: Variant):
	if d == null:
		return {k=default}

	if k in d and d.get(k) != null:
		# k already set, do nothing
		return d

	# set (in-place!) and return the whole dict
	d[k] = default
	return d

static func merge(d, kv):
	var new_d = d.duplicate()
	new_d.merge(kv)
	return new_d

#################################################################
## arrays

static func append(arr, x):
	arr.append(x)
	return arr

static func append_array(a, b):
	var arr = []
	if a:
		arr.append_array(a)
	if b:
		arr.append_array(b)
	return arr

static func distinct(arr):
	var exists = {}
	var out = []
	for x in arr:
		if exists.get(x):
			continue
		exists[x] = true
		out.append(x)
	return out

#################################################################
## Configuration warnings

static func _config_warning(node, opts={}):
	var warns = []
	for node_name in opts.get("expected_nodes", []):
		var n = node.find_child(node_name)
		if n == null:
			warns.append("Expected child named '" + node_name + "'")
	for node_name in opts.get("expected_animations", {}).keys():
		var n = node.find_child(node_name)
		if n != null:
			var animations = n.sprite_frames.get_animation_names()
			for animation in opts["expected_animations"][node_name]:
				if animation not in animations:
					warns.append("Expected animation named '%s' in node '%s'" % [animation, node_name])

	return warns

#################################################################
## process mode/pausing

static func toggle_pause_nodes(should_pause=null, nodes=[]):
	if nodes.is_empty():
		return
	var first_node = nodes[0]
	var proc_mode = null
	if should_pause == null:
		if first_node.process_mode == Node.PROCESS_MODE_DISABLED:
			proc_mode = Node.PROCESS_MODE_INHERIT
		else:
			proc_mode = Node.PROCESS_MODE_DISABLED
	elif should_pause:
		proc_mode = Node.PROCESS_MODE_DISABLED
	else:
		proc_mode = Node.PROCESS_MODE_INHERIT

	for node in nodes:
		if is_instance_valid(node):
			node.set_process_mode(proc_mode)

#################################################################
## func

static func first(list):
	if list != null and len(list) > 0:
		return list[0]

static func sum(vals):
	return vals.reduce(func(agg, x): return x + agg)

static func average(vals):
	if len(vals) == 0:
		return

	if vals[0] is Vector2:
		var mid = Vector2()
		mid.x = average(vals.map(func(c): return c.x))
		mid.y = average(vals.map(func(c): return c.y))
		return mid
	else:
		return sum(vals)/len(vals)

# control/theme helpers

static func update_stylebox(node, stylebox_name, fn):
	var stylebox = node.get_theme_stylebox(stylebox_name).duplicate()
	fn.call(stylebox)
	node.add_theme_stylebox_override(stylebox_name, stylebox)


static func add_color_rect(node: Node, opts: Dictionary) -> ColorRect:
	var color = opts.get("color", Color())
	var rect = opts.get("rect")
	var pos = opts.get("position", Vector2())
	var size = opts.get("size", Vector2())
	var name = opts.get("name")
	if rect:
		pos = rect.position
		size = rect.size
	var crect = ColorRect.new()
	if name:
		crect.name = name
	crect.color = color
	crect.position = pos
	crect.size = size
	node.add_child(crect)
	return crect

########################################################

static func ensure_node(_self, nm):
	var node = _self.get_node_or_null(nm)
	if node == null:
		node = Node2D.new()
		_self.add_child(node)
	return node

# walks the node's parents until it finds one that implements `add_child_to_level`.
# if none is found, adds the child to the 'current_scene'
static func add_child_to_level(node, child, deferred=true):
	var level = find_level_root(node)
	if level.has_method("add_child_to_level"):
		if deferred:
			level.add_child_to_level.call_deferred(level, child)
		else:
			level.add_child_to_level(level, child)
	else:
		if deferred:
			level.add_child.call_deferred(child)
		else:
			level.add_child(child)

# returns the first parent node that impls add_child_to_level (i.e. the level root)
# otherwise returns the root's current_scene
static func find_level_root(node):
	# TODO consider faster impls - like getting nodes in a group
	# in that case, just be sure it's actually an ancestor of the passed node
	var parent = node.get_parent()
	if parent == null:
		var t = node.get_tree()
		if t == null:
			return Navi.get_tree().current_scene
		else:
			return node.get_tree().current_scene
	elif parent.has_method("add_child_to_level"):
		return parent
	else:
		return find_level_root(parent)

## focus ######################################################

static func has_focus(node: Node) -> bool:
	if node.has_focus():
		return true
	else:
		for ch in node.get_children():
			if U.has_focus(ch):
				return true
	return false

static func get_focusable_children(container: Node) -> Array[Node]:
	var chs: Array[Node] = []
	for ch in container.get_children():
		if ch is Control and ch.focus_mode != Control.FOCUS_NONE:
			chs.append_array(get_focusable_children(ch))
	return chs


static func focus_first_control(container: Node) -> void:
	for child in get_focusable_children(container):
		child.grab_focus()
