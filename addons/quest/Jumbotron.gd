@tool
extends CanvasLayer
class_name Jumbotron

## static ##########################################################################

static var jumbotron_scene = preload("res://addons/quest/Jumbotron.tscn")

static func jumbo_notif(opts):
	var jumbotron = jumbotron_scene.instantiate()
	Navi.add_child(jumbotron)

	var header = opts.get("header")
	var body = opts.get("body", "")
	var key_or_action = opts.get("key")
	key_or_action = opts.get("action", key_or_action)
	var action_label_text = opts.get("action_label_text")
	var on_close = opts.get("on_close")
	var pause = opts.get("pause", true)

	# reset data
	jumbotron.header_text = header
	jumbotron.body_text = body
	jumbotron.action_hint.hide()

	if key_or_action or action_label_text:
		jumbotron.action_hint.display(key_or_action, action_label_text)

	jumbotron.jumbo_closed.connect(func():
		if on_close:
			on_close.call()
		if pause:
			Navi.get_tree().paused = false)

	if pause:
		Navi.get_tree().paused = true

	# maybe pause the game? probably? optionally?
	jumbotron.fade_in()

	return jumbotron.jumbo_closed

## instance ##########################################################################

signal jumbo_closed

@onready var header = $%Header
@onready var body = $%Body
@onready var action_hint = $%ActionHint

@export var header_text: String :
	set(v):
		header_text = v
		if header:
			if len(v) == 0:
				header.text = ""
			else:
				header.text = "[center]%s[/center]" % v

@export var body_text: String :
	set(v):
		body_text = v
		if body:
			if len(v) == 0:
				body.text = ""
			else:
				body.text = "[center]%s[/center]" % v

func _unhandled_input(event):
	if Trolley.is_close(event):
		fade_out()
		DJZ.play(DJZ.S.showjumbotron)

func fade_in():
	$PanelContainer.modulate.a = 0
	set_visible(true)
	var t = create_tween()
	t.tween_property($PanelContainer, "modulate:a", 1, 0.4)

func fade_out():
	var t = create_tween()
	t.tween_property($PanelContainer, "modulate:a", 0, 0.4)
	t.tween_callback(set_visible.bind(false))
	t.tween_callback(func(): jumbo_closed.emit())
