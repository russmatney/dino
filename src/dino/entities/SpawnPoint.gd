@tool
extends Marker2D
class_name DinoSpawnPoint

@export var spawn_scene: PackedScene
var spawns = []

func spawn_entity():
	if spawn_scene == null:
		Log.warn("No spawn_scene set, cannot spawn entity", self)
		return
	spawns = spawns.filter(func(sp): return is_instance_valid(sp))
	var ent = spawn_scene.instantiate()
	ent.position = position
	spawns.append(ent)
	return ent
