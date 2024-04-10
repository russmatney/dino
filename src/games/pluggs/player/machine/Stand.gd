extends State

var to_bucket_time = 1.4
var to_bucket_ttl

func enter(msg = {}):
	if U.get_(msg, "animate"):
		# actor moves us to idle-standing when this anim finishes
		actor.anim.play("from-bucket")
		to_bucket_ttl = to_bucket_time + 0.5
	else:
		actor.anim.play("idle-standing")
		to_bucket_ttl = to_bucket_time

func exit():
	to_bucket_ttl = null

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
	if to_bucket_ttl != null:
		to_bucket_ttl -= delta
		if to_bucket_ttl < 0:
			machine.transit("Bucket", {"animate": true})
			return

	# slow down
	actor.velocity.x = lerp(actor.velocity.x, 0.0, 0.7)

	if not actor.is_on_floor():
		actor.velocity.y += actor.gravity * delta

	actor.move_and_slide()
