extends State


var drag_in_t = 0.3
var tt_drag

func enter(_msg = {}):
	owner.anim.animation = "drag-reach"
	tt_drag = drag_in_t


func process(delta: float):
	if not Input.is_action_pressed("move_down"):
		machine.transit("Stand")

	if not Input.is_action_pressed("move_left") \
		and not Input.is_action_pressed("move_right"):
		machine.transit("Bucket", {"skip_anim": true})

	tt_drag = tt_drag - delta
	if tt_drag <= 0:
		machine.transit("DragPull")


func physics_process(delta):
	owner.velocity.y += owner.gravity * delta
	owner.velocity = owner.move_and_slide(owner.velocity, Vector2.UP)
