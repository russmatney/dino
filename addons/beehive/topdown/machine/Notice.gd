extends State

var noticing

var wait_times = [0.7, 1.4]
var wait_ttl


## enter ###########################################################

func enter(opts = {}):
	# add exclamation mark, like botw

	noticing = opts.get("noticing")
	actor.face_body(noticing)
	actor.update_idle_anim()
	wait_ttl = U.rand_of(wait_times)


## exit ###########################################################

func exit():
	pass


## physics ###########################################################

func physics_process(delta):
	if not is_instance_valid(noticing):
		transit("Idle")
		return

	if not noticing in actor.notice_box_bodies:
		transit("Idle")
		return

	wait_ttl -= delta
	if wait_ttl <= 0:
		# tick down noticing exclamation mark/bar
		if is_instance_valid(noticing):
			transit("Chase", {chasing=noticing})
		return

	# slow down
	if actor.velocity.abs().length() > 0:
		actor.velocity = actor.velocity.lerp(Vector2.ZERO, 0.7)
	actor.move_and_slide()
