extends State

var circling
var circle_times = [0.3, 0.5, 0.7]
var circle_ttl
var target_diff

## enter ###########################################################

func enter(opts = {}):
	circling = opts.get("circling")
	circle_ttl = Util.rand_of(circle_times)

	target_diff = Vector2(0, 150) * Util.rand_of([1, -1])


## exit ###########################################################

func exit():
	circling = null
	circle_ttl = null
	target_diff = null


## physics ###########################################################

func physics_process(delta):
	if circling == null or circle_ttl == null:
		return

	circle_ttl -= delta

	if circle_ttl < 0:
		if circling.ready_for_new_attacker():
			# could do a 50/50 shot of approaching here
			transit("Approach", {approaching=circling})
		else:
			transit("Notice", {noticing=circling})
		return

	var target_pos = circling.global_position + target_diff
	var diff = target_pos - actor.global_position
	var new_vel = diff.normalized() * actor.walk_speed/2 * delta
	actor.velocity = actor.velocity.lerp(new_vel, 0.7)
	actor.move_and_slide()

	actor.face_body(circling)
