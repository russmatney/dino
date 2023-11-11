@tool
extends DinoGame

## room_scenes ##########################################################

const room_scenes = [
	"res://src/ghosts/world/House.tscn",
	"res://src/ghosts/world/Office.tscn",
	"res://src/ghosts/world/Pit.tscn",
	"res://src/ghosts/world/Library.tscn",
	"res://src/ghosts/world/Cells.tscn",
	]

## register ##########################################################

var first_room

func register():
	register_menus()

	if first_room == null:
		first_room = room_scenes[0]

## player ##########################################################

var player_sfp = "res://src/ghosts/player/Player.tscn"

func reset_player_data():
	Log.warn("Ghost player reset not impled!")

func get_spawn_coords():
	var player_spawner = U.first_node_in_group(self, "player_spawn_points")
	if not player_spawner:
		Log.warn("no node in 'player_spawner' group found")
		return

	return player_spawner.global_position

# invoked by Game.gd
func on_player_spawned(player):
	player.died.connect(on_player_died)

## start ##########################################################

func start(_opts={}):
	Log.pr("Starting Ghost House!")
	reset_player_data()
	Navi.nav_to(first_room)

func on_player_died():
	Navi.show_death_menu()
	DJ.resume_menu_song()

