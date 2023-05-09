extends State

var punched_time = 0.3
var punched_ttl

## enter ###########################################################

func enter(_opts = {}):
	Hood.notif("Punched!")

	punched_ttl = punched_time

	var tween = create_tween()
	tween.tween_property(actor, "scale", Vector2.ONE*1.2, punched_time/2.0)
	tween.tween_property(actor, "scale", Vector2.ONE, punched_time/2.0)


func exit():
	punched_ttl = null

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
