@tool
extends DinoGame

var rooms_group = "ghost_rooms"

###########################################################
# room_scenes

const room_scenes = [
	"res://src/ghosts/world/House.tscn",
	"res://src/ghosts/world/Office.tscn",
	"res://src/ghosts/world/Pit.tscn",
	"res://src/ghosts/world/Library.tscn",
	"res://src/ghosts/world/Cells.tscn",
	]

###########################################################
# register

func manages_scene(scene):
	return scene.scene_file_path in room_scenes

var first_room

func register():
	main_menu_scene = load("res://src/ghosts/GhostsMenu.tscn")
	register_menus()
	Debug.pr("Registering GhostHouse Rooms")
	Hotel.add_root_group(rooms_group)

	for sfp in room_scenes:
		Hotel.book(sfp)

	if first_room == null:
		first_room = room_scenes[0]

	var rooms = Hotel.query({group=rooms_group})

	Debug.pr("GhostHouse registered", len(rooms), "rooms and first room", first_room)

###########################################################
# player

var player_sfp = "res://src/ghosts/player/Player.tscn"
var player_scene = preload("res://src/ghosts/player/Player.tscn")

func reset_player_data():
	Hotel.check_in_sfp(player_sfp, {health=6, gloomba_kos=0})

func get_player_scene():
	return player_scene

func get_spawn_coords():
	var player_spawner = Util.first_node_in_group("player_spawners")
	if not player_spawner:
		Debug.warn("no node in 'player_spawner' group found")
		return

	return player_spawner.global_position

# invoked by Game.gd
func on_player_spawned(player):
	player.player_died.connect(on_player_died)

###########################################################
# start

func start():
	Debug.pr("Starting Ghost House!")
	reset_player_data()
	load_next_room(first_room)

func on_player_died():
	Navi.show_death_menu()
	DJ.resume_menu_song()


#############################################################

func update_world():
	pass

#############################################################

func load_next_room(room_path):
	if room_path and not ResourceLoader.exists(room_path):
		Debug.warn("Next room does not exist!", room_path)
		return

	# load the next level (note this is deferred)
	Navi.nav_to(room_path)
