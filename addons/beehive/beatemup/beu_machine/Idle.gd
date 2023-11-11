extends State

var wander_in = [1.3, 2.0, 3.5]
var wander_in_t


## enter ###########################################################

func enter(_opts = {}):
	actor.anim.play("idle")
	if actor.should_wander:
		wander_in_t = U.rand_of(wander_in)

## exit ###########################################################

func exit():
	pass

## physics ###########################################################

func physics_process(delta):
	if actor.should_notice:
		if len(actor.notice_box_bodies) > 0:
			transit("Notice", {noticing=actor.notice_box_bodies[0]})
			return

	if actor.should_wander:
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
