extends State

var wander_in = [1.3, 2.0, 3.5]
var wander_in_t


## enter ###########################################################

func enter(_opts = {}):
	if actor.should_wander:
		wander_in_t = Util.rand_of(wander_in)


## physics ###########################################################

func physics_process(delta):
	if actor.should_wander:
		if wander_in_t == null:
			return
		wander_in_t -= delta
		if wander_in_t <= 0:
			transit("Wander")
			return

	if actor.move_vector.abs().length() > 0:
		transit("Walk")
		return

	if actor.velocity.abs().length() > 0:
		actor.velocity = actor.velocity.lerp(Vector2.ZERO, 0.7)

	actor.move_and_slide()
