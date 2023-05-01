extends Node2D

##########################################################################
# ready

# TODO do we need this reference?
var player

func _ready():
	Quest.quest_failed.connect(_on_quest_failed)
	Quest.all_quests_complete.connect(_on_all_quests_complete)
	Game.player_found.connect(_on_found_player)
	if Game.player:
		_on_found_player(Game.player)

	setup.call_deferred()

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

var fired_once
func _on_all_quests_complete():
	# TODO animation/scene transition/delay

	if not fired_once:
		fired_once = true
		SnakeGame.load_next_level()
