extends State


func enter(_ctx = {}):
	actor.anim.play("running")


func physics_process(delta):
	if Input.is_action_pressed("move_down"):
		machine.transit("Bucket", {"animate": true})
		# probably not ideal, maybe we want a slow down
		actor.velocity.x = 0
		return

	var move_dir = Trolley.move_vector()
	actor.velocity.x = actor.speed * move_dir.x
	actor.velocity.y += actor.gravity * delta
	actor.set_velocity(actor.velocity)
	actor.move_and_slide()

	if move_dir.x > 0:
		actor.face_right()
	elif move_dir.x < 0:
		actor.face_left()

	if is_equal_approx(move_dir.x, 0.0):
		machine.transit("Stand")
