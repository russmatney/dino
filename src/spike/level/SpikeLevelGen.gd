@tool
extends BrickLevelGen

# var delivery_zone_scene = preload("res://src/spike/entities/DeliveryZone.tscn")
var portal_edges_scene = preload("res://src/spike/zones/PortalEdges.tscn")

## get room opts #########################################

func get_room_opts(opts):
	var default_room_opt = {}
	var initial_rooms = []

	var agg = range(room_count - len(initial_rooms)).reduce(func(agg, _i):
		var next_room_opt = default_room_opt.duplicate(true)
		agg.room_opts.append(next_room_opt)
		return agg, {room_opts=initial_rooms})

	opts.merge({
		label_to_tilemap={
			"Tile": {
				scene=load("res://addons/reptile/tilemaps/GrassTiles16.tscn"),
				add_borders=true
			},
			# may want to support something like this
			# "Void": {
			# 	scene=load("res://addons/reptile/tilemaps/GrassTiles16.tscn"),
			# 	# support tilemap -> entity
			# 	setup=func(t):
			# 	var areas = Reptile.to_areas(t)
			# 	for area in areas:
			# 		var delivery_zone = delivery_zone_scene.instantiate()
			# 		delivery_zone.set_area(area)
			# 	},
			"PortalBottom": {
				# some scene that gets replaced anyway
				scene=load("res://addons/reptile/tilemaps/MetalTiles8.tscn"),
				to_entities=func(t):
				# TODO opt-out when there are no tiles!!

				# should support getting multiple areas from a tilemap
				var area = Reptile.to_area2D(t)
				area.name = "Bottom"

				var portal_edges = portal_edges_scene.instantiate()
				portal_edges.add_child(area)

				return [portal_edges]
				}
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
				},
			"PortalTop": {
				new_node=func():
					var top = Marker2D.new()
					top.name = "Top"
					return top,
				find_entity=func(entities):
					for ent in entities:
						# TODO this breaks b/c names are weak! (if there are multiple 'Top')
						if ent.name == "Top":
							return ent,
				setup_with_entities=func(top, entities):
					# find portal_edges, add yourself to it?
					for ent in entities:
						if ent.name == "PortalEdges":
							Debug.pr("found portal edges, reparenting", top)
							# top.reparent(ent)
							break
					# return updated entities
					Debug.pr("returning ents pre filter", entities)
					return entities.filter(func(ent): return ent.name != "Top")
					},
			}})

	return agg.room_opts
