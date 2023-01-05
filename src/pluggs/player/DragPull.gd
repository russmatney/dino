extends State

var drag_for_t = 0.3
var tt_reach

func enter(_msg = {}):
	owner.anim.animation = "drag-pull"
	tt_reach = drag_for_t

func exit(_msg = {}):
	# TODO not ideal, really we want a way to contrib a vector to velocity (steering)
	owner.velocity.x = 0

func process(delta: float):
	if not Input.is_action_pressed("move_down"):
		machine.transit("Stand", {"animate": true})

	if not Input.is_action_pressed("move_left") \
		and not Input.is_action_pressed("move_right"):
		machine.transit("Bucket", {"animate": false})

	var move_dir = Trolley.move_dir()
	if move_dir.x > 0:
		owner.face_right()
	elif move_dir.x < 0:
		owner.face_left()

	tt_reach = tt_reach - delta
	if tt_reach <= 0:
		machine.transit("DragReach")


func physics_process(delta):
	var move_dir = Trolley.move_dir()
	owner.velocity.x = owner.drag_speed * move_dir.x
	owner.velocity.y += owner.gravity * delta
	owner.velocity = owner.move_and_slide(owner.velocity, Vector2.UP)
