@tool
extends BrickLevelGen

func get_room_opts(opts):
	var default_room_opt = {}
	var initial_rooms = []

	var agg = range(room_count - len(initial_rooms)).reduce(func(acc, _i):
		var next_room_opt = default_room_opt.duplicate(true)
		acc.room_opts.append(next_room_opt)
		return acc, {room_opts=initial_rooms})

	for opt in agg.room_opts:
		opt.merge({
			label_to_tilemap={
				"Tile": {
					scene=load("res://addons/core/reptile/tilemaps/MetalTiles8.tscn"),
				},
			},
			label_to_entity={
				"Player": {scene=DinoEntity.get_entity_scene(DinoEntityIds.PLAYERSPAWNPOINT)},
				"Enemy": {scene=DinoEnemy.get_enemy_scene(EnemyIds.ROBOT)},
				"Target": {scene=DinoEntity.get_entity_scene(DinoEntityIds.TARGET),
					setup=func(t):
					t.position += Vector2.RIGHT * opts.tile_size / 2.0
					t.position += Vector2.DOWN * opts.tile_size / 2.0
					},
			}})

	return agg.room_opts
