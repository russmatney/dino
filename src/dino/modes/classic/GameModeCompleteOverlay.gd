extends CanvasLayer

@onready var screen_blur = $%ScreenBlur

@onready var main_menu_button = $%MainMenu
@onready var credits_button = $%Credits

@onready var credits_scene = preload("res://src/dino/menus/DinoCredits.tscn")

@onready var game_complete_header = $%GameCompleteHeader
@onready var game_complete_subhead = $%GameCompleteSubhead

## ready #######################################################

func _ready():
	main_menu_button.pressed.connect(Navi.nav_to_main_menu)
	credits_button.pressed.connect(func(): Navi.nav_to(credits_scene))

	game_complete_header.modulate.a = 0.0
	game_complete_subhead.modulate.a = 0.0

	(func():
		await get_tree().create_timer(1.5).timeout
		set_focus()).call_deferred()

## set focus #######################################################

func set_focus():
	main_menu_button.grab_focus()

## show/hide #######################################################

func anim_show(opts={}):
	# could pull from current game_mode?
	game_complete_header.text = "[center]%s[/center]" % opts.get("header", "Game Complete!")
	game_complete_subhead.text = "[center]%s[/center]" % opts.get("subhead", "You win!")

	var t = opts.get("t", 2.0)
	screen_blur.anim_blur({duration=t, target=2.6})
	screen_blur.anim_gray({duration=t, target=0.8})

	Anim.fade_in(game_complete_header, t)
	Anim.fade_in(game_complete_subhead, t)
