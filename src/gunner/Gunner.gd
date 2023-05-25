extends DinoGame

func _ready():
	pause_menu_scene = load("res://src/gunner/menus/GunnerPauseMenu.tscn")

## register #########################################################################

func register():
	register_menus()

func manages_scene(scene):
	return scene.scene_file_path.begins_with("res://src/gunner")

## start game #########################################################################

var default_game_path = "res://src/gunner/player/PlayerGym.tscn"

func start():
	Respawner.reset_respawns()

	if Navi.current_scene.scene_file_path.match("*gunner*"):
		# re-nav to same path, kind of weird
		Navi.nav_to(Navi.current_scene.scene_file_path)
	else:
		Navi.nav_to(default_game_path)

## player #########################################################################

var player_scene = preload("res://src/gunner/player/Player.tscn")
