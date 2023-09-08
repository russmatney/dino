@tool
extends Node2D
class_name DotHopDot

## config warnings ###########################################################

func _get_configuration_warnings():
	return Util._config_warning(self, {
		expected_nodes=["ObjectLabel", "ColorRect"]
		})

## data #########################################################

enum dotType { Dot, Dotted, Goal}

## vars #########################################################

@export var type: dotType
@export var square_size = 16 :
	set(v):
		square_size = v
		render()

var display_name = "dot"

var label
var color_rect

## ready #########################################################

func _ready():
	Util.set_optional_nodes(self, {
		label="ObjectLabel", color_rect="ColorRect"})

	render()

## render #########################################################

func render():
	if label != null:
		match type:
			dotType.Dot: display_name = "dot"
			dotType.Dotted: display_name = "dotted"
			dotType.Goal: display_name = "goal"

		label.text = "[center]%s[/center]" % display_name
		label.custom_minimum_size = Vector2.ONE * square_size

	if color_rect != null:
		color_rect.size = Vector2.ONE * square_size

		match type:
			dotType.Dot: color_rect.color = Color(1, 0, 0)
			dotType.Dotted: color_rect.color = Color(0, 1, 0)
			dotType.Goal: color_rect.color = Color(0, 0, 1)

## type changes #########################################################

func mark_goal():
	type = dotType.Goal
	render()

func mark_dotted():
	type = dotType.Dotted
	render()

func mark_undotted():
	type = dotType.Dot
	render()
