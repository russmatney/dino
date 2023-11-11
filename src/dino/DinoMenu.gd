@tool
extends CanvasLayer

@onready var games_grid_container = $%GamesGridContainer

var start_game_button = preload("res://src/dino/StartGameButton.tscn")


func _ready():
	if Engine.is_editor_hint():
		request_ready()

	attempts = 0
	build_games_grid()

	DJ.resume_menu_song()
	set_focus()

func set_focus():
	var chs = games_grid_container.get_children()
	if len(chs) > 0:
		chs[0].set_focus()

var game_entities = []
var attempts = 0
func build_games_grid():
	if len(game_entities) > 0:
		return
	var new_game_entities = Game.all_game_entities()

	attempts += 1
	if len(new_game_entities) > 0:
		U.free_children(games_grid_container)

		game_entities = new_game_entities
		game_entities.sort_custom(func(a, b):
			if a.is_game_mode():
				return a
			elif b.is_game_mode():
				return b
			return a)

		for ge in game_entities:
			var game_button = start_game_button.instantiate()
			if ge.is_game_mode():
				Log.pr("creating start game button for game-mode", ge.get_display_name())
				# TODO extend game_button to support game modes, or create a game-mode button
			game_button.set_game_entity(ge)
			games_grid_container.add_child(game_button)
	elif attempts > 3:
		Log.err("Reached max attempts loading game entries")
	else:
		await get_tree().create_timer(0.2).timeout
		build_games_grid()
