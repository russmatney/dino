@tool
extends Node2D
class_name DotHopPlayer

## config warnings ###########################################################

func _get_configuration_warnings():
	return U._config_warning(self, {
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
var current_coord: Vector2

## enter tree #########################################################

func _enter_tree():
	add_to_group("player", true)

## ready #########################################################

func _ready():
	if z_index == 0:
		z_index = 5

	U.set_optional_nodes(self, {label="ObjectLabel", color_rect="ColorRect"})

	render()

## render #########################################################

func render():
	if label != null:
		label.text = "[center]%s[/center]" % display_name
		label.custom_minimum_size = Vector2.ONE * square_size

	if color_rect != null:
		color_rect.size = Vector2.ONE * square_size
		color_rect.color = Color(0, 0, 1)

## set_initial_coord #########################################################

func set_initial_coord(coord):
	current_coord = coord
	position = coord * square_size

## move #########################################################

func move_to_coord(coord):
	current_coord = coord
	position = coord * square_size

## undo #########################################################

func undo_to_coord(coord):
	current_coord = coord
	position = coord * square_size

# undo-step for other player, but we're staying in the same coord
func undo_to_same_coord():
	pass

## move attempts #########################################################

func move_attempt_stuck(_move_dir:Vector2):
	pass

func move_attempt_away_from_edge(_move_dir:Vector2):
	pass

func move_attempt_only_nulls(_move_dir:Vector2):
	pass
