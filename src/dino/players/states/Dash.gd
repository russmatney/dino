extends State

var target_pos
var dash_dist = 100

## enter ###########################################################

func enter(_opts = {}):
	target_pos = dash_dist * actor.facing_vector + actor.global_position

## exit ###########################################################

func exit():
	last_pos = null

## physics ###########################################################

var last_pos

func physics_process(_delta):
	# handle getting 'stuck'
	if last_pos and actor.global_position.is_equal_approx(last_pos):
		transit("Fall")
		return
	else:
		last_pos = actor.global_position

	var diff_to_pos = target_pos - actor.global_position

	actor.global_position += diff_to_pos / 5

	actor.move_and_slide()

	var dist = actor.global_position.distance_to(target_pos)
	if dist < 30:
		actor.velocity = Vector2.ZERO
		transit("Idle")
