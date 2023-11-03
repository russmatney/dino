@tool
extends BrickLevelGen

var delivery_zone_scene = preload("res://src/spike/entities/DeliveryZone.tscn")

## get room opts #########################################

func get_room_opts(opts):
	var default_room_opt = {}
	var initial_rooms = []

	var agg = range(room_count - len(initial_rooms)).reduce(func(agg, _i):
		var next_room_opt = default_room_opt.duplicate(true)
		agg.room_opts.append(next_room_opt)
		return agg, {room_opts=initial_rooms})

	for opt in agg.room_opts:
		opt.merge({
			label_to_tilemap={
				"Tile": {
					scene=load("res://addons/reptile/tilemaps/GrassTiles16.tscn"),
					add_borders=true
				},
				# may want to suppport something like this
				# "Void": {
				# 	scene=load("res://addons/reptile/tilemaps/GrassTiles16.tscn"),
				# 	# support tilemap -> entity
				# 	setup=func(t):
				# 	var areas = Reptile.to_areas(t)
				# 	for area in areas:
				# 		var delivery_zone = delivery_zone_scene.instantiate()
				# 		delivery_zone.set_area(area)
				# 	},
			},
			label_to_entity={
				"Player": {scene=load("res://addons/core/PlayerSpawnPoint.tscn")},
				"CookingPot": {scene=load("res://src/spike/entities/CookingPot.tscn"),
					setup=func(p):
					p.position += Vector2(opts.tile_size/2.0, opts.tile_size)
					},
				"Blob": {scene=load("res://src/spike/enemies/Blob.tscn")},
				"Void": {scene=load("res://src/spike/entities/DeliveryZone.tscn")},
				"OneWayPlatform": {scene=load("res://src/spike/zones/OneWayPlatform.tscn"),
					# resize to match tile_size
					setup=func(p):
					p.max_width = opts.tile_size
					p.position.x += opts.tile_size/2.0
					p.position.y += opts.tile_size/4.0
					}
				}})

	return agg.room_opts
