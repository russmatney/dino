extends TileMap


func hit(position):
	var cell = world_to_map(to_local(position))
	var nbrs = Reptile.valid_neighbors(self, cell)
	for c in nbrs:
		set_cellv(c, -1)
