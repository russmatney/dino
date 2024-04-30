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
					scene=load("res://addons/core/reptile/tilemaps/CaveTiles16.tscn"),
					add_borders=true,
				},
				"Floor":{
					scene=load("res://addons/core/reptile/tilemaps/topdown/TDCaveFloorTiles16.tscn")
				},
				"Pen":{
					scene=load("res://addons/core/reptile/tilemaps/GrassFloorTiles16.tscn"),
					to_entities=func(t):
					var rect = t.get_used_rect()
					if rect.size.x == 0:
						# opt-out when there are no tiles
						# TODO do this before to_entities call
						return []

					var pen = load("res://src/dino/entities/pen/SheepPen.tscn").instantiate()
					var coll = Reptile.tmap_to_collision_shape(t)
					pen.add_child(coll)

					# TODO leave the grass tiles in place!

					return [pen]
					},
				"Fence":{
					scene=load("res://src/dino/entities/fences/FenceTiles.tscn")
				},
			},
			label_to_entity={
				"Player": {scene=DinoEntity.get_entity_scene(DinoEntityIds.PLAYERSPAWNPOINT)},
				"Sheep": {scene=load("res://src/dino/npcs/sheep/Sheep.tscn")},
			}})

	return agg.room_opts
