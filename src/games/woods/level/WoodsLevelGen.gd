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

	var agg = range(room_count - 1).reduce(func(acc, _i):
		var next_room_opt = default_room_opt.duplicate(true)

		acc.room_opts.append(next_room_opt)

		return acc, {room_opts=initial_rooms})

	var room_opts = agg.room_opts

	for opt in room_opts:
		opt.merge({
			label_to_tilemap={"Tile": {
				scene=load("res://addons/core/reptile/tilemaps/WoodsFloorTiles16.tscn"),
				# add_borders=true,
				border_depth={down=30, left=20, right=20},
				# border_depth=30,
				}},
			label_to_entity={
				"Player": {scene=DinoEntity.get_entity_scene(DinoEntityIds.PLAYERSPAWNPOINT)},
				"Leaf": {scene=DinoEntity.get_entity_scene(DinoEntityIds.LEAF)},
				}})

	return room_opts