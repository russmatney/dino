extends Node2D

## vars ###################################################3

@onready var level_gen: BrickLevelGen = $LevelGen

signal level_complete

## ready ###################################################3

func _ready():
	Debug.pr("Gunner level!")
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

	var closed = Jumbotron.jumbo_notif({
		header="Break the targets!",
		body="Good luck, little one."
		})
	await closed

	Game.respawn_player()

func on_quests_complete():
	Hood.notif("Gunner level complete")
	level_complete.emit()

func on_quest_failed():
	Hood.notif("Gunner quest failed")
	Game.respawn_player()
