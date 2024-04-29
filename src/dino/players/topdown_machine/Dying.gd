extends State

var killed_by
var knock_force = 50
var dying_time = 1
var dying_ttl

## enter ###########################################################

func enter(opts = {}):
	U._connect(actor.anim.animation_finished, on_animation_finished, CONNECT_ONE_SHOT)

	if actor.anim.sprite_frames.has_animation("dying"):
		actor.anim.play("dying")
	else:
		actor.anim.stop()
		dying_ttl = dying_time

	killed_by = opts.get("killed_by")
	actor.face_body(killed_by)

	if killed_by:
		var diff = actor.global_position - killed_by.global_position
		actor.velocity += diff.normalized() * knock_force

func on_animation_finished():
	if actor.anim.animation == "dying":
		transit("Dead")

## exit ###########################################################

func exit():
	pass

## physics ###########################################################

func physics_process(delta):
	if dying_ttl != null:
		dying_ttl -= delta
		if dying_ttl <= 0:
			transit("Dead")

	actor.velocity = actor.velocity.lerp(Vector2.ZERO, 1 - pow(0.1, delta))
	actor.move_and_slide()
