@tool
extends Object
class_name DinoLevelGenData

static func label_to_entity(opts):
	return {
		# player
		"Player": {scene=load("res://addons/core/PlayerSpawnPoint.tscn")},

		# enemies
		"Blob": {scene=load("res://src/spike/enemies/Blob.tscn")},
		"Enemy": {scene=load("res://src/gunner/enemies/EnemyRobot.tscn")},

		# entities
		"CookingPot": {scene=load("res://src/spike/entities/CookingPot.tscn"),
			setup=func(p): p.position += Vector2(opts.tile_size/2.0, opts.tile_size)
			},
		"Void": {scene=load("res://src/spike/entities/DeliveryZone.tscn")},
		"Target": {scene=load("res://src/gunner/targets/Target.tscn"),
			setup=func(t):
			t.position += Vector2.RIGHT * opts.tile_size / 2.0
			t.position += Vector2.DOWN * opts.tile_size / 2.0
			},

		# platforms/walls
		"OneWayPlatform": {scene=load("res://src/spike/zones/OneWayPlatform.tscn"),
			# resize to match tile_size
			setup=func(p):
			p.max_width = opts.tile_size
			p.position.x += opts.tile_size/2.0
			p.position.y += opts.tile_size/4.0
			},
		}
