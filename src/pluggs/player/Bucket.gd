extends State

func enter(msg = {}):
	if "animate" in msg and msg["animate"]:
		# last frame is the bucket 'idle' state, so for now we just let this go and not loop
		owner.anim.animation = "to-bucket"
	else:
		owner.anim.animation = "bucket"

func process(_delta: float):
	if not Input.is_action_pressed("move_down"):
		machine.transit("Stand", {"animate": true})

	if Input.is_action_pressed("move_left") \
		or Input.is_action_pressed("move_right"):
		machine.transit("DragReach")
