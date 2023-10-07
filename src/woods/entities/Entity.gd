@tool
extends Node2D
class_name WoodsEntity

## enums #########################################################

enum t {
	Leaf
	}

## vars #########################################################

@export var type: t = t.Leaf
@export var display_name: String

var label: Label
var color_rect: ColorRect

## ready #########################################################

func _ready():
	Debug.pr("Woods Entity", self)

	# TODO helper to read/do this via data
	label = $%DebugLabel
	color_rect = $%ColorRect

## debug and render #########################################################

@export var square_size = 16 :
	set(v):
		square_size = v
		render()

func render():
	if label != null:
		label.text = "[center]%s[/center]" % display_name
		label.custom_minimum_size = Vector2.ONE * square_size

	if color_rect != null:
		color_rect.size = Vector2.ONE * square_size
		color_rect.color = Color(1, 1, 0)

## set_initial_coord #########################################################

var current_coord: Vector2
func set_initial_coord(coord):
	current_coord = coord
	position = coord * square_size

func current_position():
	return current_coord * square_size
