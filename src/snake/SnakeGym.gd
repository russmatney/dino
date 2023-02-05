extends Node2D


func _ready():
	var _x = Quest.connect("quest_failed", self, "_on_quest_failed")

	call_deferred("setup")

var grids = []

func setup():
	grids = []
	for c in get_children():
		if c.is_in_group("grids"):
			grids.append(c)

	if grids:
		print("add snake in grid 0")
		grids[0].add_snake()

func _process(_d):
	if not grids:
		setup()

func _on_quest_failed(q):
	print("Quest failed: ", q.label)
