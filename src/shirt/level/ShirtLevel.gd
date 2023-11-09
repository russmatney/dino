extends Node2D

## vars ######################################################

var level_gen: BrickLevelGen

signal regeneration_complete
signal level_complete

## ready ######################################################

func _ready():
	Debug.pr("Shirt level!")

	for ch in get_children():
		if ch is BrickLevelGen:
			level_gen = ch

	level_gen.nodes_transferred.connect(func():
		regeneration_complete.emit()
		setup_level())
	setup_level()

## regenerate ###################################################3

func regenerate(opts=null):
	level_gen.generate(opts)

## setup_level ###################################################3

func setup_level():
	Q.all_quests_complete.connect(on_quests_complete)
	Q.quest_failed.connect(on_quest_failed)
	Q.setup_quests()

	Game.maybe_spawn_player()

func on_quests_complete():
	Hood.notif("Shirt level complete")
	level_complete.emit()

func on_quest_failed():
	Hood.notif("Shirt quest failed")
	Game.respawn_player()
