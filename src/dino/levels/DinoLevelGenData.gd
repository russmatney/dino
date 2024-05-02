@tool
extends Object
class_name DinoLevelGenData

static func label_to_entity(opts):
	return {
		# platforms/walls
		"OneWayPlatform": {scene=load("res://src/dino/platforms/OneWayPlatform.tscn"),
			# resize to match tile_size
			setup=func(p):
			p.max_width = opts.tile_size
			p.position.x += opts.tile_size/2.0
			p.position.y += opts.tile_size/4.0
			},
		}

