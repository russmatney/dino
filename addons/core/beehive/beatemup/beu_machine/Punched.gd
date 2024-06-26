extends State

var punched_time = 0.3
var punched_ttl
var punched_by

## enter ###########################################################

func enter(opts = {}):
	actor.anim.play("punched")
	Sounds.play(Sounds.S.punch)
	punched_by = opts.get("punched_by")
	actor.take_hit({hit_type="punch", body=punched_by})

	punched_ttl = punched_time

	var tween = create_tween()
	tween.tween_property(actor, "scale", Vector2.ONE*1.2, punched_time/2.0)
	tween.tween_property(actor, "scale", Vector2.ONE, punched_time/2.0)


func exit():
	punched_ttl = null
	punched_by = null

## physics ###########################################################


func physics_process(delta):
	if punched_ttl == null:
		return

	punched_ttl -= delta

	if punched_ttl <= 0:
		transit("Idle")
		return

	actor.velocity = Vector2.ZERO
	actor.move_and_slide()
