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

var direction


## enter ###########################################################

func enter(_opts = {}):
	wander_ttl = Util.rand_of(wander_times)
	direction = Util.rand_of(directions)


## exit ###########################################################

func exit():
	wander_ttl = null


## physics ###########################################################

func physics_process(delta):
	if wander_ttl == null:
		return
	wander_ttl -= delta
	if wander_ttl <= 0:
		transit("Idle")
		return

	var new_vel = direction * actor.wander_speed * delta
	actor.velocity = actor.velocity.lerp(new_vel, 0.7)
	actor.move_and_slide()
