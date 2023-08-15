@tool
extends DinoGame

func _ready():
	pause_menu_scene = load("res://src/mountain/menus/PauseMenu.tscn")
	main_menu_scene = load("res://src/mountain/menus/MainMenu.tscn")
	icon_texture = load("res://assets/gameicons/The_Mountain_icon_sheet.png")

const zones = [
	"res://src/mountain/zones/TheMountain.tscn"
	]

## manages #####################################################

func manages_scene(scene):
	return scene.scene_file_path.begins_with("res://src/mountain")

func should_spawn_player(scene):
	return not scene.scene_file_path.begins_with("res://src/mountain/menus")

######################################################
# player

var player_scene = preload("res://src/mountain/player/Player.tscn")

func on_player_spawned(player):
	player.died.connect(_on_player_death)

func get_spawn_coords():
	return Metro.get_spawn_coords()

func _on_player_death():
	Game.respawn_player({setup_fn=func(p): p.recover_health()})

######################################################
# register

func register():
	register_menus()

	# is this required anymore?
	Hotel.add_root_group(Metro.zones_group)

	for z in zones:
		Hotel.book(z)


######################################################
# start

func start():
	Metro.load_zone(zones[0])

######################################################
# update world

func update_world():
	Metro.update_zone()
