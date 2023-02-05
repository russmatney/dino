extends Node2D

##########################################################################
# ready

var player

func _ready():
	var _x = Quest.connect("quest_failed", self, "_on_quest_failed")
	var _y = Quest.connect("all_quests_complete", self, "_on_all_quests_complete")
	var _z = Hood.connect("found_player", self, "_on_found_player")
	if Hood.player:
		_on_found_player(Hood.player)

	call_deferred("setup")

func _on_found_player(p):
	player = p

##########################################################################
# setup

var grids = []

func find_grids():
	grids = []
	for c in get_children():
		if c.is_in_group("grids"):
			grids.append(c)

func setup():
	find_grids()

	if grids:
		grids[0].add_snake()

##########################################################################
# signals

func _on_quest_failed(q):
	Hood.notif(str("Quest failed: ", q.label))
	SnakeGame.reload_current_level()

func _on_all_quests_complete():
	Hood.notif("All Quests complete")
	# TODO animation/scene transition/delay
	SnakeGame.load_next_level()
