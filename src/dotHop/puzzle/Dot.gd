@tool
extends Node2D
class_name DotHopDot

## config warnings ###########################################################

func _get_configuration_warnings():
	return U._config_warning(self, {
		expected_nodes=["ObjectLabel", "ColorRect"]
		})

## vars #########################################################

@export var type: DHData.dotType
@export var square_size = 16 :
	set(v):
		square_size = v
		render()

var display_name = "dot"

var label
var color_rect

## ready #########################################################

func _ready():
	U.set_optional_nodes(self, {
		label="ObjectLabel", color_rect="ColorRect"})

	render()

## set_initial_coord #########################################################

var current_coord: Vector2
func set_initial_coord(coord):
	current_coord = coord
	position = coord * square_size

func current_position():
	return current_coord * square_size

## render #########################################################

func render():
	if label != null:
		match type:
			DHData.dotType.Dot: display_name = "dot"
			DHData.dotType.Dotted: display_name = "dotted"
			DHData.dotType.Goal: display_name = "goal"

		label.text = "[center]%s[/center]" % display_name
		label.custom_minimum_size = Vector2.ONE * square_size

	if color_rect != null:
		color_rect.size = Vector2.ONE * square_size

		match type:
			DHData.dotType.Dot: color_rect.color = Color(1, 1, 0)
			DHData.dotType.Dotted: color_rect.color = Color(0, 1, 1)
			DHData.dotType.Goal: color_rect.color = Color(1, 0, 1)

## type changes #########################################################

func mark_goal():
	type = DHData.dotType.Goal
	render()

func mark_dotted():
	type = DHData.dotType.Dotted
	render()

func mark_undotted():
	type = DHData.dotType.Dot
	render()
