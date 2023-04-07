@tool
class_name DinoGame
extends Node


func get_player_scene():
	if not get("player_scene"):
		Debug.err("no player_scene set")
		return
	return get("player_scene")

func register():
	Debug.warn("register() not implemented")

func start():
	Debug.warn("start() not implemented")

func update_world():
	Debug.warn("update_world not implemented")

# func get_spawn_coords():
# 	Debug.warn("get_spawn_coords not implemented")

func manages_scene(_scene):
	Debug.warn("manages_scene not implemented")
