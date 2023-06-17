extends State

var knocked_by
var knock_force = 50

## enter ###########################################################

func enter(opts = {}):
	Util._connect(actor.anim.animation_finished, on_animation_finished, CONNECT_ONE_SHOT)
	actor.anim.play("knocked_back")
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
	actor.velocity = actor.velocity.lerp(Vector2.ZERO, 1 - pow(0.1, delta))
	actor.move_and_slide()
