@tool
extends BrickLevelGen

func get_room_opts(opts):
	var default_room_opt = {}

	var initial_rooms = []

	var agg = range(room_count - len(initial_rooms) - 1).reduce(func(agg, _i):
		var next_room_opt = default_room_opt.duplicate(true)
		agg.room_opts.append(next_room_opt)
		return agg, {room_opts=initial_rooms})

	for opt in agg.room_opts:
		opt.merge({
			label_to_tilemap={
				"Tile": {
					scene=load("res://addons/reptile/tilemaps/MetalTiles8.tscn"),
				},
			},
			label_to_entity={
				"Player": {scene=load("res://addons/core/PlayerSpawnPoint.tscn")},
				"Target": {scene=load("res://src/gunner/targets/Target.tscn"),
					setup=func(t):
					t.position += Vector2.RIGHT * opts.tile_size / 2.0
					t.position += Vector2.DOWN * opts.tile_size / 2.0
					},
				"Enemy": {scene=load("res://src/gunner/enemies/EnemyRobot.tscn")},
			}})

	return agg.room_opts
