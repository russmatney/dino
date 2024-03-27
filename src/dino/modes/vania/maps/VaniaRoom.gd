@tool
extends Node2D

@onready var room_instance = $RoomInstance

@export var tilemap_scenes: Array[PackedScene] = []
var tile_border_width = 4

var tilemap: TileMap

## init ###############################################################

func _enter_tree():
	ensure_tilemap()

func ensure_tilemap():
	if tilemap == null:
		tilemap = get_node_or_null("TileMap")
		Log.pr("ch", get_children())
	if tilemap == null and not tilemap_scenes.is_empty():
		tilemap = tilemap_scenes[0].instantiate()
		add_child(tilemap)
		tilemap.set_owner(self)
	Log.pr("tilemap ensured", tilemap)

## ready ##############################################################

func _ready():
	if Engine.is_editor_hint():
		request_ready()

	Log.pr("vania room ready", room_instance)
	Log.pr("room size", room_instance.get_size())
	Log.pr("room cells", room_instance.get_local_cells())
	Log.pr("room neighbors", room_instance.get_neighbor_rooms())

	fill_tilemap_borders()

func is_border_coord(rect, coord):
	return (abs(rect.position.x - coord.x) < tile_border_width) \
		or (abs(rect.end.x - coord.x) <= tile_border_width) \
		or (abs(rect.position.y - coord.y) < tile_border_width) \
		or (abs(rect.end.y - coord.y) <= tile_border_width)

func fill_tilemap_borders():
	var rect = Reptile.rect_to_local_rect(tilemap, Rect2(Vector2(), room_instance.get_size()))
	var t_cells = Reptile.cells_in_rect(rect).filter(func(coord):
		return is_border_coord(rect, coord))

	tilemap.set_cells_terrain_connect(0, t_cells, 0, 0)
	tilemap.force_update()
