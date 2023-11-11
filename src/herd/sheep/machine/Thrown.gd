extends State


## enter ###########################################################

var og_pos
var time = 0.5
var ttl
var distance = 200
var dtl
var direction = Vector2.ZERO
var throw_speed = 15000

func enter(opts = {}):
	og_pos = actor.global_position

	actor.set_collision_mask_value(10, false)
	actor.set_collision_mask_value(11, false)

	actor.anim.play("thrown")

	ttl = U.get_(opts, "time", time)
	dtl = U.get_(opts, "distance", distance)
	direction = U.get_(opts, "direction", direction)
	throw_speed = U.get_(opts, "throw_speed", throw_speed)

	var tween = create_tween()
	tween.tween_property(actor, "scale", Vector2(1.5, 1.5), ttl/2.0)
	tween.tween_property(actor, "scale", Vector2(1.0, 1.0), ttl/2.0)


func exit():
	actor.set_collision_mask_value(10, true)
	actor.set_collision_mask_value(11, true)


## physics ###########################################################

func physics_process(delta):
	if og_pos == null:
		return

	var dist = og_pos.distance_to(actor.global_position)
	ttl -= delta

	if ttl <= 0 or dtl < dist:
		transit("Idle", {home_position=actor.global_position})
		return

	var move_vec = direction * throw_speed * delta
	actor.velocity = actor.velocity.lerp(move_vec, 0.9)
	actor.move_and_slide()
