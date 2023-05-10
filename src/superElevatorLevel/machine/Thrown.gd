extends State

var thrown_time = 0.6
var thrown_ttl
var throw_speed_fallback = 12000
var thrown_speed
var thrown_by

var direction

## enter ###########################################################

func enter(opts = {}):
	Hood.notif("Thrown!")

	thrown_ttl = Util.get_(opts, "thrown_time", thrown_time)
	direction = Util.get_(opts, "direction", direction)
	thrown_by = Util.get_(opts, "thrown_by", thrown_by)

	if thrown_by:
		thrown_speed = thrown_by.throw_speed
	else:
		thrown_speed = throw_speed_fallback

	var tween = create_tween()
	tween.tween_property(actor, "scale", Vector2.ONE*1.8, thrown_ttl/2.0)
	tween.tween_property(actor, "scale", Vector2.ONE, thrown_ttl/2.0)


## exit ###########################################################

func exit():
	direction = null
	thrown_by = null

## physics ###########################################################


func physics_process(delta):
	if thrown_ttl == null:
		return

	thrown_ttl -= delta

	if thrown_ttl <= 0:
		transit("Idle")
		return

	var move_vec = direction * thrown_speed * delta
	actor.velocity = actor.velocity.lerp(move_vec, 0.6)
	actor.move_and_slide()
