extends Node

signal spawning_player

var player_scene = preload("res://src/ghosts/player/Player.tscn")
var player

#############################################################


func _ready():
	# register connections
	Ghosts.room_ready(self)
	spawn_player.call_deferred()


func spawn_player():
	if not $PlayerSpawner:
		Debug.pr("[WARN] no PlayerSpawner found")
		return

	var pos = $PlayerSpawner.global_position
	player = player_scene.instantiate()
	player.position = pos

	spawning_player.emit(player)
	player.player_died.connect(player_died)
	add_child.call_deferred(player)


#############################################################


func player_died():
	Navi.show_death_menu()
	DJ.resume_menu_song()


func player_won():
	Debug.pr("player won")
