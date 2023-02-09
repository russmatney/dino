extends State


func enter(ctx = {}):
	if ctx.get("do_jump", false):
		owner.velocity.y -= owner.jump_impulse


func physics_process(delta):
	var move_dir = Trolley.move_dir()

	owner.velocity.x = owner.speed * move_dir.x
	owner.velocity.y += owner.gravity * delta
	owner.set_velocity(owner.velocity)
	owner.set_up_direction(Vector2.UP)
	owner.move_and_slide()
	owner.velocity = owner.velocity

	if owner.is_on_floor():
		if is_equal_approx(owner.velocity.x, 0.0):
			machine.transit("Idle")
		else:
			machine.transit("Run")
