@tool
extends DinoGame

######################################################
# dino game api

var player_scene = preload("res://src/herd/player/Player.tscn")

func manages_scene(sfp):
	return sfp.begins_with("res://src/herd")

func register():
	pass

func update_world():
	pass

######################################################
# level mgmt

var levels = [
	"res://src/herd/levels/LevelOne.tscn",
	"res://src/herd/levels/LevelTwo.tscn"
	]
