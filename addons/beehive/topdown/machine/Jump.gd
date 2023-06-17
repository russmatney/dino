extends State


var jump_time = 0.6
var jump_ttl
var jump_scale_factor = 1.7

var direction: Vector2

## enter ###########################################################

func enter(opts = {}):
	actor.anim.play("jump")
	DJZ.play(DJZ.S.jump)
	jump_ttl = Util.get_(opts, "jump_time", jump_time)
	direction = Util.get_(opts, "direction", actor.move_vector)

	var tween = create_tween()
	tween.tween_property(actor, "scale", Vector2.ONE*jump_scale_factor, jump_ttl/2.0)
	tween.tween_property(actor, "scale", Vector2.ONE, jump_ttl/2.0)

	# disable low-wall collisions
	actor.set_collision_mask_value(11, false)

	if actor.pit_detector:
		actor.pit_detector.deactivate()


## exit ###########################################################

func exit():
	# re-enable low-wall collisions
	actor.set_collision_mask_value(11, true)

	if actor.pit_detector:
		actor.pit_detector.activate()


## input ###########################################################

func unhandled_input(_event):
	pass


## physics ###########################################################

func physics_process(delta):
	jump_ttl -= delta

	if jump_ttl <= 0:
		transit("Idle")
		return

	var move_vec = direction * actor.jump_speed * delta
	actor.velocity = actor.velocity.lerp(move_vec, 0.6)
	actor.move_and_slide()
