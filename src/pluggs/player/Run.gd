extends State


func enter(_ctx = {}):
	owner.anim.animation = "running"


func physics_process(delta):
	if Input.is_action_pressed("move_down"):
		machine.transit("Bucket", {"animate": true})
		# probably not ideal, maybe we want a slow down
		owner.velocity.x = 0
		return

	var move_dir = Trolley.move_dir()
	owner.velocity.x = owner.speed * move_dir.x
	owner.velocity.y += owner.gravity * delta
	owner.set_velocity(owner.velocity)
	owner.set_up_direction(Vector2.UP)
	owner.move_and_slide()
	owner.velocity = owner.velocity

	if move_dir.x > 0:
		owner.face_right()
	elif move_dir.x < 0:
		owner.face_left()

	if is_equal_approx(move_dir.x, 0.0):
		machine.transit("Stand")
