extends Node2D

## vars ######################################################

@onready var level_gen: BrickLevelGen = $LevelGen

signal level_complete

## ready ######################################################

func _ready():
	Debug.pr("Shirt level!")
	level_gen.nodes_transferred.connect(setup_level)

## regenerate ###################################################3

func regenerate(opts=null):
	level_gen.generate(opts)

## setup_level ###################################################3

func setup_level():
	Util._connect(Q.all_quests_complete, on_quests_complete, ConnectFlags.CONNECT_ONE_SHOT)
	Util._connect(Q.quest_failed, on_quest_failed, ConnectFlags.CONNECT_ONE_SHOT)
	Q.setup_quests()
	Game.remove_player()

	await Q.jumbo_notif({
		header="Welcome to Shirt!",
		body="Toss that boomerang, crawl that dungeon!"
		})

	Game.respawn_player()

func on_quests_complete():
	Hood.notif("Shirt level complete")
	level_complete.emit()

func on_quest_failed():
	Hood.notif("Shirt quest failed")
	Game.respawn_player()
