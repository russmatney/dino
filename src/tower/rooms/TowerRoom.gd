tool
extends ReptileRoom
class_name TowerRoom

var dark_tile_scene = preload("res://src/tower/tiles/DarkTile.tscn")
var blue_tile_scene = preload("res://src/tower/tiles/BlueTile.tscn")
var red_tile_scene = preload("res://src/tower/tiles/RedTile.tscn")
var yellow_tile_scene = preload("res://src/tower/tiles/YellowTile.tscn")

var coldfire_dark = Color8(91, 118, 141)
var coldfire_blue = Color8(70, 66, 94)
var coldfire_red = Color8(209, 124, 124)
var coldfire_yellow = Color8(246, 198, 168)

func get_group_def():
	var options = [
		[
			[coldfire_blue, blue_tile_scene, 0.0, 0.4],
			[coldfire_yellow, yellow_tile_scene, 0.4, 0.7],
			[coldfire_dark, dark_tile_scene, 0.7, 1.0],
			],
		[
			[coldfire_red, red_tile_scene, 0.0, 0.4],
			[coldfire_yellow, yellow_tile_scene, 0.4, 0.7],
			[coldfire_dark, dark_tile_scene, 0.7, 1.0],
			],
		]

	var opts = []
	for group_opt in options:
		var grp_opt = []
		for data in group_opt:
			var grp = ReptileGroup.new()
			grp.setup(data[0], data[1], data[2], data[3])
			grp_opt.append(grp)
		opts.append(grp_opt)
	opts.shuffle()
	return opts[0]

func get_noise_input():
	var options = [{
		"seed": rand_range(0, 100000),
		"octaves": Util.rand_of([2, 3, 4]),
		"period": rand_range(15, 30),
		"persistence": rand_range(0.3, 0.5),
		"lacunarity": rand_range(2.5, 4.0),
	}]
	options.shuffle()
	return options[0]

########################################################################
# spawn targets

var target_scene = preload("res://src/gunner/targets/Target.tscn")

func spawn_targets():
	for c in get_children():
		if c.is_in_group("target"):
			c.free()

	var locs = []

	# var dark_tilemaps = tilemaps({"group": "darktile"})
	# var red_tilemaps = tilemaps({"group": "redtile"})
	# var blue_tilemaps = tilemaps({"group": "bluetile"})

	for t_cell in tilemap_cells({"group": "yellowtile"}):
		var t = t_cell[0]
		var cell = t_cell[1]
		var valid_nbrs = Reptile.valid_neighbors(t, cell)

		if valid_nbrs.size() == 9:
			var pos = cell_to_local_pos(t, cell)
			# center on tile (rn it's top-left)
			locs.append({
				"position": pos,
				"cell": cell,
				})

	var target_locs = []
	if locs:
		locs.shuffle()
		for loc in locs:
			target_locs.append(loc)
			if target_locs.size() == 3:
				break

	for loc in target_locs:
		var target = target_scene.instance()
		# set relative to parent position
		target.position = loc["position"]
		add_child(target)
		target.set_owner(get_tree().edited_scene_root)
