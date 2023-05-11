extends State

var respawn_time = 0.5
var respawn_ttl

var fall_height = 500

## enter ###########################################################

func enter(_opts = {}):
	respawn_ttl = respawn_time

	var og_pos = actor.position

	var tween = create_tween()
	tween.tween_property(actor, "position", og_pos + Vector2.UP*fall_height, respawn_time/2.0)
	tween.tween_property(actor, "position", og_pos, respawn_time/2.0)
	tween.tween_callback(Cam.screenshake.bind(0.25))


## exit ###########################################################

func exit():
	respawn_ttl = null


## physics ###########################################################

func physics_process(delta):
	if respawn_ttl == null:
		return

	respawn_ttl -= delta

	if respawn_ttl <= 0:
		transit("Idle")
