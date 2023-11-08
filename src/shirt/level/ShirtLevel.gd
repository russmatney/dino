extends Node2D

## vars ######################################################

var level_gen: BrickLevelGen

signal regeneration_complete
signal level_complete

## ready ######################################################

func _ready():
	Debug.pr("Shirt level!")
	Game.maybe_spawn_player()

	for ch in get_children():
		if ch is BrickLevelGen:
			level_gen = ch

	regeneration_complete.connect(setup_level)
	setup_level()

## regenerate ###################################################3

func regenerate(opts=null):
	level_gen.generate(opts)
	level_gen.nodes_transferred.connect(func(): regeneration_complete.emit())

## setup_level ###################################################3

var gems = []
var enemies = []

func setup_level():
	# collect/connect to gems and enemies
	Game.maybe_spawn_player()

	gems = []
	enemies = []
	for ent in $Entities.get_children():
		if ent.is_in_group("gems"):
			gems.append(ent)
			ent.tree_exiting.connect(on_gem_exiting.bind(ent))
		if ent.is_in_group("enemies"):
			enemies.append(ent)
			ent.died.connect(on_enemy_exiting.bind(ent))

func on_gem_exiting(g):
	gems.erase(g)
	check_win()

func on_enemy_exiting(b):
	enemies.erase(b)
	check_win()

## level complete ###############################################

func check_win():
	if len(gems) == 0 and len(enemies) == 0:
		Hood.notif("Shirt level complete")
		level_complete.emit()
