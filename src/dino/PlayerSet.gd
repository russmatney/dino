extends Object
class_name PlayerSet

# enum State { TEMPLATE, SPAWNING, ALIVE, DEAD }

## PData #################################################

# PData bundles enough data to spawn a DinoPlayer
# (player entity + game/player type)
class PData:
	extends Object

	var node: Node2D
	var scene: PackedScene
	var entity_id
	var entity: DinoPlayerEntity
	var room_type: DinoData.RoomType
	# var state: State

	func _init(opts):
		if opts.get("entity"):
			entity = opts.get("entity")
			entity_id = entity.get_entity_id()
		elif opts.get("entity_id"):
			entity_id = opts.get("entity_id")
			entity = Pandora.get_entity(entity_id)
		if entity == null:
			Log.err("PData created without player entity info", opts)

		room_type = opts.get("room_type")
		scene = entity.get_player_scene(room_type)

## vars #################################################

var stack = []

signal new_player_ready(player)

## crud #################################################

func create_new(opts):
	var pdata = PData.new(opts)
	# TODO ensure vs always append? should be unique? could be instances, not ents coming in
	stack.push_front(pdata)

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
	p.node = p.scene.instantiate()

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
		if deferred:
			level_node.add_child.call_deferred(p.node)
		else:
			level_node.add_child(p.node)
	elif spawn_point:
		if deferred:
			U.add_child_to_level(spawn_point, p.node)
		else:
			U.add_child_to_level(spawn_point, p.node, false)
	else:
		Log.warn("No spawn_point found, adding player to current_scene")
		if deferred:
			Navi.get_tree().current_scene.add_child.call_deferred(p.node)
		else:
			Navi.get_tree().current_scene.add_child(p.node)

## respawn #################################################

func respawn_active_player(opts):
	Log.pr("respawning active player node", opts)

	var p = active_player()
	if p:
		_remove_player(p, opts)

	spawn_new.call_deferred(opts)

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

	return [spawn_point, spawn_coords]

func get_spawn_point(opts={}):
	var level_node = opts.get("level_node", Navi)
	var psp = U.first_node_in_group(level_node, "player_spawn_points")
	if psp:
		return psp
	var elevator = U.first_node_in_group(level_node, "elevator")
	if elevator:
		return elevator
