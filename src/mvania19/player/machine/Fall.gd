extends State


func enter(_ctx={}):
	actor.anim.play("air")

func physics_process(delta):
	# gravity
	if not actor.is_on_floor():
		actor.velocity.y += actor.GRAVITY * delta

	# TODO heavy fall damage and screenshake
	if actor.is_on_floor():
		machine.transit("Idle")

	# apply move dir
	# TODO consider different air horizontal speed
	if actor.move_dir:
		actor.velocity.x = actor.move_dir.x * actor.SPEED
	else:
		actor.velocity.x = move_toward(actor.velocity.x, 0, actor.SPEED)

	actor.move_and_slide()
