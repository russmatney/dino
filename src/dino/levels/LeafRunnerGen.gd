@tool
extends BrickLevelGen

func get_room_opts(opts):
	var room_opts = [{
		flags=["has_player"],
		}, {}, {}, {}, {}]

	room_opts.shuffle()

	opts.merge({
		label_to_tilemap={
			"Tile": {
				scene=load("res://addons/core/reptile/tilemaps/GrassTiles16.tscn"),
				# border_depth={down=30, left=20, right=20},
				}
			},
		label_to_entity=DinoLevelGenData.label_to_entity(opts),
		})

	return room_opts
