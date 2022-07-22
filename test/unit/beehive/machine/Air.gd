extends State


func enter(ctx = {}):
	if ctx.get("do_jump", false):
		owner.velocity.y -= owner.jump_impulse


func physics_process(delta):
	var move_dir = Trolley.move_dir()

	owner.velocity.x = owner.speed * move_dir.x
	owner.velocity.y += owner.gravity * delta
	owner.velocity = owner.move_and_slide(owner.velocity, Vector2.UP)

	if owner.is_on_floor():
		if is_equal_approx(owner.velocity.x, 0.0):
			machine.transit("Idle")
		else:
			machine.transit("Run")
