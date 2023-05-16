extends State

var directions = [Vector2.LEFT, Vector2.RIGHT]
var wander_times = [0.4, 0.9, 1.4]
var wander_ttl

## enter ###########################################################

func enter(_opts = {}):
	actor.anim.play("run")
	wander_ttl = Util.rand_of(wander_times)
	actor.move_vector = Util.rand_of(directions)


## exit ###########################################################

func exit():
	wander_ttl = null
	actor.move_vector = Vector2.ZERO


## physics ###########################################################

func physics_process(delta):
	wander_ttl -= delta

	if wander_ttl <= 0:
		transit("Idle")
		return

	# gravity
	if not actor.is_on_floor():
		actor.velocity.y += actor.gravity * delta

	# wander in direction
	var move_speed = actor.wander_speed * actor.move_vector.x * delta
	actor.velocity.x = lerp(actor.velocity.x, move_speed, 0.6)

	actor.move_and_slide()
