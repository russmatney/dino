@tool
extends BrickLevelGen

## get room opts #########################################

func get_room_opts(_opts):
	var default_room_opt = {}
	var initial_rooms = []

	var agg = range(room_count - len(initial_rooms)).reduce(func(acc, _i):
		var next_room_opt = default_room_opt.duplicate(true)
		acc.room_opts.append(next_room_opt)
		return acc, {room_opts=initial_rooms})

	for opt in agg.room_opts:
		opt.merge({
			label_to_tilemap={
				"Wall": {
				scene=load("res://addons/reptile/tilemaps/CaveTiles16.tscn"),
				add_borders=true,
				border_depth=10,
				},
				"Floor":{
					scene=load("res://addons/reptile/tilemaps/topdown/TDCaveFloorTiles16.tscn")
					},
				},
			label_to_entity={
				"Player": {scene=load("res://addons/core/PlayerSpawnPoint.tscn")},
				"Enemy": {scene=load("res://src/dino/SpawnPoint.tscn")},
				}})

	return agg.room_opts
