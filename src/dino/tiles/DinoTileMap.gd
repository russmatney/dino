@tool
extends TileMap
class_name DinoTileMap

@export var chunks_path: String = "res://src/dino/tiles/tile_chunks.txt"

var chunk_defs: GridDefs

func _init():
	chunk_defs = GridParser.parse({defs_path=chunks_path})

func fill_coords(coords: Array[Vector2i]):
	set_cells_terrain_connect(0, coords, 0, 0)

func mix_terrains():
	pass
	# overwrite tiles with chunks of other terrains
