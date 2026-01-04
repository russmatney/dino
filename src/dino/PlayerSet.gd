extends Object
class_name PlayerSet
# a set of players - could support toggling between players in a party

# enum State { TEMPLATE, SPAWNING, ALIVE, DEAD }

static func logger() -> PrettyLogger:
	return LoggerFactory.load_logger("res://src/loggers/PlayerLogger.tres")

## PData #################################################

# PData bundles the player entity and current node, if there is one,
# plus any input data describing the player
# it is a template for serializing or respawning a party member
#
# idea: it could support quick-swapping between same-genre party members
class PData:
	extends Object

	var node: Node2D
	var entity_id
	var entity: DinoPlayerEntity
	# instance, not just entity (template)
	# var state: State
	var genre: DinoData.Genre
	var input_opts: Dictionary

	func to_pretty():
		return {node=node, input_opts=input_opts}

	func _init(opts):
		if opts.get("entity"):
			entity = opts.get("entity")
			entity_id = entity.get_entity_id()
		elif opts.get("entity_id"):
			entity_id = opts.get("entity_id")
			entity = Pandora.get_entity(entity_id)
		if opts.get("genre"):
			genre = opts.genre
		input_opts = opts
		if entity == null:
			PlayerSet.logger().err("PData created without player entity info", opts)

## vars #################################################

var stack = []

signal new_player_ready(player)

## crud #################################################

func create_new(opts):
	var pdata = PData.new(opts)
	# TODO ensure vs always append? should be unique? could be instances, not ents coming in
	stack.push_front(pdata)
	logger().info("created new player!", pdata.entity.get_display_name())

# reset data. supports starting a new game mode
func reset_player_data():
	# drop everything? should we manually free anything?
	stack = []

func _remove_player_node(p: PData, _opts={}):
	if p.node and is_instance_valid(p.node):
		p.node.get_parent().remove_child(p.node)
	if p.node and is_instance_valid(p.node):
		p.node.name = "RemovedPlayer"
		p.node.queue_free()

## spawn new #################################################

func spawn_new(opts={}):
	var p = active_player()
	if not p:
		logger().err("No active player, cannot spawn", stack)
		return
	var genre = opts.get("genre")
	if genre == null:
		genre = p.genre

	if genre == null:
		logger().warn("genre not passed, defaulting", opts)
		genre = DinoData.Genre.SideScroller

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
	p.node.ready.connect(func():
		new_player_ready.emit(p.node))

	# add child
	# adds to a passed level_node, using a spawn_point, or to the current_scene
	var level_node = opts.get("level_node")
	var deferred = opts.get("deferred", true)
	if level_node:
		logger().info("adding player to level node", p.entity.get_display_name(), level_node, sp)
		if deferred:
			level_node.add_child.call_deferred(p.node)
		else:
			level_node.add_child(p.node)
	elif spawn_point:
		logger().info("adding player at spawn_point", spawn_point)
		if deferred:
			U.add_child_to_level(spawn_point, p.node)
		else:
			U.add_child_to_level(spawn_point, p.node, false)
	else:
		if deferred:
			logger().warn("No spawn_point found, adding player to current_scene (deferred)")
			Navi.get_tree().current_scene.add_child.call_deferred(p.node)
		else:
			logger().warn("No spawn_point found, adding player to current_scene")
			Navi.get_tree().current_scene.add_child(p.node)

## respawn #################################################

func current_player_genre():
	var p = active_player()
	if not p or not p.node:
		logger().warn("No current player, couldn't pull genre")
		return DinoData.Genre.SideScroller

	if not is_instance_valid(p.node):
		logger().warn("Invalid player, couldn't pull genre", p)
		return DinoData.Genre.SideScroller

	return p.entity.get_genre_for_scene(p.node.scene_file_path)

func respawn_active_player(opts):
	var genre = current_player_genre()

	var active_player_parent
	var p = active_player()
	if p:
		if p.node and is_instance_valid(p.node):
			active_player_parent = p.node.get_parent()
		_remove_player_node(p, opts)

	if opts.get("new_entity") != null:
		# TODO remove existing entity from stack?
		create_new({entity=opts.get("new_entity")})

	if opts.get("genre") == null:
		opts["genre"] = genre

	if active_player_parent and not opts.get("level_node"):
		opts["level_node"] = active_player_parent

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
			logger().warn("spawning player, no spawn point found", opts)

	return [spawn_point, spawn_coords]

func get_spawn_point(opts={}):
	var level_node = opts.get("level_node", Navi)
	# TODO dry this up (look in level_node, fallback to global group search)

	var psp = U.get_first_child_in_group(level_node, "player_spawn_points", true)
	if psp:
		return psp
	var elevator = U.get_first_child_in_group(level_node, "elevator", true)
	if elevator:
		return elevator

	psp = U.first_node_in_group(level_node, "player_spawn_points")
	if psp:
		return psp
	elevator = U.first_node_in_group(level_node, "elevator")
	if elevator:
		return elevator
