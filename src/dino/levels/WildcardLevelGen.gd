@tool
extends BrickLevelGen

func get_room_opts(opts):
	var room_opts = [{
		flags=["has_cooking_pot"],
		}, {
		flags=["has_void"],
		}, {
		flags=["has_blobs"],
		}, {
		flags=["has_targets"],
		}, {
		flags=["has_player"],
		}, {
		flags=["has_enemies"],
		}, {
		flags=["has_leaves"],
		}, {
		flags=["has_leaves"],
		}]

	room_opts.shuffle()

	opts.merge({
		label_to_tilemap={
			"Tile": {
				scene=load("res://src/tilemaps/grass/GrassTiles16.tscn"),
				# border_depth={down=30, left=20, right=20},
				}
			},
		label_to_entity=DinoLevelGenData.label_to_entity(opts),
		})

	return room_opts
