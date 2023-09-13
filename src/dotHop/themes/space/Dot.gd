@tool
extends DotHopDot

@onready var anim = $AnimatedSprite2D

## config warnings ###########################################################

func _get_configuration_warnings():
	return super._get_configuration_warnings()

## ready ###########################################################

func _ready():
	super._ready()
	animate_entry()

## render ###########################################################

func render():
	super.render()

	if anim != null:
		match type:
			DotHop.dotType.Dot: anim.play("spin")
			DotHop.dotType.Dotted:
				await get_tree().create_timer(0.4).timeout
				anim.play("floating")
			DotHop.dotType.Goal: anim.play("rubble")

## entry animation ###########################################################

var entry_tween
var entry_t = 0.3
func animate_entry():
	var og_position = position
	position = position - Vector2.ONE * 10
	scale = Vector2.ONE * 0.5
	entry_tween = create_tween()
	entry_tween.tween_property(self, "scale", Vector2.ONE, entry_t)\
		.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	entry_tween.parallel().tween_property(self, "position", og_position, entry_t)\
		.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)

func animate_exit(t):
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2.ONE * 0.5, t)\
		.set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	tween.parallel().tween_property(self, "position", position - Vector2.ONE * 10, t)\
		.set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	tween.parallel().tween_property(self, "modulate:a", 0.0, t)\
		.set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
