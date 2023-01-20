tool
extends TowerRoom

func _ready():
	print("tower end room ready")

func _on_regen():

	var locs = []
	for t in tilemaps():
		if t.is_in_group("coldfire_yellowtile"):
			var used_cells = t.get_used_cells()

			# seek out acceptable start locations for the player
			for cell in used_cells:
				var valid_nbrs = Reptile.valid_neighbors(t, cell)

				if valid_nbrs.size() == 9:
					var pos = t.to_global(t.map_to_world(cell))
					locs.append(pos)

	if locs:
		locs.shuffle()
		print("loc sample: ", locs[0])
	else:
		print("no viable player positions")
