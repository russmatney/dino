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
		}]

	room_opts.shuffle()

	opts.merge({
		label_to_tilemap={
			"Tile": {
				scene=load("res://addons/reptile/tilemaps/GrassTiles16.tscn")
				}
			},
		label_to_entity={
			"Player": {scene=load("res://addons/core/PlayerSpawnPoint.tscn")},
			"CookingPot": {scene=load("res://src/spike/entities/CookingPot.tscn"),
				setup=func(p): p.position += Vector2(opts.tile_size/2.0, opts.tile_size)
				},
			"Blob": {scene=load("res://src/spike/enemies/Blob.tscn")},
			"Void": {scene=load("res://src/spike/entities/DeliveryZone.tscn")},
			"OneWayPlatform": {scene=load("res://src/spike/zones/OneWayPlatform.tscn"),
				# resize to match tile_size
				setup=func(p):
				p.max_width = opts.tile_size
				p.position.x += opts.tile_size/2.0
				p.position.y += opts.tile_size/4.0
				},
			"Target": {scene=load("res://src/gunner/targets/Target.tscn"),
				setup=func(t):
				t.position += Vector2.RIGHT * opts.tile_size / 2.0
				t.position += Vector2.DOWN * opts.tile_size / 2.0
				},
			"Enemy": {scene=load("res://src/gunner/enemies/EnemyRobot.tscn")},
			}})

	return room_opts
