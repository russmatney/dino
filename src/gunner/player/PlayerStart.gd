extends Position2D

export(bool) var spawn_on_ready = false

signal spawning_player

var player_scene = preload("res://src/gunner/player/Player.tscn")

var player

#############################################################


func _ready():
	# TODO probably never want to do this in more than one place
	if spawn_on_ready:
		call_deferred("spawn_player")


func spawn_player():
	# TODO probably better to create and spawn from our autoload/gamestate
	# or better yet, create a SuperPlayer autoload for drying up separate player states
	player = player_scene.instance()
	player.position = global_position

	emit_signal("spawning_player", player)
	call_deferred("add_child", player)
