extends Node2D

## vars ###################################################3

signal regeneration_complete
signal level_complete

var level_gen: BrickLevelGen

# TODO could add programatically, could handle multiple quests, or otherwise integrate with Quest
@onready var break_the_targets = $BreakTheTargets

## ready ###################################################3

func _ready():
	regeneration_complete.connect(setup_level)
	break_the_targets.targets_cleared.connect(func():
		on_targets_cleared())

	level_gen = get_node_or_null("LevelGen")
	setup_level()


## regenerate ###################################################3

func regenerate(opts=null):
	level_gen.generate(opts)
	level_gen.nodes_transferred.connect(func(): regeneration_complete.emit())

## setup_level ###################################################3

func setup_level():
	break_the_targets.setup()

	Game.maybe_spawn_player()

## level complete ###############################################

func on_targets_cleared():
	Hood.notif("TowerJet level complete")
	level_complete.emit()
