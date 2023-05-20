@tool
extends Node2D

@onready var map = $%MetroMap
@onready var cam = $Camera2D

func _ready():
	map.new_merged_rect.connect(on_new_merged_rect)
	map.room_has_player.connect(on_room_has_player)


func on_new_merged_rect(merged):
	update_camera_limits(merged)

func on_room_has_player(_room, rect):
	cam.set_position(rect.get_center())

var limit_offset = 15

@onready var viewport_dim = map.custom_minimum_size.x
func update_camera_limits(merged: Rect2):
	cam.set_limit(SIDE_LEFT, merged.position.x - limit_offset)
	cam.set_limit(SIDE_RIGHT, max(viewport_dim, merged.size.x / 2.0 + merged.position.x - limit_offset * 2))
	cam.set_limit(SIDE_TOP, merged.position.y - limit_offset)
	cam.set_limit(SIDE_BOTTOM, max(viewport_dim, merged.size.y / 2.0 + merged.position.y - limit_offset * 2))
