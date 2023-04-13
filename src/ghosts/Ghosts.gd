@tool
extends Node

signal room_entered

#############################################################

var player

func room_ready(room):
	room.spawning_player.connect(func(p): player = p)
	Hood.notif(str("Entered: ", room.name))
	room_entered.emit(room)

var player_sfp = "res://src/ghosts/player/Player.tscn"

func reset_player_data():
	Hotel.check_in_sfp(player_sfp, {health=6, gloomba_kos=0})

#############################################################

func restart_game():
	reset_player_data()
	Navi.nav_to("res://src/ghosts/world/House.tscn")

#############################################################

func load_next_room(room_path):
	if room_path and not FileAccess.file_exists(room_path):
		Debug.warn("Next room does not exist!", room_path)
		return

	# load the next level (note this is deferred)
	Navi.nav_to(room_path)
