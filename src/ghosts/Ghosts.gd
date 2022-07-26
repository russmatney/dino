tool
extends Node

signal room_entered

#############################################################

signal notification

func create_notification(message, ttl = 5):
	emit_signal("notification", {"msg": message, "ttl": ttl})

#############################################################

func _ready():
	if OS.has_feature("ghosts"):
		Navi.set_main_menu("res://src/ghosts/GhostsMenu.tscn")

#############################################################

var player
var player_data = {}

func room_ready(room):
	room.connect("spawning_player", self, "spawning_player")
	create_notification(str("Entered: ", room.name))
	emit_signal("room_entered", room)


func spawning_player(p):
	player = p
	restore_saved_player_data()

func restore_saved_player_data():
	for k in player_data:
		player.set(k, player_data[k])

func save_player_data():
	if player:
		player_data = {
			"health": player.health,
			"gloomba_kos": player.gloomba_kos,
			}
	else:
		print("[WARN] Ghosts save_player_data called with no player")

#############################################################

func restart_game():
	player_data = {}
	Navi.nav_to("res://src/ghosts/world/House.tscn")

#############################################################

func load_next_room(room_path):
	if room_path and not File.new().file_exists(room_path):
		print("[WARN] Ghosts next room does not exist! ", room_path)
		return

	# save player data to restore upon next spawn
	save_player_data()

	# load the next level (note this is deferred)
	Navi.nav_to(room_path)
