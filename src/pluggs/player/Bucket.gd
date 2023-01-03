extends State

func enter(msg = {}):
	if "skip_anim" in msg and msg["skip_anim"]:
		owner.anim.animation = "bucket"
	else:
		# last frame is the bucket 'idle' state, so for now we just let this go and not loop
		owner.anim.animation = "to-bucket"

func process(_delta: float):
	if not Input.is_action_pressed("move_down"):
		machine.transit("Stand")

	if Input.is_action_pressed("move_left") \
		or Input.is_action_pressed("move_right"):
		machine.transit("DragReach")
