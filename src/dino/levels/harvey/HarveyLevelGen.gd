@tool
extends BrickLevelGen

func get_room_opts(opts):
	var room_opts = [{}]

	for opt in room_opts:
		opt.merge({
			label_to_tilemap={
				"Wall": {
					scene=load("res://src/tilemaps/caves/CaveTiles16.tscn"),
				},
				"Floor":{
					scene=load("res://src/tilemaps/caves/TDCaveFloorTiles16.tscn")
				},
			},
			label_to_entity={
				"Player": {scene=load("res://src/dino/entities/PlayerSpawnPoint.tscn")},
				"Plot": {
					scene=load("res://src/dino/entities/harvey_entities/Plot.tscn")
					},
				"CarrotSeedBox": {
					scene=load("res://src/dino/entities/harvey_entities/SeedBox.tscn"),
					setup=func(s):
					s.produce_type = "carrot"
					},
				"OnionSeedBox": {
					scene=load("res://src/dino/entities/harvey_entities/SeedBox.tscn"),
					setup=func(s):
					s.produce_type = "onion"
					},
				"TomatoSeedBox": {
					scene=load("res://src/dino/entities/harvey_entities/SeedBox.tscn"),
					setup=func(s):
					s.produce_type = "tomato"
					},
				"WateringPail": {
					scene=load("res://src/dino/entities/harvey_entities/Tool.tscn"),
					setup=func(t): t.tool_type = "watering-pail",
					},
				"UpDeliveryBox": {
					scene=load("res://src/dino/entities/harvey_entities/DeliveryBox.tscn"),
					setup=func(b):
					b.position += Vector2.DOWN * opts.tile_size
					b.position += Vector2.RIGHT * opts.tile_size
					b.rotation = PI
					},
				"DownDeliveryBox": {
					scene=load("res://src/dino/entities/harvey_entities/DeliveryBox.tscn"),
					},
				"LeftDeliveryBox": {
					scene=load("res://src/dino/entities/harvey_entities/DeliveryBox.tscn"),
					setup=func(b):
					b.position += Vector2.RIGHT * opts.tile_size
					b.rotation = PI/2
					},
				"RightDeliveryBox": {
					scene=load("res://src/dino/entities/harvey_entities/DeliveryBox.tscn"),
					setup=func(b):
					b.position += Vector2.DOWN * opts.tile_size
					b.rotation = 3*PI/2
					},
				"Bot": {scene=load("res://src/dino/npcs/action_bot/HarveyBot.tscn")},
			}})

	return room_opts
