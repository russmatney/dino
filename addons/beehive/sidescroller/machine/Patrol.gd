extends State

var patrol_points = []
var target
var threshold_distance = 100.0

## enter ###########################################################

func enter(_opts = {}):
	actor.anim.play("run")

	patrol_points = Util.get_children_in_group(actor.get_parent(), "patrol_points", true)
	target = Util.rand_of(patrol_points)

	var dir = (target.global_position - actor.global_position).normalized()
	actor.move_vector.x = dir.x


## exit ###########################################################

func exit():
	actor.move_vector = Vector2.ZERO


## physics ###########################################################

func physics_process(delta):

	# gravity
	if not actor.is_on_floor():
		actor.velocity.y += actor.gravity * delta

	# wander in direction
	var move_speed = actor.wander_speed * actor.move_vector.x * delta
	actor.velocity.x = lerp(actor.velocity.x, move_speed, 0.6)

	var distance = (target.global_position - actor.global_position).length()
	# Debug.pr(actor, "dist from target: ", distance, "target: ", target.global_position)

	actor.move_and_slide()

	if threshold_distance > distance:
		Debug.pr(actor, "reached target")
		transit("Idle")

	# TODO just do path finding
	# TODO jump if....
	# ... target is above us
	# ... wall in our face
	# ... gap we need to get across
