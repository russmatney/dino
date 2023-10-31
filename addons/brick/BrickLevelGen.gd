@tool
extends Node2D
class_name BrickLevelGen

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

func generate():
	pass
