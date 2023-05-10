extends State

var noticing

var wait_times = [0.7, 1.4]
var wait_ttl


## enter ###########################################################

func enter(opts = {}):
	noticing = opts.get("noticing")

	actor.face_body(noticing)

	wait_ttl = Util.rand_of(wait_times)


## exit ###########################################################

func exit():
	noticing = null
	wait_ttl = null


## physics ###########################################################

func physics_process(delta):
	if not noticing or wait_ttl == null:
		return

	if not noticing in actor.notice_box_bodies:
		transit("Idle")
		return

	wait_ttl -= delta
	if wait_ttl <= 0:
		# is the noticed body busy?
		if noticing.ready_for_new_attacker():
			transit("Approach", {approaching=noticing})
		else:
			transit("Circle", {circling=noticing})
		return

	if actor.velocity.abs().length() > 0:
		actor.velocity = actor.velocity.lerp(Vector2.ZERO, 0.7)
	actor.move_and_slide()
