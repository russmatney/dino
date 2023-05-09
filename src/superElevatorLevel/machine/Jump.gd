extends State


var og_pos
var jump_time = 0.6
var jump_ttl
var distance = 100
var allowed_dist
var jump_speed = 15000

var direction: Vector2

## enter ###########################################################

func enter(opts = {}):
	Hood.notif("Jumping!")
	og_pos = actor.global_position

	jump_ttl = Util.get_(opts, "jump_time", jump_time)
	allowed_dist = Util.get_(opts, "distance", distance)
	direction = Util.get_(opts, "direction", actor.move_vector)

	var tween = create_tween()
	tween.tween_property(actor, "scale", Vector2.ONE*1.8, jump_ttl/2.0)
	tween.tween_property(actor, "scale", Vector2.ONE, jump_ttl/2.0)


## physics ###########################################################


func physics_process(delta):
	if og_pos == null:
		return

	# var dist_traveled = og_pos.distance_to(actor.global_position)
	jump_ttl -= delta

	if jump_ttl <= 0:
	# Vor dist_traveled > allowed_dist:
		transit("Idle")
		return

	var move_vec = direction * jump_speed * delta
	actor.velocity = actor.velocity.lerp(move_vec, 0.6)
	actor.move_and_slide()
