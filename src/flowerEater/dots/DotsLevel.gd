@tool
extends FlowerEaterLevel

var obj_scene_override = {
		"fallback": preload("res://src/flowerEater/objects/GenericObj.tscn"),
		"Player": preload("res://src/flowerEater/dots/objects/Player.tscn"),
		"Flower": preload("res://src/flowerEater/dots/objects/Target.tscn"),
		"FlowerEaten": preload("res://src/flowerEater/dots/objects/Target.tscn"),
		"Target": preload("res://src/flowerEater/dots/objects/Target.tscn"),
		}

func _init():
	obj_scene = obj_scene_override
