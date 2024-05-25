@tool
extends TileMap
class_name DinoTileMap

# NOTE this impl assumes one "layer" and one "terrain_set"

## vars ########################################################

@export var chunks_path: String = "res://src/dino/tiles/tile_chunks.txt"

var chunk_defs: GridDefs

## init ########################################################

func _init():
	if not chunk_defs:
		chunk_defs = GridParser.parse({defs_path=chunks_path})

## fill ########################################################

func fill_coords(coords: Array[Vector2i]):
	set_cells_terrain_connect(0, coords, 0, 0)

## mix ########################################################

# overwrite filled tiles with chunks of other terrains
func mix_terrains(opts={}):
	var cell_count = opts.get("cell_count", 3)
	var max_t = tile_set.get_terrains_count(0)

	if max_t == 1:
		return

	var chunk_count = U.rand_of([5,6,7,8]) * cell_count
	var tile_coords = get_used_cells(0)
	if tile_coords.is_empty():
		return

	var grids = chunk_defs.grids_with_flag("tile_chunk")

	for i in chunk_count:
		var grid = U.rand_of(grids)
		var terrain = U.rand_of(range(1, max_t))

		# pick random tile_coord
		var start = U.rand_of(tile_coords)
		var to_update = []

		# find overlapping coords w/ grid
		for g_coord in grid.coords():
			var coord = start + Vector2i(g_coord.coord)
			if coord in tile_coords:
				to_update.append(coord)

		set_cells_terrain_connect(0, to_update, 0, terrain)
