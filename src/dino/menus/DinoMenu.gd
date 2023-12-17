@tool
extends CanvasLayer

@onready var games_grid_container = $%GamesGridContainer

var game_mode_button = preload("res://src/dino/ui/GameModeButton.tscn")

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


func start_mode(mode):
	if mode:
		Game.launch(mode)
	else:
		Log.err("Cannot start game, no game_entity passed!")

var modes = []
func build_games_grid():
	modes = DinoModeEntity.all_modes()
	U.free_children(games_grid_container)

	for m in modes:
		var button = game_mode_button.instantiate()
		button.set_mode_entity(m)
		button.icon_pressed.connect(func(): start_mode(m))
		games_grid_container.add_child(button)
