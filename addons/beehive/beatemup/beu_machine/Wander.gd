extends State

var wander_times = [0.4, 0.9, 0.5]
var wander_ttl

var directions = [
	Vector2.LEFT,
	Vector2.RIGHT,
	Vector2.UP + Vector2.RIGHT,
	Vector2.UP + Vector2.LEFT,
	Vector2.DOWN + Vector2.RIGHT,
	Vector2.DOWN + Vector2.LEFT,
	]


## enter ###########################################################

func enter(_opts = {}):
	actor.anim.play("walk")
	wander_ttl = U.rand_of(wander_times)
	actor.move_vector = U.rand_of(directions)


## exit ###########################################################

func exit():
	wander_ttl = null
	actor.move_vector = Vector2.ZERO


## physics ###########################################################

func physics_process(delta):
	if wander_ttl == null:
		return

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
