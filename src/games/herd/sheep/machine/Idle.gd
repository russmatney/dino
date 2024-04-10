extends State

var hop_every = [1.4, 2.8, 0.7]
var hop_in

var home_position

## enter ###########################################################

func enter(opts = {}):
	actor.anim.play("idle")
	hop_in = U.rand_of(hop_every)

	home_position = opts.get("home_position", home_position)


## physics ###########################################################

func physics_process(delta):
	hop_in -= delta

	if hop_in <= 0:
		transit("Hop", {home_position=home_position})
		return

	# slow down
	if actor.velocity.abs().length() > 0:
		actor.velocity = actor.velocity.lerp(Vector2.ZERO, 0.2)

	actor.move_and_slide()
