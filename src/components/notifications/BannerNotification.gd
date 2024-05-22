extends CanvasLayer

## vars #############################################################

@onready var label = $%BannerLabel

var clear_tween
var entry_tween
var exit_tween
var queued = []

var current
var anim_duration = 0.4
var default_ttl = 2.0

## ready #############################################################

func _ready():
	label.modulate.a = 0.0

	label.minimum_size_changed.connect(func():
		label.set_pivot_offset(label.size / 2))

	Dino.notification.connect(func(notif):
		if notif.get("type") == "banner":
			render(notif))

## input ########################################

# useful for local testing
# func _unhandled_input(event):
# 	if Trolls.is_action(event):
# 		Dino.notif({
# 			type="banner",
# 			text="Save Room",
# 			id="save-room"
# 			})

# 	if Trolls.is_jump(event):
# 		Dino.notif({
# 			type="banner",
# 			text="Quest Complete",
# 			})

## render #############################################################

func render(opts):
	var id = opts.get("id")
	var is_update = current and current.get("id") == id

	if not is_update and current:
		queued.append(opts)
		return

	current = opts

	var text = opts.get("text")

	if text:
		label.set_text("[center]%s[/center]" % text)

	if is_update:
		if clear_tween:
			clear_tween.kill()
		if exit_tween:
			exit_tween.kill()

	animate_entry(opts)

## entry #############################################################

func animate_entry(opts):
	if not is_inside_tree():
		return
	label.scale = Vector2.ONE*0.8
	label.modulate.a = 0.0
	entry_tween = create_tween()
	if not entry_tween:
		return
	entry_tween.tween_property(label, "modulate:a", 1.0, anim_duration)
	entry_tween.parallel().tween_property(label, "scale", Vector2.ONE*1.0, anim_duration)

	entry_tween.tween_callback(func():
		var ttl = opts.get("ttl", default_ttl)
		if not is_inside_tree():
			return
		clear_tween = create_tween()
		if not clear_tween:
			return
		clear_tween.tween_callback(animate_exit).set_delay(ttl))

## exit #############################################################

func animate_exit():
	if not is_inside_tree():
		return
	exit_tween = create_tween()
	if not exit_tween:
		return
	exit_tween.tween_property(label, "modulate:a", 0.0, anim_duration)
	exit_tween.parallel().tween_property(label, "scale", Vector2.ONE*0.8, anim_duration)
	exit_tween.tween_callback(queue_next)

## next #############################################################

func queue_next():
	current = null

	if not queued.is_empty():
		var next = queued[0]
		queued.erase(next)
		render(next)
