extends State

func enter(_ctx={}):
	actor.anim.play("idle")

func physics_process(delta):
	if Input.is_action_just_pressed("jump") and actor.is_on_floor():
		machine.transit("Jump")

	if actor.move_dir.x != 0:
		machine.transit("Run")

	# slow down
	actor.velocity.x = move_toward(actor.velocity.x, 0, actor.SPEED)

	# gravity
	if not actor.is_on_floor():
		actor.velocity.y += actor.GRAVITY * delta

	actor.move_and_slide()
