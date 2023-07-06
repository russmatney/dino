@tool
extends PanelContainer

var game: DinoGame

@onready var label = $%GameLabel
@onready var icon = $%Icon

func _ready():
	if Engine.is_editor_hint():
		if not game:
			var g = Game.games[0]
			set_game(g)

	icon.pressed.connect(start_game)
	icon.focus_entered.connect(on_focused)
	icon.focus_exited.connect(on_unfocused)

	setup()

func set_game(g: DinoGame):
	game = g

func setup():
	if game:
		label.text = "[center]%s[/center]" % str(game.name)
		icon.texture_normal = game.icon_texture
	else:
		Debug.warn("no game, cannot setup")

func start_game():
	if game:
		Game.nav_to_game_menu_or_start(game)
	else:
		Debug.err("Cannot start game, no game set!")

func set_focus():
	icon.grab_focus()

func on_focused():
	Util.update_stylebox(self, "panel", func(box): box.border_color = Color.AQUAMARINE)

func on_unfocused():
	Util.update_stylebox(self, "panel", func(box): box.border_color = Color.TRANSPARENT)
