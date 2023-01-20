tool
extends ReptileRoom
class_name TowerRoom

var dark_tile_scene = preload("res://addons/reptile/tilemaps/coldfire/ColdFireDark.tscn")
var blue_tile_scene = preload("res://addons/reptile/tilemaps/coldfire/ColdFireBlue.tscn")
var red_tile_scene = preload("res://addons/reptile/tilemaps/coldfire/ColdFireRed.tscn")
var yellow_tile_scene = preload("res://addons/reptile/tilemaps/coldfire/ColdFireYellow.tscn")

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
		"period": rand_range(5, 30),
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

	# var dark_tilemaps = tilemaps({"group": "coldfire_darktile"})
	# var red_tilemaps = tilemaps({"group": "coldfire_redtile"})
	# var blue_tilemaps = tilemaps({"group": "coldfire_bluetile"})

	for t_cell in tilemap_cells({"group": "coldfire_yellowtile"}):
		var t = t_cell[0]
		var cell = t_cell[1]
		var valid_nbrs = Reptile.valid_neighbors(t, cell)
		prn("found ", valid_nbrs.size(), " valid_nbrs for cell ", cell)

		if valid_nbrs.size() == 9:
			var pos = t.map_to_world(cell) * t.scale.x
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
		print(loc["position"])
		print(loc["cell"])
		var target = target_scene.instance()
		# set relative to parent position
		target.position = loc["position"]
		add_child(target)
		target.set_owner(get_tree().edited_scene_root)
