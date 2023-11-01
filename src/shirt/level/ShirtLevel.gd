extends Node2D

var generator

## ready ######################################################

func _ready():
	Debug.pr("Shirt level!")

	for ch in get_children():
		if ch is BrickLevelGen:
			generator = ch
