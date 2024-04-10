extends State

## enter ###########################################################


func enter(_arg = {}):
	actor.anim.play("idle")


## physics ###########################################################


func physics_process(_delta):
	var move_dir = actor.input_move_dir
	if move_dir.abs().length() > 0.01:
		transit("Run")
		return

	# slow down
	if actor.velocity.abs().length() > 0:
		actor.velocity = actor.velocity.lerp(Vector2.ZERO, 0.2)

	actor.move_and_slide()
