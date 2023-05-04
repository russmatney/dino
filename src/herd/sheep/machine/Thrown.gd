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
	actor.set_collision_mask_value(1, false)

	actor.anim.play("thrown")

	ttl = Util.get_(opts, "time", time)
	dtl = Util.get_(opts, "distance", distance)
	direction = Util.get_(opts, "direction", direction)
	throw_speed = Util.get_(opts, "throw_speed", throw_speed)

	og_pos = actor.global_position


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

	var move_vec = direction * throw_speed * delta
	actor.velocity = actor.velocity.lerp(move_vec, 0.9)
	actor.move_and_slide()
