tool
extends Node


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

func reparent(child: Node, new_parent: Node):
	call_deferred("do_reparent", child, new_parent)

func do_reparent(child, new_parent):
	# TODO need to set owner as well to support creating PackedScenes
	var old_parent = child.get_parent()
	old_parent.remove_child(child)
	new_parent.add_child(child)

# https://godotengine.org/qa/27869/how-to-get-the-nearest-object-in-a-group
func nearest_node(source: Node, targets) -> Node:
	if not targets:
		return null

	# assume the first is closest
	var nearest_target = targets[0]

	# look through spawn nodes to see if any are closer
	for target in targets:
		 if target.global_position.distance_to(source.global_position) < nearest_target.global_position.distance_to(source.global_position):
			 nearest_target = target

	return nearest_target

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

func get_children_in_group(node: Node, group_name: String) -> Array:
	# only checks first children
	var in_group = []
	for c in node.get_children():
		if c.is_in_group(group_name):
			in_group.append(c)
	return in_group

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

func ensure_connection(obj, sig, target, method, args=[]):
	var err
	if not obj.is_connected(sig, target, method):
		err = obj.connect(sig, target, method, args)
	if err: print("[Error]: ", err) # useless enum digit

func node_name_from_path(path):
	var parts = path.split("/")
	return parts[-1]

func p_script_vars(node):
	for prop in node.get_property_list():
		if "usage" in prop and prop["usage"] & PROPERTY_USAGE_SCRIPT_VARIABLE != 0:
			print("\t", prop["name"], ": ", self.get(prop["name"]))

func rand_of(arr):
	arr.shuffle()
	return arr[0]

############################################################
# Functional

static func map(function: FuncRef, i_array: Array)->Array:
	var o_array := []
	for value in i_array:
		o_array.append(function.call_func(value))
	return o_array

static func filter(function: FuncRef, i_array: Array):
	pass

# could be more efficient
# https://github.com/godotengine/godot-proposals/issues/3116#issuecomment-1363222780
func remove_matching(arr, to_remove):
	for rem in to_remove:
		arr.erase(rem)
	return arr
