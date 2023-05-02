@tool
extends Node
class_name DinoGym


# Called when the node enters the scene tree for the first time.
func _ready():
	Game.maybe_spawn_player()
