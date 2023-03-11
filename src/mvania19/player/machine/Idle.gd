extends State

func enter(_ctx={}):
	actor.anim.play("idle")

func physics_process(delta):
	if Input.is_action_just_pressed("jump") and actor.is_on_floor() \
		and actor.can_execute_any_actions():
		machine.transit("Jump")
		return

	if actor.move_dir.x != 0:
		machine.transit("Run")
		return

	# slow down
	actor.velocity.x = move_toward(actor.velocity.x, 0, actor.SPEED)

	# gravity
	if not actor.is_on_floor():
		actor.velocity.y += actor.GRAVITY * delta

	actor.move_and_slide()
