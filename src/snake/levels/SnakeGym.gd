extends Node2D


func _ready():
	var _x = Q.quest_failed.connect(_on_quest_failed)

	setup.call_deferred()

var grids = []

func setup():
	grids = []
	for c in get_children():
		if c.is_in_group("grids"):
			grids.append(c)

	if len(grids) > 0:
		Log.pr("add snake in grid 0")
		grids[0].add_snake()

func _process(_d):
	if len(grids) == 0:
		setup()

func _on_quest_failed(q):
	Log.pr("Quest failed: ", q.label)
