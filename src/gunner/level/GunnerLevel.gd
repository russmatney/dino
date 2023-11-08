extends Node2D

## vars ###################################################3

@export var regen_on_ready: bool = false

var level_opts : Dictionary :
	set(opts):
		level_opts = opts
func set_level_opts(opts):
	level_opts = opts

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
	if regen_on_ready and level_gen:
		Debug.pr("GunnerLevel regenerating with opts", level_opts)
		regenerate()
	else:
		setup_level()


## regenerate ###################################################3

func regenerate(opts=null):
	if opts:
		level_opts = opts
	level_gen.generate(level_opts)
	level_gen.nodes_transferred.connect(func(): regeneration_complete.emit())

## setup_level ###################################################3

func setup_level():
	break_the_targets.setup()

	Game.maybe_spawn_player()

## level complete ###############################################

func on_targets_cleared():
	Hood.notif("Gunner level complete")
	level_complete.emit()
