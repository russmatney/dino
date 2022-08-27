extends Node2D

onready var player_start = get_node("%PlayerStart")
var player

func _ready():
	player = player_start.spawn_player(self)

	if player:
		player.add_to_group("player")
	else:
		print("failed to spawn player?")
