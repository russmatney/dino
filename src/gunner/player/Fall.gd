# Fall
extends State

var fall_speed_shake_threshold = 700
var heavy_fall_speed_shake_threshold = 900
var very_heavy_fall_speed_shake_threshold = 1300

func enter(_ctx = {}):
	actor.anim.animation = "fall"
	actor.can_wall_jump = false

func physics_process(delta):
	actor.velocity.y += actor.gravity * delta

	if actor.move_dir:
		actor.velocity.x = actor.air_speed * actor.move_dir.x
	else:
		# slow down
		actor.velocity.x = actor.velocity.x * 0.9 * delta

	actor.velocity.y = clamp(actor.velocity.y, actor.velocity.y, actor.max_fall_speed)

	var vel_before_coll = actor.velocity
	actor.velocity = actor.move_and_slide(actor.velocity, Vector2.UP)

	if not actor.firing:
		actor.update_facing()

	if actor.is_on_floor():
		var shake = false
		var fall_speed = vel_before_coll.y
		print("fall_speed: ", fall_speed)
		if fall_speed >= very_heavy_fall_speed_shake_threshold:
			# TODO player flash color and drop health
			# TODO player hurt sound
			shake = 1.0
			actor.take_damage(null, 1)
		elif fall_speed >= heavy_fall_speed_shake_threshold:
			# TODO player flash color
			shake = 0.6
		elif fall_speed >= fall_speed_shake_threshold:
			shake = 0.3

		if not actor.dead:
			machine.transit("Idle", {"shake": shake})

	if actor.is_on_wall():
		if not actor.can_wall_jump:
			GunnerSounds.play_sound("step")
			actor.can_wall_jump = true

func exit():
	pass
