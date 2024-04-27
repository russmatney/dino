@tool
extends Resource
class_name RoomEffect

## static ##################################

static func rain_fall():
	return RoomEffect.new({scene=load("res://src/effects/particle_area/RainFallParticles.tscn")})

static func snow_fall():
	return RoomEffect.new({scene=load("res://src/effects/particle_area/SnowFallParticles.tscn")})

## vars ##################################

@export var scene: PackedScene

## init ##################################

func _init(opts={}):
	if opts.get("scene"):
		scene = opts.get("scene")

## add at cell ##################################

func add_to_room(room_node: VaniaRoom):
	var room_def = room_node.room_def

	# add per cell, or per room?

	for cell in room_def.local_cells:
		var effect = scene.instantiate()

		if effect.has_method("adjust_for_rect"):
			var rect = room_def.get_local_rect(Vector2i(cell.x, cell.y))
			effect.adjust_for_rect(rect)

		room_node.add_child(effect)
		effect.set_owner(room_node)
