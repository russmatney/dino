@tool
extends Node2D

## vars/triggers ######################################################################

@export var run_gen: bool:
	set(v):
		if v and Engine.is_editor_hint():
			generate()

@export var room_base_dim = 512
@export var room_count = 5
@export_file var room_defs_path = "res://src/woods/world/rooms.txt"
var parsed_room_defs

@export var tilemap_scene: PackedScene = preload("res://addons/reptile/tilemaps/CaveTiles16.tscn")

@onready var rooms_node = $%Rooms
@onready var player = $%Player
var player_pos

var room_idx = 0

## ready ######################################################################

func _ready():
	if Engine.is_editor_hint():
		Debug.pr("World Gen ready")
	else:
		Debug.pr("World Gen test ready")

		player_pos = player.position

func _unhandled_input(event):
	if Engine.is_editor_hint():
		return

	if Trolley.is_restart(event):
		Debug.pr("Regen + restart")
		generate()
		player.position = player_pos

## generate ######################################################################

func generate():
	# clear
	rooms_node.get_children().map(func(c): c.free())

	# reset
	room_idx = 0
	parsed_room_defs = WoodsRoom.parse_room_defs({room_defs_path=room_defs_path})
	var rooms = []

	# generate
	Debug.pr("Generating world")

	# first room
	var last_room = create_room({type=WoodsRoom.t.START})
	rooms.append(last_room)

	# most rooms
	for _i in range(room_count - 2):
		last_room = create_room({}, last_room)
		rooms.append(last_room)

	# last room
	var room = create_room({type=WoodsRoom.t.END}, last_room)
	rooms.append(room)

	promote_tilemaps(rooms)

func promote_tilemaps(rooms):
	var tile_coords = []
	var addl_idx = 0
	for r in rooms:
		var used_cells = r.tilemap.get_used_cells(0)

		# TODO need same logic as used for positioning rooms in WoodsRoom
		var y_offset = 0
		if r.position.y != 0:
			y_offset = int(room_base_dim / r.position.y) * len(r.room_def.shape)
		Debug.pr("r.position", r.position.y, room_base_dim)
		Debug.pr("r.room_def.shape len", len(r.room_def.shape))
		Debug.pr("y_offset", y_offset)

		# adjust used_cells based on room width
		used_cells = used_cells.map(func(coord):
			coord.x += addl_idx
			coord.y += y_offset
			return coord)
		addl_idx += len(r.room_def.shape[0])
		Debug.pr("addl_idx", addl_idx)

		tile_coords.append_array(used_cells)
		r.remove_child(r.tilemap)

	var tilemap = tilemap_scene.instantiate()
	tilemap.scale = rooms[0].tilemap.scale
	tilemap.set_cells_terrain_connect(0, tile_coords, 0, 0)
	tilemap.force_update()

	tilemap.ready.connect(func(): tilemap.set_owner(self))
	rooms_node.add_child(tilemap)

## create_room ######################################################################

func create_room(opts=null, last_room=null):
	if opts == null:
		opts = {}
	opts.merge({
		room_base_dim=room_base_dim,
		parsed_room_defs=parsed_room_defs,
		tilemap_scene=tilemap_scene})
	var room = WoodsRoom.create_room(opts, last_room)

	room_idx += 1
	room.ready.connect(func():
		room.set_owner(self)
		room.get_children().map(func(ch): ch.set_owner(self)))
	room.name = "Room_%s" % room_idx
	rooms_node.add_child(room)

	return room
