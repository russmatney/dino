@tool
extends PanelContainer

@export var player_entity: DinoPlayerEntity
@export var is_selected: bool :
	set(v):
		if v in [true, false]:
			is_selected = v
			update_selected()

@onready var label = $%PlayerLabel
@onready var icon = $%Icon

signal icon_pressed

## ready #######################################

func _ready():
	if Engine.is_editor_hint():
		if not player_entity:
			player_entity = Pandora.get_entity(DinoPlayerEntityIds.HOODIEPLAYER)

	icon.pressed.connect(func(): icon_pressed.emit())
	icon.focus_entered.connect(on_focused)
	icon.focus_exited.connect(on_unfocused)

	setup()

func set_player_entity(g: DinoPlayerEntity):
	player_entity = g

## setup #######################################

func setup():
	if player_entity:
		label.text = "[center]%s[/center]" % str(player_entity.get_display_name())
		icon.texture_normal = player_entity.get_icon_texture()
	else:
		Log.warn("no player_entity, cannot setup")

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
