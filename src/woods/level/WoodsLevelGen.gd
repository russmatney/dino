@tool
extends BrickLevelGen

## get room opts #########################################

func get_room_opts(_opts):
	var default_room_opt = {
		filter_rooms=func(r): return not r.meta.get("room_type") in ["START", "END"],
		side=Vector2.RIGHT
		}

	var initial_rooms = [
		{filter_rooms=func(r): return r.meta.get("room_type") == "START"},
		]

	var final_room = {filter_rooms=func(r): return r.meta.get("room_type") == "END",
		side=Vector2.RIGHT}

	var agg = range(room_count - 2).reduce(func(agg, _i):
		var next_room_opt = default_room_opt.duplicate(true)

		agg.room_opts.append(next_room_opt)

		return agg, {room_opts=initial_rooms})

	var room_opts = agg.room_opts
	room_opts.append(final_room)

	for opt in room_opts:
		opt.merge({
			label_to_tilemap={"Tile": {
				scene=load("res://addons/reptile/tilemaps/WoodsFloorTiles16.tscn"),
				}},
			label_to_entity={
				"Player": {scene=load("res://addons/core/PlayerSpawnPoint.tscn")},
				"Leaf": {scene=load("res://src/woods/entities/Leaf.tscn")},
				}})

	return room_opts