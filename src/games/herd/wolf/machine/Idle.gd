extends State

## enter ###########################################################


func enter(_opts = {}):
	actor.anim.play("idle")


## physics ###########################################################

func physics_process(_delta):
	if actor.target:
		transit("Firing")
		return

	actor.find_target()
