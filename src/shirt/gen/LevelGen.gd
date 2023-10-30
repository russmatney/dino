@tool
extends Node2D

## vars/triggers ######################################################################

@export var run_gen: bool:
	set(v):
		if v and Engine.is_editor_hint():
			generate()

@export var _seed: int
@export var gen_with_random_seed: bool:
	set(v):
		if v and Engine.is_editor_hint():
			_seed = randi()
			generate()

@export var room_tile_size = 16
@export var room_count = 5
@export_file var room_defs_path = "res://src/shirt/gen/room_defs.txt"
var parsed_room_defs

@export var tilemap_scene: PackedScene = preload("res://addons/reptile/tilemaps/CaveTiles16.tscn")

@onready var rooms_node = $%Rooms
@onready var entities_node = $%Entities

var room_idx = 0

## ready ######################################################################

func _ready():
	Debug.pr("LevelGen ready")
	Game.maybe_spawn_player()
	connect_to_rooms()

func _unhandled_input(event):
	if Engine.is_editor_hint():
		return

	if Trolley.is_restart(event):
		reboot_world()

# Needs to be called on _ready (for static rooms) and after regenerating new rooms
func connect_to_rooms():
	if Engine.is_editor_hint():
		return
	# TODO any shirt setup
	pass

## generate ######################################################################

func reset():
	# clear
	rooms_node.get_children().map(func(c): c.queue_free())
	entities_node.get_children().map(func(c): c.queue_free())

	# reset
	room_idx = 0
	parsed_room_defs = RoomParser.parse({room_defs_path=room_defs_path})

func generate():
	reset()

	seed(_seed)
	Debug.pr("Generating level with seed:", _seed)

	var rooms = []

	var room_opts = [
		{flags=["first"]},
		{skip_flags=["first"], side=Vector2.RIGHT},
		{skip_flags=["first"], side=Util.rand_of([Vector2.UP, Vector2.DOWN])},
		{skip_flags=["first"], side=Util.rand_of([Vector2.RIGHT, Vector2.LEFT])},
		]

	for opt in room_opts:
		opt.merge({
			tile_size=room_tile_size,
			parsed_room_defs=parsed_room_defs,
			tilemap_scene=tilemap_scene,
			label_to_entity={
				"Player": {scene=load("res://addons/core/PlayerSpawnPoint.tscn")},
				"Chaser": {scene=load("res://src/shirt/enemies/BlobChaser.tscn")},
				"Walker": {scene=load("res://src/shirt/enemies/BlobWalker.tscn")},
				}})

	rooms = BrickRoom.create_rooms(room_opts)
	for r in rooms:
		setup_room(r)

	var tmap = promote_tilemaps(rooms)
	wrap_tilemap(tmap)
	promote_entities(rooms)


# TODO DRY up on BrickRoom / some other gen helper
func promote_tilemaps(rooms):
	var cell_positions = []
	for r in rooms:
		var used_cells = r.tilemap.get_used_cells(0)
		var poses = used_cells.map(func(coord):
			return r.tilemap.map_to_local(coord) + (r.position / r.tilemap.scale) + r.tilemap.position)
		cell_positions.append_array(poses)
		r.remove_child(r.tilemap)
		r.tilemap.queue_free()

	var tilemap = tilemap_scene.instantiate()
	# NOTE assumes rooms all have the same scale
	tilemap.scale = rooms[0].tilemap.scale
	var tile_coords = cell_positions.map(func(pos):
		return tilemap.local_to_map(pos))
	tilemap.set_cells_terrain_connect(0, tile_coords, 0, 0)
	tilemap.force_update()

	tilemap.ready.connect(func(): tilemap.set_owner(self))
	rooms_node.add_child(tilemap)

	return tilemap

func tilemap_border_coords(tilemap):
	var rect = tilemap.get_used_rect()
	rect = rect.grow_individual(1, 1, 0, 0)
	var border_coords = [ # corners
		Vector2i(rect.position.x, rect.position.y),
		Vector2i(rect.position.x + rect.size.x, rect.position.y),
		Vector2i(rect.position.x, rect.position.y + rect.size.y),
		Vector2i(rect.position.x + rect.size.x, rect.position.y + rect.size.y),
		]
	for x in range(rect.position.x, rect.position.x + rect.size.x):
		border_coords.append(Vector2i(x, rect.position.y))
		border_coords.append(Vector2i(x, rect.position.y + rect.size.y))
	for y in range(rect.position.y, rect.position.y + rect.size.y):
		border_coords.append(Vector2i(rect.position.x, y))
		border_coords.append(Vector2i(rect.position.x + rect.size.x, y))
	return border_coords

func wrap_tilemap(tilemap):
	var coords = tilemap.get_used_cells(0)

	var border_coords = tilemap_border_coords(tilemap)

	coords.append_array(border_coords)
	tilemap.set_cells_terrain_connect(0, coords, 0, 0)
	tilemap.force_update()

func promote_entities(rooms):
	for room in rooms:
		for ent in room.entities:
			ent.reparent(entities_node, true)
			ent.set_owner(self)

## create_room ######################################################################

func reboot_world():
	Hood.notif("Rebooting world....")
	_seed = randi() # may want this to happen at a global level at some point
	await get_tree().create_timer(3.0).timeout
	generate()
	Game.respawn_player()
	connect_to_rooms()

func setup_room(room):
	room_idx += 1
	room.ready.connect(func():
		room.set_owner(self)
		room.get_children().map(func(ch): ch.set_owner(self)))
	room.name = "Room_%s" % room_idx

	rooms_node.add_child(room)

	return room
