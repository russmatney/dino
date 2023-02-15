extends State

func enter(_ctx={}):
	actor.anim.play("run")

func physics_process(delta):
	if Input.is_action_just_pressed("jump"):
		machine.transit("Jump")

	# gravity
	if not actor.is_on_floor():
		actor.velocity.y += actor.GRAVITY * delta

	# apply move dir
	if actor.move_dir:
		actor.velocity.x = actor.move_dir.x * actor.SPEED
	else:
		actor.velocity.x = move_toward(actor.velocity.x, 0, actor.SPEED)

	actor.move_and_slide()

	if actor.velocity.y > 0:
		machine.transit("Fall", {"coyote_time": true})

	if abs(actor.velocity.x) < 1:
		machine.transit("Idle")
