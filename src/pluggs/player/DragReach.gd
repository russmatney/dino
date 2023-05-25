extends State

var drag_in_t = 0.3
var tt_drag


func enter(_msg = {}):
	actor.anim.play("drag-reach")
	tt_drag = drag_in_t


func process(delta: float):
	if not Input.is_action_pressed("move_down"):
		machine.transit("Stand", {"animate": true})

	if not Input.is_action_pressed("move_left") and not Input.is_action_pressed("move_right"):
		machine.transit("Bucket", {"animate": false})

	var move_dir = Trolley.move_vector()
	if move_dir.x > 0:
		actor.face_right()
	elif move_dir.x < 0:
		actor.face_left()

	tt_drag = tt_drag - delta
	if tt_drag <= 0:
		machine.transit("DragPull")


func physics_process(delta):
	actor.velocity.y += actor.gravity * delta
	actor.set_velocity(actor.velocity)
	actor.move_and_slide()
