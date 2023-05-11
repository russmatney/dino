extends State

var dying_time = 0.8
var ttl

## enter ###########################################################

func enter(_opts = {}):
	ttl = dying_time

	actor.is_dead = true


## exit ###########################################################

func exit():
	ttl = null


## input ###########################################################

func unhandled_input(_event):
	# TODO support user emotes while dying
	# whatever buttons are pressed
	# play them as piano chords
	pass


## physics ###########################################################

func physics_process(delta):
	if ttl == null:
		return

	ttl -= delta

	if ttl <= 0:
		transit("Respawn")
