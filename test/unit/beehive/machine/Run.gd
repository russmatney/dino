extends State


func enter(_ctx = {}):
	pass


func physics_process(delta):
	if not owner.is_on_floor():
		machine.transit("Air")
		return

	var move_dir = Trolley.move_dir()
	owner.velocity.x = owner.speed * move_dir.x
	owner.velocity.y += owner.gravity * delta
	owner.set_velocity(owner.velocity)
	owner.set_up_direction(Vector2.UP)
	owner.move_and_slide()
	owner.velocity = owner.velocity

	if Input.is_action_just_pressed("move_up"):
		machine.transit("Air", {do_jump = true})
	elif is_equal_approx(move_dir.x, 0.0):
		machine.transit("Idle")
