extends State


func enter(_ctx = {}):
	actor.anim.animation = "run"


func physics_process(_delta):
	var move_dir = actor.get_move_dir()
	if move_dir:
		actor.velocity = actor.speed * move_dir
		actor.velocity = actor.move_and_slide(actor.velocity, Vector2.UP)

		if move_dir.x > 0:
			actor.face_right()
		elif move_dir.x < 0:
			actor.face_left()

		if is_equal_approx(move_dir.x, 0.0) and is_equal_approx(move_dir.y, 0.0):
			machine.transit("Idle")
	else:
		machine.transit("Idle")
