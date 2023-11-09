extends Node2D

## vars ######################################################

@onready var level_gen: BrickLevelGen = $LevelGen

signal level_complete

## ready ######################################################

func _ready():
	Debug.pr("Shirt level!")
	level_gen.nodes_transferred.connect(setup_level)

	if not Game.is_managed:
		setup_level()

## regenerate ###################################################3

func regenerate(opts=null):
	level_gen.generate(opts)

## setup_level ###################################################3

func setup_level():
	Util._connect(Q.all_quests_complete, on_quests_complete)
	Util._connect(Q.quest_failed, on_quest_failed)
	Q.setup_quests()

	Game.respawn_player()

func on_quests_complete():
	Hood.notif("Shirt level complete")
	level_complete.emit()

func on_quest_failed():
	Hood.notif("Shirt quest failed")
	Game.respawn_player()
