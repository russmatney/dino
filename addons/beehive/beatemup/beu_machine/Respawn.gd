extends State

var respawn_times = [0.4, 0.45, 0.5, 0.55, 0.6]
var respawn_ttl

var fall_height = 500

## enter ###########################################################

func enter(_opts = {}):
	if actor.cam_pof:
		actor.cam_pof.deactivate()

	actor.health = actor.initial_health
	Hotel.check_in(actor)

	respawn_ttl = Util.rand_of(respawn_times)

	var og_pos = actor.position

	actor.position = og_pos + Vector2.UP * fall_height

	actor.anim.animation_finished.connect(on_animation_finished)
	actor.anim.play("falling")

	var tween = create_tween()
	tween.tween_property(actor, "position", og_pos, respawn_ttl)
	tween.tween_callback(func():
		Cam.screenshake.bind(0.3)
		DJZ.play(DJZ.S.heavy_fall)
		# show shiny invincible couple of seconds
		actor.is_dead = false
		Hotel.check_in(actor)
		actor.anim.play("landed"))


## exit ###########################################################

func exit():
	respawn_ttl = null
	actor.anim.animation_finished.disconnect(on_animation_finished)
	if actor.cam_pof:
		actor.cam_pof.activate()


## anim finished ###########################################################

func on_animation_finished():
	if actor.anim.animation == "landed":
		transit("Idle")


## physics ###########################################################

# func physics_process(delta):
# 	if respawn_ttl == null:
# 		return

# 	respawn_ttl -= delta

# 	if respawn_ttl <= 0:
# 		transit("Idle")