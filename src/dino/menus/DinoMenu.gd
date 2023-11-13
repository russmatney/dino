@tool
extends CanvasLayer

@onready var games_grid_container = $%GamesGridContainer

var game_mode_button = preload("res://src/dino/menus/GameModeButton.tscn")

func _ready():
	if Engine.is_editor_hint():
		request_ready()

	build_games_grid()

	DJ.resume_menu_song()
	set_focus()

func set_focus():
	var chs = games_grid_container.get_children()
	if len(chs) > 0:
		chs[0].set_focus()


func start_mode(game_mode):
	if game_mode:
		Game.launch(game_mode)
	else:
		Log.err("Cannot start game, no game_entity passed!")

var game_modes = []
func build_games_grid():
	game_modes = Game.all_game_modes()
	U.free_children(games_grid_container)

	for gm in game_modes:
		var button = game_mode_button.instantiate()
		button.set_game_entity(gm)
		button.icon_pressed.connect(func(): start_mode(gm))
		games_grid_container.add_child(button)
