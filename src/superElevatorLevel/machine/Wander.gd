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
	wander_ttl = Util.rand_of(wander_times)
	actor.move_vector = Util.rand_of(directions)


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
			transit("Notice", {noticing=actor.notice_box_bodies[0]})
			return

	wander_ttl -= delta
	if wander_ttl <= 0:
		transit("Idle")
		return

	var new_vel = actor.move_vector * actor.wander_speed * delta
	actor.velocity = actor.velocity.lerp(new_vel, 0.7)
	actor.move_and_slide()
