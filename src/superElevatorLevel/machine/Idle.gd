extends State

## enter ###########################################################


func enter(_opts = {}):
	pass


## physics ###########################################################


func physics_process(_delta):
	if actor.move_vector.abs().length() > 0:
		transit("Walk")
		return

	if actor.velocity.abs().length() > 0:
		actor.velocity = actor.velocity.lerp(Vector2.ZERO, 0.7)

	actor.move_and_slide()
