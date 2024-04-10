@tool
extends BrickLevelGen

## get room opts #########################################

func get_room_opts(_opts):
	var default_room_opt = {skip_flags=["first", "last"], side=Vector2.RIGHT}
	var initial_rooms = [{flags=["first"]}]
	var final_room = {flags=["last"], side=Vector2.RIGHT}

	var agg = range(room_count - 2).reduce(func(acc, _i):
		var next_room_opt = default_room_opt.duplicate(true)
		acc.room_opts.append(next_room_opt)
		return acc, {room_opts=initial_rooms})

	var room_opts = agg.room_opts
	room_opts.append(final_room)

	for opt in room_opts:
		opt.merge({
			label_to_tilemap={"Tile": {
				scene=load("res://addons/core/reptile/tilemaps/MetalTiles8.tscn"),
				}},
			label_to_entity={
				"Player": {scene=load("res://addons/core/PlayerSpawnPoint.tscn")},
				"Machine": {scene=load("res://src/games/pluggs/entities/ArcadeMachine.tscn")},
				"Light": {scene=load("res://src/games/pluggs/entities/Light.tscn")},
				}})

	return room_opts
