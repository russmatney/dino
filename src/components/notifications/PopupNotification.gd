extends CanvasLayer

## vars #############################################################

@onready var popup: PanelContainer = $%Popup
@onready var header_label: RichTextLabel = $%HeaderLabel
@onready var body_label: RichTextLabel = $%BodyLabel
@onready var header_icon: TextureRect = $%HeaderIcon
@onready var screenBlur = $%ScreenBlur

var clear_tween
var entry_tween
var exit_tween
var queued = []

var current
var anim_duration = 0.4
var default_ttl = 2.0

## ready #############################################################

func _ready():
	set_visible(false)
	popup.modulate.a = 0.0
	popup.minimum_size_changed.connect(func():
		popup.set_pivot_offset(popup.size / 2))

	Dino.notification.connect(func(notif):
		if notif.get("type") == "popup":
			render(notif))

## input ########################################

# useful for local testing
# func _unhandled_input(event):
# 	if Trolls.is_action(event):
# 		Dino.notif({
# 			type="popup",
# 			header_text="ACTION Powerup Acquired",
# 			body_text="Act around???",
# 			})
# 	if Trolls.is_jump(event):
# 		Dino.notif({
# 			type="popup",
# 			header_text="JUMP Powerup Acquired",
# 			body_text="Time to JUMP around",
# 			})

## render #############################################################

func render(opts):
	if current:
		queued.append(opts)
		return

	current = opts

	var header_text = opts.get("header_text")
	var body_text = opts.get("body_text")
	var icon = opts.get("icon")

	if header_text:
		header_label.set_text("[center]%s[/center]" % header_text)
	if body_text:
		body_label.set_text("[center]%s[/center]" % body_text)
	if icon:
		header_icon.set_texture(icon)

	set_visible(true)

	get_tree().paused = true

	animate_entry(opts)

## entry #############################################################

func animate_entry(opts):
	screenBlur.fade_in({duration=anim_duration})

	popup.scale = Vector2.ONE*0.8
	popup.modulate.a = 0.0
	entry_tween = create_tween()
	if not entry_tween:
		return
	entry_tween.tween_property(popup, "modulate:a", 1.0, anim_duration)
	entry_tween.parallel().tween_property(popup, "scale", Vector2.ONE*1.0, anim_duration)

	entry_tween.tween_callback(func():
		var ttl = opts.get("ttl", default_ttl)
		clear_tween = create_tween()
		if not clear_tween:
			return
		clear_tween.tween_callback(animate_exit).set_delay(ttl))

## exit #############################################################

func animate_exit():
	screenBlur.fade_out({duration=anim_duration})

	exit_tween = create_tween()
	if not exit_tween:
		return
	exit_tween.tween_property(popup, "modulate:a", 0.0, anim_duration)
	exit_tween.parallel().tween_property(popup, "scale", Vector2.ONE*0.8, anim_duration)
	exit_tween.tween_callback(clear)

## next #############################################################

func clear():
	current = null

	if not queued.is_empty():
		var next = queued[0]
		queued.erase(next)
		render(next)
	else:
		set_visible(false)
		get_tree().paused = false
