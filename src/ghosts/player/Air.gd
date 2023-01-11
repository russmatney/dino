extends State


func enter(ctx = {}):
	actor.anim.animation = "air"

	if ctx.get("do_jump", false):
		actor.velocity.y -= actor.jump_impulse


func physics_process(delta):
	var move_dir = Trolley.move_dir()

	actor.velocity.x = actor.speed * move_dir.x
	actor.velocity.y += actor.gravity * delta
	actor.velocity = actor.move_and_slide(actor.velocity, Vector2.UP)

	if actor.is_on_floor():
		if is_equal_approx(actor.velocity.x, 0.0):
			machine.transit("Idle")
		else:
			machine.transit("Run")
