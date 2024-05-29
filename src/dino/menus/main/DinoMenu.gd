@tool
extends CanvasLayer

## vars ##################################################################3

@onready var games_list = $%GamesList

@onready var options_button = $%OptionsButton
@onready var credits_button = $%CreditsButton
@onready var quit_button = $%QuitButton

@onready var credits_scene = preload("res://src/dino/menus/credits/Credits.tscn")
@onready var options_scene = preload("res://src/dino/menus/options/OptionsMenu.tscn")

## ready ##################################################################3

func _ready():
	if Engine.is_editor_hint():
		request_ready()

	build_games_list()

	if not Engine.is_editor_hint():
		Music.resume_menu_song()
		set_focus.call_deferred()

		quit_button.pressed.connect(get_tree().quit)
		credits_button.pressed.connect(func(): Navi.nav_to(credits_scene))
		options_button.pressed.connect(func(): Navi.nav_to(options_scene))

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

## games list ##################################################################3

func build_games_list():
	U.free_children(games_list)

	for m in DinoModeEntity.all_enabled_modes():
		var button = Button.new()
		button.text = m.get_display_name()
		button.set_theme_type_variation("BlueButton")
		games_list.add_child(button)

		button.pressed.connect(Dino.start_game_mode.bind(m))
