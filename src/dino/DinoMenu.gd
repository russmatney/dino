@tool
extends CanvasLayer

@onready var games_grid_container = $%GamesGridContainer

var start_game_button = preload("res://src/dino/StartGameButton.tscn")

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


func build_games_grid():
	Util.free_children(games_grid_container)

	var ent = Pandora.get_entity(DinoGameEntityIds.DOTHOP)
	var game_entities = Pandora.get_all_entities(Pandora.get_category(ent._category_id))

	for ge in game_entities:
		var game_button = start_game_button.instantiate()
		game_button.set_game_entity(ge)
		games_grid_container.add_child(game_button)
