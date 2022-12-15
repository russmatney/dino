tool
extends Node

signal notification


func create_notification(message, ttl = 5):
	emit_signal("notification", {"msg": message, "ttl": ttl})
