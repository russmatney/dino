@tool
extends Resource
class_name RoomEffect

## static ##################################

static func random_effect():
	return U.rand_of([
		RoomEffect.rain_fall(),
		RoomEffect.snow_fall(),
		RoomEffect.leaf_fall(),
		RoomEffect.dust(),
		RoomEffect.fire_particles(),
		RoomEffect.gold_particles(),
		])

static func rain_fall():
	return RoomEffect.new({scene=load("res://src/effects/particle_area/RainFallParticles.tscn")})

static func snow_fall():
	return RoomEffect.new({scene=load("res://src/effects/particle_area/SnowFallParticles.tscn")})

static func leaf_fall():
	return RoomEffect.new({scene=load("res://src/effects/particle_area/LeafFallParticleArea.tscn")})

static func dust():
	return RoomEffect.new({scene=load("res://src/effects/particle_area/DustParticles.tscn")})

static func fire_particles():
	return RoomEffect.new({scene=load("res://src/effects/particle_area/FireParticleArea.tscn")})

static func gold_particles():
	return RoomEffect.new({scene=load("res://src/effects/particle_area/GoldParticleArea.tscn")})

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
