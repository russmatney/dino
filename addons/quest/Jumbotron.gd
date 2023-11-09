@tool
extends CanvasLayer

# TODO rip setup out of Quest and into some static funcs

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
		Q.jumbo_closed.emit()
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
