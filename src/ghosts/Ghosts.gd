tool
extends Node

signal notification


func create_notification(message, ttl = 5):
	emit_signal("notification", {"msg": message, "ttl": ttl})



func _ready():
	if OS.has_feature("ghosts"):
		Navi.set_main_menu("res://src/ghosts/GhostsMenu.tscn")
