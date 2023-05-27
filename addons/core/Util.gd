@tool
extends Node

############################################################
# misc

func node_name_from_path(path):
	var parts = path.split("/")
	return parts[-1]

func p_script_vars(node):
	for prop in node.get_property_list():
		if "usage" in prop and prop["usage"] & PROPERTY_USAGE_SCRIPT_VARIABLE != 0:
			Debug.pr("\t", prop["name"], ": ", self.get(prop["name"]))

############################################################
# ready helpers

func set_optional_nodes(node, node_map):
	for k in node_map:
		node[k] = node.get_node_or_null(node_map[k])

############################################################
# nearby

# https://godotengine.org/qa/27869/how-to-get-the-nearest-object-in-a-group
func nearest_node(source: Node, targets) -> Node:
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

func are_points_close(a, b, diff=5):
	return abs(a.x - b.x) < diff and abs(a.y - b.y) < diff

func are_nodes_close(a, b, diff=5):
	return are_points_close(a.global_position, b.global_position, diff)

############################################################
# groups

func first_node_in_group(group_name: String) -> Node:
	for c in get_tree().get_nodes_in_group(group_name):
		return c
	return null


func get_first_child_in_group(node: Node, group_name: String) -> Node:
	# only checks first children
	for c in node.get_children():
		if c.is_in_group(group_name):
			return c
	return null


func get_children_in_group(node: Node, group_name: String, include_nested=true) -> Array:
	var in_group = []
	for c in node.get_children():
		if c.is_in_group(group_name):
			in_group.append(c)

		if include_nested:
			in_group.append_array(get_children_in_group(c, group_name, include_nested))
	return in_group

############################################################
# children/parents/...siblings?

func change_parent(child: Node, new_parent: Node):
	do_change_parent.call_deferred(child, new_parent)


func do_change_parent(child, new_parent):
	# TODO need to set owner as well to support creating PackedScenes
	var old_parent = child.get_parent()
	old_parent.remove_child(child)
	new_parent.add_child(child)

func get_children_by_name(node: Node):
	var by_name = {}
	for ch in node.get_children():
		by_name[ch.name] = ch
	return by_name

## Returns all of a node's parents EXCEPT the root.
func get_all_parents(node: Node, parents=[]):
	var p = node.get_parent()
	if p == node.get_tree().get_root():
		return parents
	if p:
		parents.append(p)
		return get_all_parents(p, parents)
	else:
		return parents

func each_sibling(node: Node):
	var p = node.get_parent()
	return p.get_children().filter(func(ch): return ch != node)

############################################################
# packed_scene reading

# Returns a dict full of data for the passed packed_scene or path to one.
# If a path is passed, the scene_file_path will be included as a property
# on the first dictionary (the root of the packed scene).
func packed_scene_data(packed_scene_or_path, include_properties=false):
	var scene
	var sfp
	if packed_scene_or_path is String:
		scene = load(packed_scene_or_path)
		sfp = packed_scene_or_path
	elif packed_scene_or_path is PackedScene:
		scene = packed_scene_or_path
		sfp = packed_scene_or_path.resource_path
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

############################################################
# collisions

# https://github.com/godotengine/godot-proposals/issues/3424#issuecomment-943703969
# unconfirmed
func set_collisions_enabled(node, enabled):
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
func _connect(sig, callable, flags=null):
	if sig.is_connected(callable):
		return
	var err
	if flags:
		err = sig.connect(callable, flags)
	else:
		err = sig.connect(callable)
	if err:
		Debug.pr("[Error]: ", err, sig, callable)  # useless enum digit


############################################################
# random

func rand_of(arr, n=1):
	if len(arr) == 0:
		push_warning("Util.rand_of passed empty array")
		return
	arr.shuffle()
	if n == 1:
		return arr[0]
	else:
		return arr.slice(0, n)


func set_random_frame(anim):
	anim.frame = randi() % anim.sprite_frames.get_frame_count(anim.animation)


############################################################
# misc functional

func _or(a, b = null, c = null, d = null, e = null):
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

func _and(a, b = null, c = null, d = null, e = null):
	# TODO expand impl to support 5 inputs
	# TODO support vars as callables, call if previous were non-nil
	if a and b:
		return b

# TODO write Util._not() to replace (restore) gdscript `not`

# could be more efficient
# https://github.com/godotengine/godot-proposals/issues/3116#issuecomment-1363222780
func remove_matching(arr, to_remove):
	return arr.filter(func(a): return a in to_remove)


############################################################
# Facing

# TODO dry these up into one helper
# check node type and rotation

func update_h_flip(facing, node):
	if node:
		if facing.x > 0 and node.position.x < 0:
			node.position.x = -node.position.x
			node.scale.x = -node.scale.x
		elif facing.x < 0 and node.position.x > 0:
			node.position.x = -node.position.x
			node.scale.x = -node.scale.x

func update_los_facing(facing, node):
	if node:
		if facing.x > 0 and node.target_position.y > 0:
			node.target_position.y = -node.target_position.y
		elif facing.x < 0 and node.target_position.y < 0:
			node.target_position.y = -node.target_position.y


#################################################################
## Animations

func animate_rotate(node):
	var tween = node.create_tween()
	tween.set_loops(0)
	tween.tween_property(node.anim, "rotation", node.rotation + PI / 8, 0.3).set_ease(Tween.EASE_IN_OUT).set_trans(
		Tween.TRANS_CUBIC
	)
	tween.tween_property(node.anim, "rotation", node.rotation - PI / 8, 0.3).set_ease(Tween.EASE_IN_OUT).set_trans(
		Tween.TRANS_CUBIC
	)
	tween.tween_interval(randf_range(0.1, 0.4))


func animate(node):
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
func play_then_return(anim, animation):
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
func get_(d: Dictionary, k: String, default: Variant=null):
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

#################################################################
## Configuration warnings

func _config_warning(node, opts={}):
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
