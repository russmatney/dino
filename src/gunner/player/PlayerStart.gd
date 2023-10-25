extends Marker2D

@export var spawn_on_ready: bool = false

signal spawning_player

var player_scene = preload("res://src/gunner/player/Player.tscn")

var player

#############################################################


func _ready():
	if spawn_on_ready:
		spawn_player.call_deferred()


func spawn_player():
	player = player_scene.instantiate()
	player.position = global_position

	spawning_player.emit(player)
	add_child.call_deferred(player)
