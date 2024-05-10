@tool
extends CanvasLayer

## vars ##################################################################3

@onready var games_grid_container = $%GamesGridContainer

@onready var games_list = $%GamesList

@onready var start_button = $%StartButton
@onready var options_button = $%OptionsButton
@onready var credits_button = $%CreditsButton
@onready var quit_button = $%QuitButton

@onready var credits_scene = preload("res://src/dino/menus/DinoCredits.tscn")

## ready ##################################################################3

func _ready():
	if Engine.is_editor_hint():
		request_ready()

	build_games_grid()

	build_games_list()

	if not Engine.is_editor_hint():
		Music.resume_menu_song()
		set_focus()

		quit_button.pressed.connect(get_tree().quit)
		credits_button.pressed.connect(func(): Navi.nav_to(credits_scene))

		start_button.pressed.connect(func():
			Log.pr("nothing doing, start button not impled"))
		options_button.pressed.connect(func():
			Log.pr("nothing doing, opts button not impled"))

## set_focus ##################################################################3

func set_focus():
	var chs = games_list.get_children()
	if len(chs) > 0:
		if chs[0].has_method("set_focus"):
			chs[0].set_focus()
		elif chs[0].has_method("grab_focus"):
			chs[0].grab_focus()
		else:
			Log.warn("Couldn't set focus!")

## game_modes grid ##################################################################3

func start_mode(mode):
	if mode:
		Dino.launch(mode)
	else:
		Log.err("Cannot start game, no game_entity passed!")

func build_games_grid():
	U.free_children(games_grid_container)

	for m in DinoModeEntity.all_modes():
		var button = EntityButton.newButton(m, start_mode)
		games_grid_container.add_child(button)

## games list ##################################################################3

var games = [
	"Classic Mode (Side-Scroller)",
	"Classic Mode (Top Down)",
	"Vania (Hat Bot/Ghost House/Demo Land)",
	"Dungeon Crawler (Shirt)",
	"Tower",
	"Woods",
	"Mountain",
	"Super Elevator Level",
	"Boss Rush",
	"Harvey/Spike",
	"Arcade",
	]

func build_games_list():
	U.free_children(games_list)

	for g in games:
		var button = Button.new()
		button.text = g
		button.set_theme_type_variation("BlueButton")
		games_list.add_child(button)
