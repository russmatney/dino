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
				"Wall": {
					scene=load("res://addons/core/reptile/tilemaps/CaveTiles16.tscn"),
				},
				"Floor":{
					scene=load("res://addons/core/reptile/tilemaps/topdown/TDCaveFloorTiles16.tscn")
				},
			},
			label_to_entity={
				"Player": {scene=load("res://addons/core/PlayerSpawnPoint.tscn")},
				"Plot": {
					scene=load("res://src/games/harvey/plots/Plot.tscn")
					},
				"CarrotSeedBox": {
					scene=load("res://src/games/harvey/items/SeedBox.tscn"),
					setup=func(s):
					s.produce_type = "carrot"
					},
				"OnionSeedBox": {
					scene=load("res://src/games/harvey/items/SeedBox.tscn"),
					setup=func(s):
					s.produce_type = "onion"
					},
				"TomatoSeedBox": {
					scene=load("res://src/games/harvey/items/SeedBox.tscn"),
					setup=func(s):
					s.produce_type = "tomato"
					},
				"WateringPail": {
					scene=load("res://src/games/harvey/items/Tool.tscn"),
					setup=func(t): t.tool_type = "watering-pail",
					},
				"UpDeliveryBox": {
					scene=load("res://src/games/harvey/items/DeliveryBox.tscn"),
					setup=func(b):
					b.position += Vector2.DOWN * opts.tile_size
					b.position += Vector2.RIGHT * opts.tile_size
					b.rotation = PI
					},
				"DownDeliveryBox": {
					scene=load("res://src/games/harvey/items/DeliveryBox.tscn"),
					},
				"LeftDeliveryBox": {
					scene=load("res://src/games/harvey/items/DeliveryBox.tscn"),
					setup=func(b):
					b.position += Vector2.RIGHT * opts.tile_size
					b.rotation = PI/2
					},
				"RightDeliveryBox": {
					scene=load("res://src/games/harvey/items/DeliveryBox.tscn"),
					setup=func(b):
					b.position += Vector2.DOWN * opts.tile_size
					b.rotation = 3*PI/2
					},
				"Bot": {scene=load("res://src/games/harvey/bots/HarveyBot.tscn")},
			}})

	return agg.room_opts
