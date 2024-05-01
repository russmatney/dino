@tool
extends CanvasLayer

@onready var games_grid_container = $%GamesGridContainer

func _ready():
	if Engine.is_editor_hint():
		request_ready()

	build_games_grid()

	Music.resume_menu_song()
	set_focus()

func set_focus():
	var chs = games_grid_container.get_children()
	if len(chs) > 0:
		chs[0].set_focus()


func start_mode(mode):
	if mode:
		Dino.launch(mode)
	else:
		Log.err("Cannot start game, no game_entity passed!")

var modes = []
func build_games_grid():
	modes = DinoModeEntity.all_modes()
	U.free_children(games_grid_container)

	for m in modes:
		var button = EntityButton.newButton(m, start_mode)
		games_grid_container.add_child(button)
