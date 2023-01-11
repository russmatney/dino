extends State

func enter(_msg = {}):
	actor.velocity = Vector2.ZERO
	actor.anim.animation = "idle"

func process(_delta: float):
	if not actor.is_on_floor():
		machine.transit("Air")

	if Input.is_action_just_pressed("move_up"):
		machine.transit("Air", {do_jump = true})
	elif Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right"):
		machine.transit("Run")

func physics_process(delta):
	actor.velocity.y += actor.gravity * delta
	actor.velocity = actor.move_and_slide(actor.velocity, Vector2.UP)
