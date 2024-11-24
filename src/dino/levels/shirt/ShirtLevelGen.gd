@tool
extends BrickLevelGen

## get room opts #########################################

# TODO test setup, maybe testing specific seeds?
func get_room_opts(_opts):
	var default_room_opt = {skip_flags=["first"]}

	var initial_rooms = [
		{flags=["first"]},
		{skip_flags=["first"],
			# TODO maybe better as 'extend_side' or 'direction'
			side=Vector2.RIGHT},
		]

	var agg = range(room_count - len(initial_rooms) - 1).reduce(func(acc, _i):
		var next_room_opt = default_room_opt.duplicate(true)

		var side_opts = [
			Vector2.UP, Vector2.DOWN, Vector2.RIGHT, Vector2.LEFT
			].filter(func(s): return s != acc.last_side)
		next_room_opt["side"] = U.rand_of(side_opts)

		acc.room_opts.append(next_room_opt)
		acc.last_side = next_room_opt.side

		return acc, {room_opts=initial_rooms, last_side=Vector2.RIGHT})

	for opt in agg.room_opts:
		opt.merge({
			label_to_tilemap={"Tile": {
				scene=load("res://src/tilemaps/caves/CaveTiles16.tscn"),
				add_borders=true
				},
				"Floor":{
					scene=load("res://src/tilemaps/caves/TDCaveFloorTiles16.tscn")
					},
				"Pit":{
					scene=load("res://src/tilemaps/caves/TDCavePitTiles16.tscn")
					}
				},
			label_to_entity={
				"Player": {scene=load("res://src/dino/entities/PlayerSpawnPoint.tscn")},
				"Chaser": {scene=load("res://src/dino/enemies/blobs/BlobChaser.tscn")},
				"Walker": {scene=load("res://src/dino/enemies/blobs/BlobWalker.tscn")},
				"Gem": {scene=load("res://src/dino/pickups/coins/ShrineGem.tscn")},
				}})

	return agg.room_opts
