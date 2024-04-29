extends State

var knocked_by
var knock_force = 50
var knocked_back_time = 1
var kb_ttl

## enter ###########################################################

func enter(opts = {}):
	U._connect(actor.anim.animation_finished, on_animation_finished, CONNECT_ONE_SHOT)
	if actor.anim.sprite_frames.has_animation("knocked_back"):
		actor.anim.play("knocked_back")
		kb_ttl = knocked_back_time * 2 # fallback
	else:
		actor.anim.stop()
		kb_ttl = knocked_back_time
	knocked_by = opts.get("knocked_by")
	actor.face_body(knocked_by)

	if knocked_by:
		var diff = actor.global_position - knocked_by.global_position
		actor.velocity = diff.normalized() * knock_force

func on_animation_finished():
	if actor.anim.animation == "knocked_back":
		transit("Idle")

## exit ###########################################################

func exit():
	pass

## physics ###########################################################

func physics_process(delta):
	if kb_ttl != null:
		kb_ttl -= delta
		if kb_ttl <= 0:
			transit("Idle")

	actor.velocity = actor.velocity.lerp(Vector2.ZERO, 1 - pow(0.1, delta))
	actor.move_and_slide()
