extends Node2D


func _ready():
	var _x = Quest.connect("quest_failed", self, "_on_quest_failed")


func _on_quest_failed(q):
	print("Quest failed: ", q.label)
