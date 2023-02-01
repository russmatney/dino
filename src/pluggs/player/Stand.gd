extends State


func enter(msg = {}):
	if "animate" in msg and msg["animate"]:
		# owner moves us to idle-standing when this anim finishes
		owner.anim.animation = "from-bucket"
	else:
		owner.anim.animation = "idle-standing"


func process(_delta: float):
	if Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right"):
		machine.transit("Run")
	elif Input.is_action_pressed("move_down"):
		machine.transit("Bucket", {"animate": true})


func physics_process(delta):
	owner.velocity.y += owner.gravity * delta
	owner.velocity = owner.move_and_slide(owner.velocity, Vector2.UP)
