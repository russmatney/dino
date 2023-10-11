extends Node2D

## ready #########################################################################

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

## setup #########################################################################

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

## signals #########################################################################

func _on_quest_failed(q):
	Hood.notif(str("Quest failed: ", q.label))
	reload_current_level()

var fired_once
func _on_all_quests_complete():
	# TODO animation/scene transition/delay

	if not fired_once:
		fired_once = true
		load_next_level()

## next level #########################################################################

func all_levels_complete():
	Hood.notif("Game complete!")
	Navi.show_win_menu()

var current_level_idx = 0

func load_next_level():
	Debug.pr("snake game loading next level")
	if current_level_idx == null:
		current_level_idx = 0
	else:
		current_level_idx += 1

	if current_level_idx < SnakeData.levels.size():
		var lvl = SnakeData.levels[current_level_idx]
		Quest.current_level_label = lvl["label"]
		Debug.pr("Navi.nav_to: ", lvl["label"])
		Navi.nav_to(lvl["scene"])
	else:
		all_levels_complete()

func reload_current_level():
	Navi.nav_to(SnakeData.levels[current_level_idx]["scene"])
