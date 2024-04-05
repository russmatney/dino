extends State

var throw_time = 0.5
var throw_ttl

var thrown

## enter ###########################################################

func enter(opts = {}):
	actor.anim.play("throw")
	thrown = opts.get("body")
	throw_ttl = throw_time

	DJZ.play(DJZ.S.land)


## exit ###########################################################

func exit():
	thrown = null
	throw_ttl = null


## physics ###########################################################

func physics_process(delta):
	if throw_ttl == null:
		return

	throw_ttl -= delta

	if throw_ttl <= 0:
		transit("Idle")
		return
