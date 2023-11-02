@tool
extends BrickLevelGen

func get_room_opts(_opts):
	var default_room_opt = {}

	var initial_rooms = []

	var agg = range(room_count - len(initial_rooms)).reduce(func(agg, _i):
		var next_room_opt = default_room_opt.duplicate(true)
		agg.room_opts.append(next_room_opt)
		return agg, {room_opts=initial_rooms})

	for opt in agg.room_opts:
		opt.merge({
			label_to_tilemap={
				"Wall": {
					scene=load("res://addons/reptile/tilemaps/CaveTiles16.tscn"),
					add_borders=true
				},
				"Floor":{
					scene=load("res://addons/reptile/tilemaps/topdown/TDCaveFloorTiles16.tscn")
				},
			},
			label_to_entity={
				"Player": {scene=load("res://addons/core/PlayerSpawnPoint.tscn")},
				"Plot": {scene=load("res://src/harvey/plots/Plot.tscn")},
				"CarrotSeedBox": {
					scene=load("res://src/harvey/items/SeedBox.tscn"),
					setup=func(s): s.produce_type = "carrot",
					},
				"OnionSeedBox": {
					scene=load("res://src/harvey/items/SeedBox.tscn"),
					setup=func(s): s.produce_type = "onion",
					},
				"TomatoSeedBox": {
					scene=load("res://src/harvey/items/SeedBox.tscn"),
					setup=func(s): s.produce_type = "tomato",
					},
				"WateringPail": {
					scene=load("res://src/harvey/items/Tool.tscn"),
					setup=func(t): t.tool_type = "watering-pail",
					},
				"DeliveryBox": {scene=load("res://src/harvey/items/DeliveryBox.tscn")},
				"Bot": {scene=load("res://src/harvey/bots/HarveyBot.tscn")},
			}})

	return agg.room_opts
