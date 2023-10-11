extends State


func enter(msg = {}):
	if Util.get_(msg, "animate"):
		# actor moves us to idle-standing when this anim finishes
		actor.anim.play("from-bucket")
	else:
		actor.anim.play("idle-standing")


func process(_delta: float):
	if Input.is_action_just_pressed("jump") and actor.is_on_floor():
		machine.transit("Jump")
		return

	if actor.move_vector.x != 0:
		machine.transit("Run")
		return

	if Input.is_action_pressed("move_down"):
		machine.transit("Bucket", {"animate": true})


func physics_process(delta):
	# slow down
	actor.velocity.x = lerp(actor.velocity.x, 0.0, 0.5)

	# gravity
	if not actor.is_on_floor():
		actor.velocity.y += actor.gravity * delta

	actor.move_and_slide()
