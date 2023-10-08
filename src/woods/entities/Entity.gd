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
var collect_box: Area2D

## ready #########################################################

func _ready():
	Util.set_optional_nodes(self, {
		label="DebugLabel",
		color_rect="ColorRect",
		collect_box="CollectBox",
		})

	if collect_box != null:
		collect_box.body_entered.connect(on_collect_box_entered)

func on_collect_box_entered(_body):
	Debug.warn("on_collect_box_entered not impled")

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
