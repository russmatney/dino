@tool
extends Node2D
class_name DotHopPlayer

## config warnings ###########################################################

func _get_configuration_warnings():
	return Util._config_warning(self, {
		expected_nodes=["ObjectLabel", "ColorRect"]
		})

## vars #########################################################

@export var square_size = 16 :
	set(v):
		square_size = v
		render()

var display_name = "Player"

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
		label.text = "[center]%s[/center]" % display_name
		label.custom_minimum_size = Vector2.ONE * square_size

	if color_rect != null:
		color_rect.size = Vector2.ONE * square_size
		color_rect.color = Color(0, 0, 1)
