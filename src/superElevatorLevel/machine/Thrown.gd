extends State

var thrown_time = 0.8
var thrown_ttl
var thrown_speed
var thrown_by

var direction

## enter ###########################################################

func enter(opts = {}):
	thrown_ttl = Util.get_(opts, "thrown_time", thrown_time)
	direction = Util.get_(opts, "direction", direction)
	thrown_by = Util.get_(opts, "thrown_by", thrown_by)

	thrown_speed = thrown_by.throw_speed
	thrown_by.remove_attacker(actor)

	var tween = create_tween()
	tween.tween_property(actor, "scale", Vector2.ONE*1.8, thrown_ttl/3.0)
	tween.tween_property(actor, "scale", Vector2.ONE, thrown_ttl/3.0)
	tween.tween_callback(func():
		actor.take_damage("throw", thrown_by)
		DJZ.play(DJZ.S.heavy_fall)
		Cam.screenshake(0.3))
	tween.tween_property(actor, "scale", Vector2.ONE*1.4, thrown_ttl/6.0)
	tween.tween_property(actor, "scale", Vector2.ONE, thrown_ttl/6.0)


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
		# TODO: transit("Recover/GetUp/Stand")
		transit("Idle")
		return

	var move_vec = direction * thrown_speed * delta
	actor.velocity = actor.velocity.lerp(move_vec, 0.6)
	actor.move_and_slide()
