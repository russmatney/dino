@tool
extends BrickLevelGen

var portal_edges_scene = preload("res://src/dino/platforms/PortalEdges.tscn")

## get room opts #########################################

func get_room_opts(opts):
	var default_room_opt = {}
	var initial_rooms = []

	var agg = range(room_count - len(initial_rooms)).reduce(func(acc, _i):
		var next_room_opt = default_room_opt.duplicate(true)
		acc.room_opts.append(next_room_opt)
		return acc, {room_opts=initial_rooms})

	opts.merge({
		label_to_tilemap={
			"Tile": {scene=load("res://addons/core/reptile/tilemaps/GrassTiles16.tscn")},
			"PortalBottom": {
				# some scene that gets replaced anyway
				scene=load("res://addons/core/reptile/tilemaps/MetalTiles8.tscn"),
				to_entities=func(t):
				var rect = t.get_used_rect()
				if rect.size.x == 0:
					# opt-out when there are no tiles
					return []

				# should support getting multiple areas from a tilemap
				var area = Reptile.to_area2D(t)
				area.name = "Bottom"

				area.set_collision_layer_value(1, false)
				area.set_collision_mask_value(1, false)
				area.set_collision_mask_value(2, true)
				area.set_collision_mask_value(3, true)
				area.set_collision_mask_value(4, true)
				area.set_collision_mask_value(5, true)
				area.set_collision_mask_value(6, true)
				area.set_collision_mask_value(10, true)

				var portal_edges = portal_edges_scene.instantiate()
				portal_edges.add_child(area)

				return [portal_edges]
				}
		},
		label_to_entity={
			"Player": {scene=DinoEntity.get_entity_scene(DinoEntityIds.PLAYERSPAWNPOINT)},
			"CookingPot": {scene=DinoEntity.get_entity_scene(DinoEntityIds.COOKINGPOT),
				setup=func(p): p.position += Vector2(opts.tile_size/2.0, opts.tile_size)
				},
			"Blob": {scene=DinoEnemy.get_enemy_scene(EnemyIds.BLOB)},
			"Void": {scene=DinoEntity.get_entity_scene(DinoEntityIds.VOID),},
			"OneWayPlatform": {scene=load("res://src/dino/platforms/OneWayPlatform.tscn"),
				# resize to match tile_size
				setup=func(p):
				p.max_width = opts.tile_size
				p.position.x += opts.tile_size/2.0
				p.position.y += opts.tile_size/4.0
				},
			}})

	return agg.room_opts
