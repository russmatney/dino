@tool
extends PanelContainer

var game_entity: DinoGameEntity
var mode_entity: DinoModeEntity
var player_entity: DinoPlayerEntity
var weapon_entity: DinoWeaponEntity

func to_printable():
	return {
		_self=str(self),
		game_entity=game_entity,
		mode_entity=mode_entity,
		player_entity=player_entity,
		weapon_entity=weapon_entity,
	}

@export var is_selected: bool :
	set(v):
		if v in [true, false]:
			is_selected = v
			update_selected()

@onready var label = $%Label
@onready var icon = $%Icon

signal icon_pressed

## ready #######################################

func _ready():
	if Engine.is_editor_hint():
		if not get_entity():
			game_entity = Pandora.get_entity(DinoGameEntityIds.SHIRT)

	icon.pressed.connect(func(): icon_pressed.emit())
	icon.focus_entered.connect(on_focused)
	icon.focus_exited.connect(on_unfocused)

	setup()

func get_entity():
	if mode_entity:
		return mode_entity
	if game_entity:
		return game_entity
	if player_entity:
		return player_entity
	if weapon_entity:
		return weapon_entity

func set_mode_entity(g: DinoModeEntity):
	mode_entity = g

func set_game_entity(g: DinoGameEntity):
	game_entity = g

func set_player_entity(g: DinoPlayerEntity):
	player_entity = g

func set_weapon_entity(g: DinoWeaponEntity):
	weapon_entity = g

## setup #######################################

func setup():
	if get_entity():
		label.text = "[center]%s[/center]" % str(get_entity().get_display_name())
		icon.texture_normal = get_entity().get_icon_texture()
	elif Debug.debugging:
		Log.warn("no entity, cannot setup", self)

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
