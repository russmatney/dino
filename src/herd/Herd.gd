@tool
extends DinoGame

var player_scene = preload("res://src/herd/player/Player.tscn")

func manages_scene(sfp):
	return sfp.begins_with("res://src/herd")

func register():
	pass

func update_world():
	pass
