@tool
extends BrickLevelGen

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
				},
				"Floor":{
					scene=load("res://addons/reptile/tilemaps/topdown/TDCaveFloorTiles16.tscn")
				},
				"Pen":{
					scene=load("res://addons/reptile/tilemaps/GrassFloorTiles16.tscn"),
					setup=func(t):
					t.add_to_group("pen", true)
					},
				"Fence":{
					scene=load("res://src/herd/tiles/FenceTiles.tscn")
				},
			},
			label_to_entity={
				"Player": {scene=load("res://addons/core/PlayerSpawnPoint.tscn")},
				"Sheep": {scene=load("res://src/herd/sheep/Sheep.tscn")},
				"Wolf": {scene=load("res://src/herd/wolf/Wolf.tscn")},
			}})

	return agg.room_opts
