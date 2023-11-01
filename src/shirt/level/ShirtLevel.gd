extends Node2D

var generator

## ready ######################################################

func _ready():
	Debug.pr("Shirt level!")
	Game.maybe_spawn_player()

	for ch in get_children():
		if ch is BrickLevelGen:
			generator = ch

	# TODO regenerate (go down a level) after collecting all gems and defeating all blobs
