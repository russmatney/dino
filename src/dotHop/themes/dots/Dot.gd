@tool
extends DotHopDot

## config warnings ###########################################################

func _get_configuration_warnings():
	return super._get_configuration_warnings()

## ready ###########################################################

func _ready():
	super._ready()

## render ###########################################################

func render():
	super.render()

	if color_rect != null:
		color_rect.size = Vector2.ONE * square_size

		match type:
			DotHop.dotType.Dot: color_rect.color = Color(1, 1, 1)
			DotHop.dotType.Dotted: color_rect.color = Color(0, 0, 0)
			DotHop.dotType.Goal: color_rect.color = Color(0, 1, 0)
