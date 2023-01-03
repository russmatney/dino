extends State


func enter(_ctx = {}):
	owner.anim.animation = "running"


func physics_process(delta):
	var move_dir = Trolley.move_dir()
	owner.velocity.x = owner.speed * move_dir.x
	owner.velocity.y += owner.gravity * delta
	owner.velocity = owner.move_and_slide(owner.velocity, Vector2.UP)

	# if move_dir.x > 0:
	# 	owner.face_right()
	# elif move_dir.x < 0:
	# 	owner.face_left()

	if is_equal_approx(move_dir.x, 0.0):
		machine.transit("Stand")
