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
		Debug.pr("game entities loaded, skipping grid rebuild", game_entities)
		return
	var new_game_entities = Game.all_game_entities()

	attempts += 1
	if len(new_game_entities) > 0:
		Util.free_children(games_grid_container)

		game_entities = new_game_entities

		for ge in game_entities:
			var game_button = start_game_button.instantiate()
			game_button.set_game_entity(ge)
			games_grid_container.add_child(game_button)
	elif attempts > 3:
		Debug.err("Reached max attempts loading game entries")
	else:
		await get_tree().create_timer(0.2).timeout
		build_games_grid()
