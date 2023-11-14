extends Node
class_name DinoGym

@export var player_scene: PackedScene

func _ready():
	P.respawn_player({player_scene=player_scene})
