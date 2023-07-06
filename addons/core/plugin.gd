@tool
extends EditorPlugin

var reload_scene_btn = Button.new()
var reload_games_btn = Button.new()
var container = 0
var editor_interface


func _enter_tree():
	add_autoload_singleton("Util", "res://addons/core/Util.gd")
	add_autoload_singleton("Debug", "res://addons/core/Debug.gd")

	Debug.prn("<Core>")

	editor_interface = get_editor_interface()

	reload_scene_btn.pressed.connect(reload_scene)
	reload_scene_btn.text = "Reload Scene"
	add_control_to_container(container, reload_scene_btn)

	reload_games_btn.pressed.connect(reload_games)
	reload_games_btn.text = "Reload Games"
	add_control_to_container(container, reload_games_btn)


func _exit_tree():
	Debug.prn("</Core>")
	remove_autoload_singleton("Util")
	remove_autoload_singleton("Debug")


func reload_scene():
	Debug.pr("-------------------------------------------------")
	Debug.pr("[ReloadScene] ", Time.get_time_string_from_system())
	var edited_scene = editor_interface.get_edited_scene_root()
	Debug.pr("edited scene", edited_scene, ".scene_file_path", edited_scene.scene_file_path)
	editor_interface.reload_scene_from_path(edited_scene.scene_file_path)
	Debug.pr("-------------------------------------------------")


## Unfortunately we can't access the games in Game.gd here, b/c of plugin load order issues
var game_defs = [
	["DemoLand", "res://src/demoland/DemoLand.gd"],
	["DungeonCrawler", "res://src/dungeonCrawler/DungeonCrawler.gd"],
	["Ghosts", "res://src/ghosts/Ghosts.gd"],
	["Gunner", "res://src/gunner/Gunner.gd"],
	["Harvey", "res://src/harvey/Harvey.gd"],
	["HatBot", "res://src/hatbot/HatBot.gd"],
	["Herd", "res://src/herd/Herd.gd"],
	["Mountain", "res://src/mountain/Mountain.gd"],
	["Shirt", "res://src/shirt/Shirt.gd"],
	["Snake", "res://src/snake/SnakeGame.gd"],
	["SuperElevatorLevel", "res://src/superElevatorLevel/SuperElevatorLevel.gd"],
	["Tower", "res://src/tower/Tower.gd"],
	["Game", "res://src/dino/Game.gd"],
	]

func reload_games():
	Debug.pr("-------------------------------------------------")
	Debug.pr("[ReloadGames] ", Time.get_time_string_from_system())

	for tup in game_defs:
		remove_autoload_singleton(tup[0])

	for tup in game_defs:
		add_autoload_singleton(tup[0], tup[1])

	Debug.pr("-------------------------------------------------")
