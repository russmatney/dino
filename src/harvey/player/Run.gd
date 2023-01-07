extends State


func enter(_ctx = {}):
	owner.anim.animation = "run"


func physics_process(_delta):
	var move_dir = Trolley.move_dir()
	owner.velocity = owner.speed * move_dir
	owner.velocity = owner.move_and_slide(owner.velocity, Vector2.UP)

	if move_dir.x > 0:
		owner.face_right()
	elif move_dir.x < 0:
		owner.face_left()

	if is_equal_approx(move_dir.x, 0.0) and is_equal_approx(move_dir.y, 0.0):
		machine.transit("Idle")
