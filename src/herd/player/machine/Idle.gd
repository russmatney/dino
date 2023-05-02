extends State

## enter ###########################################################


func enter(_arg = {}):
	actor.anim.play("idle")


## process ###########################################################


func process(_delta):
	pass


## physics ###########################################################


func physics_process(_delta):
	var move_dir = actor.input_move_dir

	if move_dir.abs().length() > 0.01:
		transit("Run")

	if actor.velocity.abs().length() > 0:
		# slow down
		actor.velocity = actor.velocity.lerp(Vector2.ZERO, 0.2)

	actor.move_and_slide()
