extends State

var hit_time = 0.4
var hit_ttl
var direction: Vector2
var hit_by


## enter ###########################################################

func enter(opts = {}):
	actor.anim.play("kicked")

	DJZ.play(DJZ.S.kick)
	Cam.screenshake(0.2)
	direction = opts.get("direction", direction)

	hit_ttl = hit_time
	hit_by = opts.get("hit_by")
	actor.take_damage("hit_by_throw", hit_by)

	var tween = create_tween()
	tween.tween_property(actor, "scale", Vector2.ONE*1.2, hit_time/2.0)
	tween.tween_property(actor, "scale", Vector2.ONE, hit_time/2.0)


## exit ###########################################################

func exit():
	hit_ttl = null


## physics ###########################################################

func physics_process(delta):
	if hit_ttl == null:
		return

	hit_ttl -= delta

	if hit_ttl <= 0:
		# TODO stay down for a sec/recovery state?
		transit("Idle")
		return

	var move_vec = direction * actor.kicked_speed/2 * delta
	actor.velocity = actor.velocity.lerp(move_vec, 0.6)
	actor.move_and_slide()