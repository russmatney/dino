extends State


func enter(_msg = {}):
	# owner points to the root node of a packed scene
	owner.velocity = Vector2.ZERO

	owner.anim.animation = "idle"


func process(_delta: float):
	if not owner.is_on_floor():
		machine.transit("Air")

	if Input.is_action_just_pressed("move_up"):
		machine.transit("Air", {do_jump = true})
	elif Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right"):
		machine.transit("Run")
