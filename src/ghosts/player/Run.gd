extends State


func enter(_ctx = {}):
	actor.anim.animation = "run"


func physics_process(delta):
	if not actor.is_on_floor():
		machine.transit("Air")
		return

	var move_dir = Trolley.move_dir()
	actor.velocity.x = actor.speed * move_dir.x
	actor.velocity.y += actor.gravity * delta
	actor.set_velocity(actor.velocity)
	actor.set_up_direction(Vector2.UP)
	actor.move_and_slide()
	actor.velocity = actor.velocity

	if move_dir.x > 0:
		actor.face_right()
	elif move_dir.x < 0:
		actor.face_left()

	if Input.is_action_just_pressed("move_up"):
		machine.transit("Air", {do_jump = true})
	elif is_equal_approx(move_dir.x, 0.0):
		machine.transit("Idle")
