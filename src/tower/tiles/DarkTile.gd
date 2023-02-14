extends TileMap


func hit(pos):
	var cell = local_to_map(to_local(pos))
	var nbrs = Reptile.valid_neighbors(self, cell)
	for c in nbrs:
		set_cell(0, c, -1)

func _use_tile_data_runtime_update(_layer, _coords):
	return true
