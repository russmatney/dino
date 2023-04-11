extends Node2D


func _ready():
	var _x = Quest.quest_failed.connect(_on_quest_failed)

	setup.call_deferred()

var grids = []

func setup():
	grids = []
	for c in get_children():
		if c.is_in_group("grids"):
			grids.append(c)

	if grids:
		Debug.pr("add snake in grid 0")
		grids[0].add_snake()

func _process(_d):
	if not grids:
		setup()

func _on_quest_failed(q):
	Debug.pr("Quest failed: ", q.label)
