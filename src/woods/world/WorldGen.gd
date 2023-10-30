@tool
extends Node2D

## vars/triggers ######################################################################

@export var run_gen: bool:
	set(v):
		if v and Engine.is_editor_hint():
			generate()

@export var tile_size = 32
@export var room_count = 5
@export_file var room_defs_path = "res://src/woods/world/rooms.txt"
var parsed_room_defs

@export var tilemap_scene: PackedScene = preload("res://addons/reptile/tilemaps/CaveTiles16.tscn")

@onready var rooms_node = $%Rooms

var room_idx = 0

## ready ######################################################################

func _ready():
	if Engine.is_editor_hint():
		Debug.pr("World Gen ready")
	else:
		Debug.pr("World Gen test ready")

	Game.maybe_spawn_player()

func _unhandled_input(event):
	if Engine.is_editor_hint():
		return

	if Trolley.is_restart(event):
		Debug.pr("Regen + restart")
		generate()
		Game.respawn_player()

## generate ######################################################################

func generate():
	# clear
	rooms_node.get_children().map(func(c): c.queue_free())

	# reset
	room_idx = 0
	parsed_room_defs = RoomParser.parse({room_defs_path=room_defs_path})
	var rooms = []

	# generate
	Debug.pr("Generating world")

	# first room
	var last_room = create_room({type=WoodsData.t.START})
	rooms.append(last_room)

	# most rooms
	for _i in range(room_count - 2):
		last_room = create_room({last_room=last_room,
			type=Util.rand_of([
				WoodsData.t.SQUARE,
				WoodsData.t.LONG,
				WoodsData.t.CLIMB,
				WoodsData.t.FALL]),
			})
		rooms.append(last_room)

	# last room
	var room = create_room({type=WoodsData.t.END, last_room=last_room})
	rooms.append(room)

	promote_tilemaps(rooms)


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

## create_room ######################################################################

func create_room(opts=null):
	if opts == null:
		opts = {}
	opts.merge({
		tile_size=tile_size,
		parsed_room_defs=parsed_room_defs,
		tilemap_scene=tilemap_scene})

	opts["tilemap_scene"] = load("res://addons/reptile/tilemaps/CaveTiles16.tscn")

	opts["label_to_entity"] = {
		"Player": {scene=load("res://addons/core/PlayerSpawnPoint.tscn")},
		"Leaf": {scene=load("res://src/woods/entities/Leaf.tscn")},

		# not used (at the time of writing), but maybe a quick win idea
		"Spawn": {scene=load("res://src/dino/SpawnPoint.tscn")},
# 		var spawn_point = spawn_point_scene.instantiate()
# 		spawn_point.position = l * coord_factor
# 		spawn_point.spawn_scene = leaf_scene
# 		spawn_point.name = "LeafSpawnPoint_%s_%s" % [l.x, l.y]
		"Light": {scene=load("res://src/pluggs/entities/Light.tscn")},
		}

	var typ = Util.get_(opts, "type", WoodsData.t.SQUARE)
	opts["filter_rooms"] = func(r):
		var type_s
		match typ:
			WoodsData.t.START: type_s = "START"
			WoodsData.t.END: type_s = "END"
			WoodsData.t.SQUARE: type_s = "SQUARE"
			WoodsData.t.CLIMB: type_s = "CLIMB"
			WoodsData.t.FALL: type_s = "FALL"
			WoodsData.t.LONG: type_s = "LONG"

		if type_s != null:
			return type_s == r.meta.get("room_type")

	var room = BrickRoom.create_room(opts)

	# add detection for end-reached
	if typ == WoodsData.t.END:
		var shape = RectangleShape2D.new()
		shape.size = room.rect.size
		var coll = CollisionShape2D.new()
		coll.name = "CollisionShape2D"
		coll.set_shape(shape)
		coll.position = room.rect.position + (room.rect.size / 2.0)

		var box = Area2D.new()
		box.add_child(coll)
		coll.set_owner(box)
		box.name = "EndBox"
		box.set_collision_layer_value(1, false)
		box.set_collision_mask_value(1, false)
		box.set_collision_mask_value(2, true) # 2 for player

		room.add_child(box)

	room_idx += 1
	room.ready.connect(func():
		room.set_owner(self)
		room.get_children().map(func(ch):
			ch.set_owner(self)
			if ch.name == "EndBox":
				ch.get_children().map(func(c): c.set_owner(self))))
	room.name = "Room_%s" % room_idx

	rooms_node.add_child(room)

	return room
