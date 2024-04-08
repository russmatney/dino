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
			if not is_node_ready() and not Engine.is_editor_hint():
				return
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

	icon.focus_entered.connect(_on_focus_entered)
	icon.focus_exited.connect(_on_focus_exited)
	icon.mouse_entered.connect(_on_mouse_entered)
	icon.mouse_exited.connect(_on_mouse_exited)

	setup()

func _on_focus_entered():
	U.update_stylebox(self, "panel", func(box): box.border_color = Color.AQUAMARINE)

func _on_focus_exited():
	U.update_stylebox(self, "panel", func(box): box.border_color = Color.TRANSPARENT)

func _on_mouse_entered():
	U.update_stylebox(self, "panel", func(box): box.border_color = Color.PERU)

func _on_mouse_exited():
	U.update_stylebox(self, "panel", func(box): box.border_color = Color.TRANSPARENT)

## get/set_entity #######################################

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
