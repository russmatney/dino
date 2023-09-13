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

	# if color_rect != null:
		# color_rect.size = Vector2.ONE * square_size

		# match type:
		# 	DotHop.dotType.Dot: color_rect.color = Color(1, 1, 1)
		# 	DotHop.dotType.Dotted: color_rect.color = Color(0, 0, 0)
		# 	DotHop.dotType.Goal: color_rect.color = Color(0, 1, 0)

	if anim != null:
		match type:
			DotHop.dotType.Dot: anim.play("dot")
			DotHop.dotType.Dotted: anim.play("dotted")
			DotHop.dotType.Goal: anim.play("goal")

## entry animation ###########################################################

var entry_tween
var entry_t = 0.6
func animate_entry():
	var og_position = position
	position = position - Vector2.ONE * 10
	scale = Vector2.ONE * 0.5
	entry_tween = create_tween()
	entry_tween.tween_property(self, "scale", Vector2.ONE, entry_t)\
		.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	entry_tween.parallel().tween_property(self, "position", og_position, entry_t)\
		.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
