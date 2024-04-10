extends State

## enter ###########################################################

var fire_time = 1.0
var fire_ttl

func enter(_opts = {}):
	actor.anim.play("firing")

	fire_ttl = fire_time


## physics ###########################################################


func physics_process(delta):
	fire_ttl -= delta

	if fire_ttl <= 0:
		if actor.target:
			actor.fire()
		else:
			transit("Idle")
