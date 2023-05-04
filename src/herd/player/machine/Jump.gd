extends State

## enter ###########################################################

var og_pos
var time = 0.5
var ttl
var distance = 150
var dtl
var direction = Vector2.ZERO
var jump_speed = 15000

func enter(opts = {}):
	actor.set_collision_mask_value(1, false)

	# actor.anim.play("jump")

	ttl = Util.get_(opts, "time", time)
	dtl = Util.get_(opts, "distance", distance)
	direction = Util.get_(opts, "direction", actor.input_move_dir)

	og_pos = actor.global_position

	var tween = create_tween()
	tween.tween_property(actor, "scale", Vector2(1.3, 1.3), ttl/2.0)
	tween.tween_property(actor, "scale", Vector2(1.0, 1.0), ttl/2.0)


## exit ###########################################################

func exit():
	actor.set_collision_mask_value(1, true)

## physics ###########################################################

func physics_process(delta):
	if og_pos == null:
		return

	var dist = og_pos.distance_to(actor.global_position)
	ttl -= delta

	if ttl <= 0 or dtl < dist:
		transit("Idle")
		return

	var move_vec = direction * jump_speed * delta
	actor.velocity = actor.velocity.lerp(move_vec, 0.9)
	actor.move_and_slide()
