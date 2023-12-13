@tool
extends PanelContainer

var game_entity: DinoGameEntity
@export var is_selected: bool :
	set(v):
		if v in [true, false]:
			is_selected = v
			update_selected()

@onready var label = $%GameLabel
@onready var icon = $%Icon

signal icon_pressed

## ready #######################################

func _ready():
	if Engine.is_editor_hint():
		if not game_entity:
			game_entity = Pandora.get_entity(DinoGameEntityIds.SHIRT)

	icon.pressed.connect(func(): icon_pressed.emit())
	icon.focus_entered.connect(on_focused)
	icon.focus_exited.connect(on_unfocused)

	setup()

func set_game_entity(g: DinoGameEntity):
	game_entity = g

## setup #######################################

func setup():
	if game_entity:
		label.text = "[center]%s[/center]" % str(game_entity.get_display_name())
		icon.texture_normal = game_entity.get_icon_texture()
	else:
		Log.warn("no game_entity, cannot setup")

## focus #######################################

func set_focus():
	icon.grab_focus()

func on_focused():
	U.update_stylebox(self, "panel", func(box): box.border_color = Color.AQUAMARINE)

func on_unfocused():
	U.update_stylebox(self, "panel", func(box): box.border_color = Color.TRANSPARENT)

## selected #######################################

func update_selected():
	if is_selected in [true, false]:
		if is_selected:
			fade_full()
		else:
			fade_half()

func fade_full():
	var t = create_tween()
	t.tween_property(self, "modulate:a", 1.0, 0.2)

func fade_half():
	var t = create_tween()
	t.tween_property(self, "modulate:a", 0.5, 0.2)
