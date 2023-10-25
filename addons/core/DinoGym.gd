@tool
extends Node
class_name DinoGym

@export var player_scene: PackedScene

func _ready():
	Game.maybe_spawn_player({player_scene=player_scene})
