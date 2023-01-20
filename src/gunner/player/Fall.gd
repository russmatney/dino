# Fall
extends State

var initial_y
var fall_distance_shake_threshold = 90 # bit more than jump height
var heavy_fall_distance_shake_threshold = 150
var huge_fall_distance_shake_threshold = 400

func enter(_ctx = {}):
	actor.anim.animation = "fall"
	actor.can_wall_jump = false
	initial_y = actor.global_position.y

func physics_process(delta):
	actor.velocity.y += actor.gravity * delta

	if actor.move_dir:
		actor.velocity.x = actor.air_speed * actor.move_dir.x
		# TODO clamp fall speed
	else:
		# slow down
		actor.velocity.x = actor.velocity.x * 0.9 * delta

	actor.velocity = actor.move_and_slide(actor.velocity, Vector2.UP)

	if not actor.firing:
		actor.update_facing()

	if actor.is_on_floor():
		var shake = false
		var fall_distance = actor.global_position.y - initial_y
		if fall_distance >= huge_fall_distance_shake_threshold:
			# TODO player flash color and drop health
			shake = 1.0
		elif fall_distance >= heavy_fall_distance_shake_threshold:
			# TODO player flash color
			shake = 0.6
		elif fall_distance >= fall_distance_shake_threshold:
			shake = 0.3
		machine.transit("Idle", {"shake": shake})

	if actor.is_on_wall():
		if not actor.can_wall_jump:
			GunnerSounds.play_sound("step")
			actor.can_wall_jump = true

func exit():
	pass
