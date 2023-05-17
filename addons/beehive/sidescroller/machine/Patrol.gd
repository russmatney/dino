extends State

var patrol_points = []
var target
var threshold_distance = 100.0

var last_target
var jumping

## enter ###########################################################

func enter(_opts = {}):
	actor.anim.play("run")

	if target == null:
		patrol_points = Util.get_children_in_group(actor.get_parent(), "patrol_points", true)
		var pps = patrol_points.filter(func(p): return p != last_target)
		target = Util.rand_of(pps)
		last_target = target

	if target and actor.nav_agent:
		actor.nav_agent.target_position = target.global_position


## exit ###########################################################

func exit():
	actor.move_vector = Vector2.ZERO


## physics ###########################################################

var last_diff

func physics_process(delta):
	if actor.nav_agent == null:
		Debug.warn("No nav_agent found on actor, exiting Patrol state", actor)
		transit("Idle")
		return

	# TODO get next position from actor's agent
	if actor.nav_agent.is_navigation_finished():
		target = null
		transit("Idle")
		return

	var next_position = actor.nav_agent.get_next_path_position()
	var diff = next_position - actor.global_position
	actor.move_vector.x = diff.normalized().x

	# TODO when to jump? probably need a bunch of ray-casts
	if diff.y < -10 and not jumping:
		# Jump!
		jumping = true
		actor.velocity.y = actor.jump_velocity * -1
		Debug.pr("jumping in patrol!", actor.velocity.y)
	else:
		Debug.pr("no need to jump, next pos diff:", diff)

	# TODO get less precise
	if last_diff and last_diff == diff:
		# rebuild the path
		# TODO handle still-stuck after rebuilding this
		actor.nav_agent.target_position = target.global_position
		last_diff = null

	# walk in direction
	var move_speed = actor.wander_speed * actor.move_vector.x * delta

	# this lerp probably makes no sense
	actor.velocity.x = lerp(actor.velocity.x, move_speed, 0.6)

	# gravity
	if not actor.is_on_floor():
		if jumping:
			actor.velocity.y += actor.jump_gravity * delta
		else:
			actor.velocity.y += actor.gravity * delta
	else:
		jumping = false

	actor.move_and_slide()


	# TODO just do path finding
	# TODO jump if....
	# ... target is above us
	# ... wall in our face
	# ... gap we need to get across
