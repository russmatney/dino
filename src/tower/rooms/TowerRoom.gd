@tool
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
	var options = [
		{
			"seed": randf_range(0, 100000),
			"octaves": U.rand_of([2, 3, 4]),
			"frequency": 1/randf_range(15, 40),
			"persistence": randf_range(0.3, 0.5),
			"lacunarity": randf_range(2.5, 4.0),
		}
	]
	options.shuffle()
	return options[0]


########################################################################
# helpers


func free_children_in_group(group_name):
	for c in get_children():
		if c.is_in_group(group_name):
			c.free()


func n_random(locs, n):
	if locs.size() > n:
		locs.shuffle()
		return locs.slice(0, n - 1)
	return locs


var dark_max_y


func dark_tile_max_y():
	if dark_max_y:
		return dark_max_y

	var dark_tile_map = tilemaps({"group": "darktile"})[0]
	dark_max_y = 0
	for c in dark_tile_map.get_used_cells(0):
		if c.y > dark_max_y:
			dark_max_y = c.y
	return dark_max_y


func floor_tile_below(cell):
	var dark_tile_map = tilemaps({"group": "darktile"})[0]
	var max_y = dark_tile_max_y()
	for y in range(cell.y, max_y):
		var c = dark_tile_map.get_cell_tile_data(0, Vector2(cell.x, y))
		if c:
			return true


########################################################################
# spawn targets

var target_scene = preload("res://src/dino/entities/targets/Target.tscn")


func spawn_targets():
	free_children_in_group("targets")

	var locs = []
	for t_cell in tilemap_cells({"group": "yellowtile"}):
		var t = t_cell[0]
		var cell = t_cell[1]
		var valid_nbrs = Reptile.valid_neighbors(t, cell)

		if valid_nbrs.size() == 9:
			locs.append(
				{
					"position": cell_to_local_pos(t, cell),
					"cell": cell,
				}
			)

	var target_locs = n_random(locs, 3)

	for loc in target_locs:
		var target = target_scene.instantiate()
		# set relative to parent position
		target.position = loc["position"]
		add_child(target)
		target.set_owner(get_tree().edited_scene_root)


########################################################################
# player spawn point

var pickup_scene = preload("res://src/gunner/pickups/Pickup.tscn")
var pickup_types = ["hat", "body"]


func add_pickups():
	free_children_in_group("pickup")

	var locs = []
	for t_cell in tilemap_cells({"group": "yellowtile"}):
		var t = t_cell[0]
		var cell = t_cell[1]
		var valid_nbrs = Reptile.valid_neighbors(t, cell)

		if valid_nbrs.size() == 9:
			locs.append(
				{
					"position": cell_to_local_pos(t, cell),
					"cell": cell,
				}
			)

	var p_locs = n_random(locs, 2)
	for i in range(2):
		if p_locs.size() > i:
			var loc = p_locs[i]
			var p = pickup_scene.instantiate()
			p.position = loc["position"]
			p.type = pickup_types[i]
			add_child(p)
			p.set_owner(get_tree().edited_scene_root)


########################################################################
# player spawn point

var player_spawn_point_scene = preload("res://addons/core/PlayerSpawnPoint.tscn")


func add_player_spawner():
	free_children_in_group("player_spawner")

	var locs = []
	for t_cell in tilemap_cells({"group": "yellowtile"}):
		var t = t_cell[0]
		var cell = t_cell[1]
		var valid_nbrs = Reptile.valid_neighbors(t, cell)
		var enough_valid_nbrs = valid_nbrs.size() == 9
		var floor_below = (
			floor_tile_below(cell)
			and floor_tile_below(Vector2(cell.x + 1, cell.y))
			and floor_tile_below(Vector2(cell.x - 1, cell.y))
		)

		if enough_valid_nbrs and floor_below:
			locs.append(
				{
					"position": cell_to_local_pos(t, cell),
					"cell": cell,
				}
			)

	if locs.size() > 0:
		locs.shuffle()
		var loc = locs[0]
		var inst = player_spawn_point_scene.instantiate()
		inst.position = loc["position"]
		add_child(inst)
		inst.unique_name_in_owner = true
		inst.set_owner(get_tree().edited_scene_root)


########################################################################
# enemy spawn point

var enemy_spawner_scene = preload("res://src/tower/EnemySpawner.tscn")


func add_enemy_spawner():
	free_children_in_group("enemy_spawner")

	var locs = []
	for t_cell in tilemap_cells({"group": "yellowtile"}):
		var t = t_cell[0]
		var cell = t_cell[1]
		var valid_nbrs = Reptile.valid_neighbors(t, cell)
		var enough_valid_nbrs = valid_nbrs.size() == 9
		var floor_below = (
			floor_tile_below(cell)
			and floor_tile_below(Vector2(cell.x + 1, cell.y))
			and floor_tile_below(Vector2(cell.x - 1, cell.y))
		)

		if enough_valid_nbrs and floor_below:
			locs.append(
				{
					"position": cell_to_local_pos(t, cell),
					"cell": cell,
				}
			)

	if locs.size() > 0:
		locs.shuffle()
		var loc = locs[0]
		var inst = enemy_spawner_scene.instantiate()
		inst.position = loc["position"]
		add_child(inst)
		inst.set_owner(get_tree().edited_scene_root)
