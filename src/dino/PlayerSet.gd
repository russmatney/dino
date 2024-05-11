extends Object
class_name PlayerSet
# a set of players - could support toggling between players in a party

# enum State { TEMPLATE, SPAWNING, ALIVE, DEAD }

## PData #################################################

# PData bundles the player entity and current node, if there is one
class PData:
	extends Object

	var node: Node2D
	var entity_id
	var entity: DinoPlayerEntity
	# instance, not just entity (template)
	# var state: State

	func to_pretty():
		return {node=node, entity=entity}

	func _init(opts):
		if opts.get("entity"):
			entity = opts.get("entity")
			entity_id = entity.get_entity_id()
		elif opts.get("entity_id"):
			entity_id = opts.get("entity_id")
			entity = Pandora.get_entity(entity_id)
		if entity == null:
			Log.err("PData created without player entity info", opts)

## vars #################################################

var stack = []

signal new_player_ready(player)

## crud #################################################

func create_new(opts):
	var pdata = PData.new(opts)
	# TODO ensure vs always append? should be unique? could be instances, not ents coming in
	stack.push_front(pdata)
	Log.pr("created new player!", stack)

func _remove_player(p: PData, _opts={}):
	if p.node and is_instance_valid(p.node):
		p.node.get_parent().remove_child(p.node)
	if p.node and is_instance_valid(p.node):
		p.node.name = "RemovedPlayer"
		p.node.queue_free()

## spawn new #################################################

func spawn_new(opts={}):
	var p = active_player()
	if not p:
		Log.err("No active player, cannot spawn", stack)
		return
	var genre = opts.get("genre_type")
	if genre == null:
		Log.warn("genre_type not passed, defaulting", opts)
		genre = DinoData.GenreType.SideScroller
	p.node = p.entity.get_player_scene(genre).instantiate()

	var sp = get_spawn_point_and_coords(opts)
	var spawn_point = sp[0]
	var spawn_coords = sp[1]

	# set position
	if spawn_coords:
		p.node.position = spawn_coords

	# call passed setup fn
	if opts.get("setup"):
		opts.get("setup").call(p.node)

	# connect player_ready signals
	p.node.ready.connect(func(): new_player_ready.emit(p.node))

	# add child
	var level_node = opts.get("level_node")
	var deferred = opts.get("deferred", true)
	if level_node:
		Log.prn("adding player to level node", level_node, p)
		if deferred:
			level_node.add_child.call_deferred(p.node)
		else:
			level_node.add_child(p.node)
	elif spawn_point:
		Log.pr("adding player with spawn_point", spawn_point)
		if deferred:
			U.add_child_to_level(spawn_point, p.node)
		else:
			U.add_child_to_level(spawn_point, p.node, false)
	else:
		if deferred:
			Log.warn("No spawn_point found, adding player to current_scene (deferred)")
			Navi.get_tree().current_scene.add_child.call_deferred(p.node)
		else:
			Log.warn("No spawn_point found, adding player to current_scene")
			Navi.get_tree().current_scene.add_child(p.node)

## respawn #################################################

func current_player_genre():
	var p = active_player()
	if not p or not p.node:
		Log.warn("No current player, couldn't pull genre_type")
		return DinoData.GenreType.SideScroller

	if not is_instance_valid(p.node):
		Log.warn("Invalid player, couldn't pull genre_type", p)
		return DinoData.GenreType.SideScroller

	return p.entity.get_genre_type_for_scene(p.node.scene_file_path)

func respawn_active_player(opts):
	Log.info("respawning active player node", opts)
	var genre_type = current_player_genre()

	var p = active_player()
	if p:
		_remove_player(p, opts)

	if opts.get("new_entity") != null:
		create_new({entity=opts.get("new_entity")})

	if opts.get("genre_type") == null:
		opts["genre_type"] = genre_type

	if opts.get("deferred", true):
		spawn_new.call_deferred(opts)
	else:
		spawn_new(opts)

## helpers #################################################

func active_player():
	if not stack.is_empty():
		return stack[0]

func get_spawn_point_and_coords(opts):
	var spawn_coords = opts.get("spawn_coords")
	var spawn_point
	if spawn_coords == null:
		spawn_point = get_spawn_point(opts)
		if spawn_point:
			spawn_coords = spawn_point.global_position
		else:
			Log.warn("spawning player, no spawn point found", opts)

	return [spawn_point, spawn_coords]

func get_spawn_point(opts={}):
	var level_node = opts.get("level_node", Navi)
	var psp = U.first_node_in_group(level_node, "player_spawn_points")
	if psp:
		return psp
	var elevator = U.first_node_in_group(level_node, "elevator")
	if elevator:
		return elevator
