extends State

var wander_times = [1.4, 0.9, 2.5]
var wander_ttl

var directions = [
	Vector2.LEFT,
	Vector2.RIGHT,
	Vector2.UP,
	Vector2.DOWN,
	]


## enter ###########################################################

func enter(_opts = {}):
	wander_ttl = U.rand_of(wander_times)
	actor.move_vector = U.rand_of(directions)
	actor.update_facing()


## exit ###########################################################

func exit():
	actor.move_vector = Vector2.ZERO


## physics ###########################################################

func physics_process(delta):
	actor.update_run_anim()

	if actor.should_notice:
		if len(actor.notice_box_bodies) > 0:
			var noticing = actor.notice_box_bodies[0]
			if is_instance_valid(noticing):
				transit("Notice", {noticing=noticing})
				return

	wander_ttl -= delta
	if wander_ttl <= 0:
		transit("Idle")
		return

	var new_vel = actor.move_vector * actor.wander_speed * delta
	actor.velocity = actor.velocity.lerp(new_vel, 0.7)
	actor.move_and_slide()

	if (actor.move_vector.abs().x > 0 and actor.is_on_wall()) \
		or (actor.move_vector.abs().y > 0 and (actor.is_on_ceiling() or actor.is_on_floor())):
		actor.move_vector *= -1 * Vector2.ONE
		actor.update_facing()
