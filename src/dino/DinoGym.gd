@tool
extends Node
class_name DinoGym


func _ready():
	# TODO add PlayerSpawnPoint if there is none
	Game.maybe_spawn_player()
