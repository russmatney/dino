extends State


func enter(msg = {}):
	if Util.get_(msg, "animate"):
		# last frame is the bucket 'idle' state, so for now we just let this go and not loop
		actor.anim.play("to-bucket")
	else:
		actor.anim.play("idle-bucket")


func process(_delta: float):
	if not Input.is_action_pressed("move_down"):
		machine.transit("Stand", {"animate": true})

	if Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right"):
		machine.transit("DragReach")
