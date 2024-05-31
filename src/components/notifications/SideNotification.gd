extends PanelContainer

## vars ###########################################

var opts

@onready var label: RichTextLabel = $%SideNotifLabel
@onready var texture: TextureRect = $%SideNotifTexture

var clear_tween: Tween
var tween: Tween

var og_pos: Vector2
var x_offset = 300

## signals ###########################################

signal cleared

## _ready ########################################

func _ready():
	modulate.a = 0.0

	minimum_size_changed.connect(func():
		og_pos = position)

## render ########################################

func render(options: Dictionary):
	if not is_inside_tree():
		return

	var is_re_emph = opts != null
	opts = options

	# set label
	var text = opts.get("text")
	if text:
		label.set_text(text)

	# set icon
	var icon = opts.get("icon")
	if icon:
		texture.set_texture(icon)

	if not icon:
		var ent = opts.get("icon_entity")
		if ent:
			texture.set_texture(ent.get_icon_texture())

	# set clear ttl
	if clear_tween:
		clear_tween.kill()
	var ttl = opts.get("ttl", 3.0)
	clear_tween = create_tween()
	if not clear_tween:
		return
	clear_tween.tween_callback(clear).set_delay(ttl)

	if is_re_emph:
		reemphasize()
	else:
		animate_entry()

## entry ########################################

func animate_entry():
	if not is_inside_tree():
		return

	position = og_pos + Vector2.RIGHT * x_offset
	modulate.a = 0.4

	if tween:
		tween.kill()
	tween = create_tween()
	if not tween:
		return
	tween.tween_property(self, "position", og_pos, 0.4)
	tween.parallel().tween_property(self, "modulate:a", 1.0, 0.4)

## exit ########################################

func animate_exit():
	if not is_inside_tree():
		return
	var target_position = og_pos + Vector2.RIGHT * x_offset
	position = og_pos
	if tween:
		tween.kill()
	tween = create_tween()
	if not tween:
		return
	tween.tween_property(self, "position", target_position, 0.4)
	tween.parallel().tween_property(self, "modulate:a", 0.0, 0.4)

## re-emph #############################################################

func reemphasize():
	if not is_inside_tree() or is_queued_for_deletion():
		return

	modulate.a = 1.0
	var t = create_tween()
	if not t:
		return
	t.tween_property(self, "scale", Vector2.ONE*1.2, 0.1)
	t.tween_property(self, "scale", Vector2.ONE, 0.1)

## clear ########################################

func clear():
	opts = null
	clear_tween = null # necessary?
	animate_exit()
	cleared.emit()

## get_id ########################################

func get_id():
	if opts:
		return opts.get("id")

## is_available ########################################

func is_available() -> bool:
	return opts == null
