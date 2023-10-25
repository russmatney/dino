@tool
extends PanelContainer

var game_entity: DinoGameEntity

@onready var label = $%GameLabel
@onready var icon = $%Icon

func _ready():
	if Engine.is_editor_hint():
		if not game_entity:
			game_entity = Pandora.get_entity(DinoGameEntityIds.SHIRT)

	icon.pressed.connect(start_game)
	icon.focus_entered.connect(on_focused)
	icon.focus_exited.connect(on_unfocused)

	setup()

func set_game_entity(g: DinoGameEntity):
	game_entity = g

func setup():
	if game_entity:
		label.text = "[center]%s[/center]" % str(game_entity.get_display_name())
		icon.texture_normal = game_entity.get_icon_texture()
	else:
		Debug.warn("no game_entity, cannot setup")

func start_game():
	if game_entity:
		Game.launch(game_entity)
	else:
		Debug.err("Cannot start game, no game_entity set!")

func set_focus():
	icon.grab_focus()

func on_focused():
	Util.update_stylebox(self, "panel", func(box): box.border_color = Color.AQUAMARINE)

func on_unfocused():
	Util.update_stylebox(self, "panel", func(box): box.border_color = Color.TRANSPARENT)
