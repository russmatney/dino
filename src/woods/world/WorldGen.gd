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
	var last_room = create_room({type=WoodsRoom.t.START})
	rooms.append(last_room)

	# most rooms
	for _i in range(room_count - 2):
		last_room = create_room({last_room=last_room,
			type=Util.rand_of([
				WoodsRoom.t.SQUARE,
				WoodsRoom.t.LONG,
				WoodsRoom.t.CLIMB,
				WoodsRoom.t.FALL]),
			})
		rooms.append(last_room)

	# last room
	var room = create_room({type=WoodsRoom.t.END, last_room=last_room})
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
	var room = WoodsRoom.create_room(opts)

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
