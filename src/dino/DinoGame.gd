@tool
class_name DinoGame
extends Node


func get_player_scene():
	# defaults to returning a 'player_scene' var
	if get("player_scene") == null:
		Debug.err("no player_scene set")
		return
	return get("player_scene")

func on_player_spawned(_player):
	pass

func register():
	# register any static zones/scenes with Hotel
	Debug.warn("register() not implemented")

func start():
	# load the first level, maybe pull from a saved game
	# could accept params for which level to start
	Debug.warn("start() not implemented")

func update_world():
	# trigger any world update based on the player's position
	# (e.g. pausing/unpausing adjacent rooms)
	Debug.warn("update_world not implemented")

# func get_spawn_coords():
# 	Debug.warn("get_spawn_coords not implemented")

func manages_scene(_scene):
	# return true if the passed scene is managed by this game
	Debug.warn("manages_scene not implemented")
