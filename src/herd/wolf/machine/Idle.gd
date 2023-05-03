extends State

## enter ###########################################################


func enter(_opts = {}):
	actor.anim.play("idle")


## physics ###########################################################

func physics_process(_delta):
	if actor.target:
		# TODO transit to a pre-firing stage
		transit("Firing")
		return

	# TODO pause/idle/wander before looking
	actor.find_target()
