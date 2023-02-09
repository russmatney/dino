extends Node

signal spawning_player

var player_scene = preload("res://src/ghosts/player/Player.tscn")

var player

#############################################################


func _ready():
	# register connections
	Ghosts.room_ready(self)

	call_deferred("spawn_player")


func spawn_player():
	if not $PlayerSpawner:
		print("[WARN] no PlayerSpawner found")
		return

	var pos = $PlayerSpawner.global_position
	player = player_scene.instantiate()
	player.position = pos

	emit_signal("spawning_player", player)

	player.connect("player_died",Callable(self,"player_died"))

	call_deferred("add_child", player)


#############################################################


func player_died():
	Navi.show_death_menu()
	DJ.resume_menu_song()


func player_won():
	print("player won")
