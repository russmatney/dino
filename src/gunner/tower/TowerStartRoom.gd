tool
extends TowerRoom

func _ready():
	print("tower start room ready")

func _on_regen():
	var start_locs = []
	for t in tilemaps():
		if t.is_in_group("coldfire_yellowtile"):
			var used_cells = t.get_used_cells()

			# seek out acceptable start locations for the player
			for cell in used_cells:
				var valid_nbrs = Reptile.valid_neighbors(t, cell)

				if valid_nbrs.size() == 9:
					var pos = t.to_global(t.map_to_world(cell))
					start_locs.append(pos)

	if start_locs:
		start_locs.shuffle()
		# player_start.global_position = start_locs[0]
	else:
		print("no viable player positions")
