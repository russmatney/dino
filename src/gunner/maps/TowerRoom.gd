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
		"seed": rand_range(0, 50000),
		"octaves": Util.rand_of([2, 3, 4]),
		"period": rand_range(5, 30),
		"persistence": rand_range(0.3, 0.7),
		"lacunarity": rand_range(2.0, 4.0),
		"img_size": rand_range(40, 60)
	}]
	options.shuffle()
	return options[0]
