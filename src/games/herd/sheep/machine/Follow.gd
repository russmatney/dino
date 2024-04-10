extends State


## enter ###########################################################


func enter(_opts = {}):
	actor.anim.play("follow")

func exit(_opts = {}):
	actor.following = null

## physics ###########################################################

var distance_threshold = 30
var move_speed = 5000


func physics_process(delta):
	if actor.following == null or not is_instance_valid(actor.following):
		transit("Idle", {home_position=actor.global_position})
		return

	var target_vec = actor.following.global_position - actor.global_position
	var dist = target_vec.abs().length()
	if dist > distance_threshold:
		var move_vec = target_vec.normalized() * move_speed * delta
		actor.velocity = actor.velocity.lerp(move_vec, 0.7)
	else:
		actor.velocity = actor.velocity.lerp(Vector2.ZERO, 0.1)

	actor.move_and_slide()
