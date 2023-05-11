extends State

var kicked_time = 0.4
var kicked_ttl
var direction: Vector2
var kicked_by


## enter ###########################################################

func enter(opts = {}):
	DJZ.play(DJZ.S.showjumbotron)
	Cam.screenshake(0.2)
	direction = opts.get("direction", direction)

	kicked_ttl = kicked_time
	kicked_by = opts.get("kicked_by")
	actor.take_damage("kick", kicked_by)

	var tween = create_tween()
	tween.tween_property(actor, "scale", Vector2.ONE*1.2, kicked_time/2.0)
	tween.tween_property(actor, "scale", Vector2.ONE, kicked_time/2.0)


## exit ###########################################################

func exit():
	kicked_ttl = null


## physics ###########################################################

func physics_process(delta):
	if kicked_ttl == null:
		return

	kicked_ttl -= delta

	if kicked_ttl <= 0:
		# TODO stay down for a sec/recovery state?
		transit("Idle")
		return

	var move_vec = direction * actor.kicked_speed * delta
	actor.velocity = actor.velocity.lerp(move_vec, 0.6)
	actor.move_and_slide()
