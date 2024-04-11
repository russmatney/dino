@tool
extends PanelContainer
class_name EntityButton

## static #####################################################

static var button_scene = "res://src/dino/ui/EntityButton.tscn"

static func newButton(ent):
	var butt = load(button_scene).instantiate()
	butt.set_entity(ent)
	return butt

## vars #####################################################

var entity

func to_printable():
	return {
		_self=str(self),
		entity=entity,
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
			entity = Pandora.get_entity(DinoGameEntityIds.SHIRT)

	focus_entered.connect(func(): icon.grab_focus())

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
	return entity

func set_mode_entity(g):
	entity = g

func set_game_entity(g):
	entity = g

func set_player_entity(g):
	entity = g

func set_weapon_entity(g):
	entity = g

func set_entity(ent):
	entity = ent
	setup()

## setup #######################################

func setup():
	Log.pr(entity)
	if get_entity():
		if label == null:
			label = get_node("%Label")
		if label != null:
			label.text = "[center]%s[/center]" % str(get_entity().get_display_name())

		if icon == null:
			icon = get_node_or_null("%Icon")
		if icon != null:
			icon.texture_normal = get_entity().get_icon_texture()
	elif Debug.debugging:
		Log.warn("no entity, cannot setup", self)

## focus #######################################

# maybe delete?
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
