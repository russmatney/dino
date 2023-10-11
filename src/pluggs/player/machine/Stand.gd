extends State


func enter(msg = {}):
	if Util.get_(msg, "animate"):
		# actor moves us to idle-standing when this anim finishes
		actor.anim.play("from-bucket")
	else:
		actor.anim.play("idle-standing")


func process(_delta: float):
	if Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right"):
		machine.transit("Run")
	elif Input.is_action_pressed("move_down"):
		machine.transit("Bucket", {"animate": true})


func physics_process(delta):
	actor.velocity.y += actor.gravity * delta
	actor.set_velocity(actor.velocity)
	actor.move_and_slide()
