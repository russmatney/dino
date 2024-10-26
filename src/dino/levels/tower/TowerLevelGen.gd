@tool
extends BrickLevelGen

# var def = MapDef.new({
# 	rooms=[
# 		MapInput.with({entity_ids=[DinoEntityIds.PLAYERSPAWNPOINT,]}),
# 		# ... some in-betweeners
# 		MapInput.with({entity_ids=[DinoEntityIds.CANDLE,]}),
# 		# ... some in-betweeners
# 		# MapInput.with({entity_ids=[DinoEntityIds.GOAL,]}),
# 		]
# 	})

func get_room_opts(opts):
	var default_room_opt = {flags=["middle"], side=Vector2.UP}

	var initial_rooms = [{flags=["bottom", "quick"]}]
	var final_rooms = [{flags=["top", "quick"], side=Vector2.UP}, {flags=["end"], side=Vector2.RIGHT}]

	var agg = range(room_count - len(initial_rooms) - len(final_rooms)).reduce(func(acc, _i):
		var next_room_opt = default_room_opt.duplicate(true)
		acc.room_opts.append(next_room_opt)
		return acc, {room_opts=initial_rooms})

	var room_opts = []
	room_opts.append_array(agg.room_opts) # includes initial rooms already
	room_opts.append_array(final_rooms)

	for opt in room_opts:
		opt.merge({
			label_to_tilemap={
				"Tile": {
					scene=load("res://addons/bones/reptile/tilemaps/MetalTiles8.tscn"),
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

	return room_opts
