extends Node2D

@onready var player = $Player
var pins_pulled = false


func _process(_delta):
	# TODO move to player death signal
	if not pins_pulled and player and player.dead:
		pins_pulled = true
		pull_pins()


func pull_pins():
	for ch in get_children():
		if ch.is_in_group("pins"):
			ch.queue_free()

	for ch in $AnglerChainAndLight.get_children():
		if ch.is_in_group("pins"):
			ch.queue_free()
